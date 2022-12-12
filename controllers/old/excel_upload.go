package controllers

import (
	"strings"
	"os"
	"os/exec"
	"context"
	"io"
	"bufio"
	"errors"
	"mime/multipart"
	"fmt"
	"time"
	"strconv"
	"reflect"
	"bytes"
	
	"dpassport/models"

	"ds/pgds"
	"osbe"
	"osbe/logger"
	"osbe/fields"
	"osbe/socket"
	"osbe/response"
	"osbe/model"
	"osbe/view"
	"osbe/srv/httpSrv"

	"github.com/jackc/pgx/v4/pgxpool"
	"github.com/jackc/pgx/v4"
	"github.com/xuri/excelize/v2"
)

const EXCEL_FIELD_DELIM = "@"
const DOC_CNT_INSERT = 100

const (
	ER_NOT_ALLOWED_CODE = 1050
	ER_NOT_ALLOWED_DESCR = "Запрещена загрузка по чужой организации"
)

type studyDocument struct {
	models.StudyDocument
	Company_search string `json:"company_search"` //Значение для поиска компании
}

type studyDocumentRegister struct {
	models.StudyDocumentRegister
	Snils string //slils value MUST exist in file!
	Company_search string `json:"company_search"` //Значение для поиска компании
}

type excelDocumentRecord struct {
	Error error
	Document *studyDocument //parsed document
	Preview map[string]string //string values
	IsHeader bool
	Values []string //original values for error file
}

type excelDocumentRegisterRecord struct {
	Error error
	Document *studyDocumentRegister //parsed document
	Preview map[string]string //string values
	IsHeader bool
	Values []string //original values for error file
}

type columnMap map[string]models.ExcelUploadFieldDescr

type scanner interface {
	Scan(interface{}) error
}

func endUserOperationWithError(log logger.Logger, conn *pgx.Conn, userID int64, operationID string, userErr error) {
	er_descr := ""
	if userErr == nil {
		er_descr = "Неизвестная ошибка"
	}else{
		er_descr = userErr.Error()
	}
	if _, err := conn.Exec(context.Background(), 
		`UPDATE user_operations
		SET
			status = 'end',
			error_text = $1,
			date_time_end = now()
		WHERE user_id = $2 AND operation_id = $3`,
		er_descr,
		userID,
		operationID,				
	); err != nil {
		log.Errorf("endUserOperationWithError: %v", err)
	}		
}

//returns opened TXT file, should be closed and removed after use
//param file - uploaded file
func convertExcelFile(file multipart.File) (*os.File, error) {
	fl_id := genUniqID(10)
	txt_fn := CACHE_PATH + fl_id +".txt"
	excel_fn := CACHE_PATH + fl_id+".xlsx"
	excel_f, err := os.OpenFile(excel_fn, os.O_WRONLY|os.O_CREATE, 0666)
	if err != nil {		
		return nil, errors.New(fmt.Sprintf("excel file os.OpenFile(): %v",err))
	}
	defer excel_f.Close()
	io.Copy(excel_f, file)
	defer os.Remove(excel_fn)
		
	//cmd := exec.Command("ssconvert", "-O", "separator="+string(EXCEL_FIELD_DELIM)+" format=raw", excel_fn, txt_fn)
	cmd := exec.Command("ssconvert", "-O", "separator="+string(EXCEL_FIELD_DELIM), excel_fn, txt_fn)		
	if err := cmd.Run(); err != nil { 
		return nil, errors.New(fmt.Sprintf("exec.Command(): %v",err))
	}
	if _, err := os.Stat(txt_fn); os.IsNotExist(err) {
		return nil,  errors.New(fmt.Sprintf("os.Stat(): %v",err))
	}	
	txt_file, err := os.Open(txt_fn)
	if err != nil {
		return nil,  errors.New(fmt.Sprintf("txt file os.Open(): %v",err))
	}
	
	return txt_file, nil
}


func uploadStudyDocuments(dStore *pgds.PgProvider, log logger.Logger, file multipart.File, colMap columnMap, userID int64, userDescr, operationID string, companyID int64) {
	defer file.Close()
	//db connect
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := dStore.GetPrimary() 
	if err_с != nil {
		log.Errorf("uploadStudyDocuments: %v", err_с)
		return
	}
	defer dStore.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	//convert file
	txt_file, err := convertExcelFile(file)	
	if err != nil {
		endUserOperationWithError(log, conn, userID, operationID, err)
		return
	}
	defer txt_file.Close()
	txt_file_nm := txt_file.Name()
	defer os.Remove(txt_file_nm)
	
	if _, err := conn.Exec(context.Background(), `BEGIN`); err != nil {
		endUserOperationWithError(log, conn, userID, operationID, err)
	}
	//20 columns, 19 parameters
	query_header := `INSERT INTO study_documents
		(create_type, company_id, user_id, issue_date, end_date, post, work_place, organization, study_type, series,
		number, study_prog_name, profession, reg_number, study_period, name_first, name_second, name_middle, qualification_name, snils)
		VALUES `
	
	doc_cnt := 0
	doc_cnt_ins := 0
	doc_ins_params := make([]interface{},0)
	doc_ins_param_cnt := 0
	doc_ins_q := ""
	
	var err_str string
	var header []string
	var error_excel_f *excelize.File
	var error_excel_row int
	var error_excel_sheet_name string
	
	for doc := range extractStudyDocuments(conn, txt_file, colMap, 0, true) {        	
		if doc.Error != nil {
			if err_str != "" {
				err_str += " "
			}
			err_str += doc.Error.Error()
			if error_excel_f == nil {
				error_excel_f = excelize.NewFile()
				//header
				error_excel_row = 1
				error_excel_sheet_name = "Sheet1"				
				for i, col_v := range header {					
					cell := getExcelCellRowForIndex(i)
					error_excel_f.SetCellValue(error_excel_sheet_name, cell+ fmt.Sprintf("%d", error_excel_row), col_v)
				}
				error_excel_row++
			}
			for i, col_v := range doc.Values {
				cell := getExcelCellRowForIndex(i)
				error_excel_f.SetCellValue(error_excel_sheet_name, cell+ fmt.Sprintf("%d", error_excel_row), col_v)
			}
			error_excel_row++
			continue
			
		}else if doc.IsHeader {
			//header for error file
			header = make([]string, len(doc.Values))
			copy(header, doc.Values)
			continue
		}
		
		//Компания
		if companyID == 0 {
			//не используется такое!!!
			company_id := getCompanyID(doc.Document.Company_search, doc_cnt, log, conn, userID, operationID)
			if company_id == 0 {
				return
			}
			doc.Document.Company_id.SetValue(company_id)
		}else{
			doc.Document.Company_id.SetValue(companyID)
		}
		
		//Correct SNILS
		doc.Document.Snils.SetValue(UnformatSnils(doc.Document.Snils.GetValue()))
		
		//user
		if doc.Document.Snils.GetValue() == "" {
			if _, err := conn.Exec(context.Background(), `ROLLBACK`); err != nil {
				endUserOperationWithError(log, conn, userID, operationID, err)
			}else{
				endUserOperationWithError(log, conn, userID, operationID, errors.New(fmt.Sprintf("Строка: %d, не задан СНИЛС!", doc_cnt)))
			}
			return
		}
		// AND (company_id = $2 OR company_id IN (SELECT t.id FROM clients t WHERE t.parent_id = $2))
		err := conn.QueryRow(context.Background(),
			`SELECT id FROM users WHERE snils = $1`,
			doc.Document.Snils).Scan(&doc.Document.User_id)			

		if err == pgx.ErrNoRows {
			//add user
			name_full := doc.Document.Name_second.GetValue()
			if doc.Document.Name_first.GetValue() != "" {
				name_full+= " "+doc.Document.Name_first.GetValue()
			}
			if doc.Document.Name_middle.GetValue() != "" {
				name_full+= " "+doc.Document.Name_middle.GetValue()
			}
			if err_i := conn.QueryRow(context.Background(),
				`INSERT INTO users
				(snils, role_id, name_full, post, locale_id, company_id)
				VALUES ($1, 'person', $2, $3, 'ru', $4)
				RETURNING id`,
				doc.Document.Snils,
				name_full,
				doc.Document.Post,
				doc.Document.Company_id).Scan(&doc.Document.User_id); err_i != nil {
				
				if _, err_t := conn.Exec(context.Background(), `ROLLBACK`); err_t != nil {
					endUserOperationWithError(log, conn, userID, operationID, err_t)
				}else{
					endUserOperationWithError(log, conn, userID, operationID, err_i)
				}
			}
			
		}else if err != nil {
			conn.Exec(context.Background(), `ROLLBACK`)
			endUserOperationWithError(log, conn, userID, operationID, err)
		}
		
		//Необходимые действия по подстановке пользователя сделаны в триггире: поиск по СНИЛС, создание нового, если надо
		
		//insert/update doc
		if doc_ins_q != "" {
			doc_ins_q+= ", "
		}
		doc_ins_q+= fmt.Sprintf("('upload', $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d)",
			doc_ins_param_cnt+1, doc_ins_param_cnt + 2, doc_ins_param_cnt + 3, doc_ins_param_cnt + 4, doc_ins_param_cnt + 5,
			doc_ins_param_cnt + 6, doc_ins_param_cnt + 7, doc_ins_param_cnt + 8, doc_ins_param_cnt + 9, doc_ins_param_cnt + 10,
			doc_ins_param_cnt + 11, doc_ins_param_cnt + 12, doc_ins_param_cnt + 13, doc_ins_param_cnt + 14,
			doc_ins_param_cnt + 15, doc_ins_param_cnt + 16, doc_ins_param_cnt + 17, doc_ins_param_cnt + 18, doc_ins_param_cnt + 19,
		)
		doc_ins_param_cnt+= 19
		doc_ins_params = append(doc_ins_params, doc.Document.Company_id)
		doc_ins_params = append(doc_ins_params, doc.Document.User_id)
		doc_ins_params = append(doc_ins_params, doc.Document.Issue_date)
		doc_ins_params = append(doc_ins_params, doc.Document.End_date)
		doc_ins_params = append(doc_ins_params, doc.Document.Post)
		doc_ins_params = append(doc_ins_params, doc.Document.Work_place)
		doc_ins_params = append(doc_ins_params, doc.Document.Organization)
		doc_ins_params = append(doc_ins_params, doc.Document.Study_type)
		doc_ins_params = append(doc_ins_params, doc.Document.Series)
		doc_ins_params = append(doc_ins_params, doc.Document.Number)
		doc_ins_params = append(doc_ins_params, doc.Document.Study_prog_name)
		doc_ins_params = append(doc_ins_params, doc.Document.Profession)
		doc_ins_params = append(doc_ins_params, doc.Document.Reg_number)
		doc_ins_params = append(doc_ins_params, doc.Document.Study_period)
		doc_ins_params = append(doc_ins_params, doc.Document.Name_first)
		doc_ins_params = append(doc_ins_params, doc.Document.Name_second)
		doc_ins_params = append(doc_ins_params, doc.Document.Name_middle)
		doc_ins_params = append(doc_ins_params, doc.Document.Qualification_name)
		doc_ins_params = append(doc_ins_params, doc.Document.Snils)
		doc_cnt_ins++
		
		if doc_cnt_ins%DOC_CNT_INSERT == 0 {
			if !uploadDocumentExecQuery(conn, log, "study_documents", query_header, doc_ins_q, doc_ins_params, userID, userDescr, operationID) {
				return
			}

			doc_cnt_ins = 0
			doc_ins_param_cnt = 0
			doc_ins_params = make([]interface{}, 0)
			doc_ins_q = ""			
		}
		
		doc_cnt++
	}
	
	if doc_ins_q != "" {
		if !uploadDocumentExecQuery(conn, log, "study_documents", query_header, doc_ins_q, doc_ins_params, userID, userDescr, operationID) {
			return
		}
	}
	
	uploadDocumentEnd(conn, log, "StudyDocument", doc_cnt, err_str, error_excel_f, userID, operationID)
}

//companyID - Компания, или всегда одна, или из файла
func extractStudyDocuments(conn *pgx.Conn, txtFile *os.File, colMap columnMap, maxCount int, parse bool) <-chan *excelDocumentRecord {
	doc := make(chan *excelDocumentRecord)

	go func() {	
		scanner := bufio.NewScanner(txtFile)
		//study_document_type_cache := make(map[string]int)
		ind:= 0;
		for scanner.Scan() {
			arr := strings.Split(scanner.Text(), EXCEL_FIELD_DELIM)
			excel_doc := &excelDocumentRecord{}				
			if ind > 0 {
				if !parse {
					//do not parse, preview only
					excel_doc.Preview = parsePreview(arr, colMap)
				}else{
				
					excel_doc.Document = &studyDocument{}
					excel_doc.Error = setDocument(reflect.ValueOf(&excel_doc.Document), colMap, arr)
					excel_doc.Values = make([]string, len(arr))
					for i, arr_v := range arr {					
						excel_doc.Values[i] = parseExcelStringVal(arr_v)
					}
				}
			}else {
				//header
				excel_doc.IsHeader = true
				excel_doc.Values = make([]string, len(arr))
				for i, arr_v := range arr {					
					excel_doc.Values[i] = parseExcelStringVal(arr_v)
				}
			}
			
			doc <- excel_doc
			
			ind++
			if !parse && ind == maxCount {
				break
			}
		}
		close(doc)
	}()
	return doc
}

//
func uploadStudyDocumentRegisters(dStore *pgds.PgProvider, log logger.Logger, file multipart.File, colMap columnMap, userID int64, userDescr, operationID string, companyID int64) {
	defer file.Close()
	//db connect
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := dStore.GetPrimary() 
	if err_с != nil {
		log.Errorf("uploadStudyDocumentRegisters: %v", err_с)
		return
	}
	defer dStore.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	//convert file
	txt_file, err := convertExcelFile(file)	
	if err != nil {
		endUserOperationWithError(log, conn, userID, operationID, err)
		return
	}
	defer txt_file.Close()
	txt_file_nm := txt_file.Name()
	defer os.Remove(txt_file_nm)
	
	if _, err := conn.Exec(context.Background(), `BEGIN`); err != nil {
		endUserOperationWithError(log, conn, userID, operationID, err)
	}
	query_header := `INSERT INTO study_document_registers
		(issue_date, name, company_id, create_type)
		VALUES `
	
	doc_cnt := 0
	doc_cnt_ins := 0
	doc_ins_params := make([]interface{},0)
	doc_ins_param_cnt := 0
	doc_ins_q := ""
	
	var err_str string
	var header []string
	var error_excel_f *excelize.File
	var error_excel_row int
	var error_excel_sheet_name string
	
	for doc := range extractStudyDocumentRegisters(conn, txt_file, colMap, 0, true) {        	
		if doc.Error != nil {
			if err_str != "" {
				err_str += " "
			}
			err_str += doc.Error.Error()
			if error_excel_f == nil {
				error_excel_f = excelize.NewFile()
				//header
				error_excel_row = 1
				error_excel_sheet_name = "Sheet1"				
				for i, col_v := range header {					
					cell := getExcelCellRowForIndex(i)
					error_excel_f.SetCellValue(error_excel_sheet_name, cell+ fmt.Sprintf("%d", error_excel_row), col_v)
				}
				error_excel_row++
			}
			for i, col_v := range doc.Values {
				cell := getExcelCellRowForIndex(i)
				error_excel_f.SetCellValue(error_excel_sheet_name, cell+ fmt.Sprintf("%d", error_excel_row), col_v)
			}
			error_excel_row++
			continue
			
		}else if doc.IsHeader {
			//header for error file
			header = make([]string, len(doc.Values))
			copy(header, doc.Values)
			continue
		}
		
		if companyID == 0 {
			//не используется такое!!!
			company_id := getCompanyID(doc.Document.Company_search, doc_cnt, log, conn, userID, operationID)
			if company_id == 0 {
				return
			}
			doc.Document.Company_id.SetValue(company_id)
		}else{
			doc.Document.Company_id.SetValue(companyID)
		}
		
		//insert/update doc
		if doc_ins_q != "" {
			doc_ins_q+= ", "
		}
		doc_ins_q+= fmt.Sprintf("($%d, $%d, $%d, 'upload')", doc_ins_param_cnt+1, doc_ins_param_cnt+2, doc_ins_param_cnt+3)
		doc_ins_param_cnt+= 3
		doc_ins_params = append(doc_ins_params, doc.Document.Issue_date)
		doc_cnt_ins++
		doc_ins_params = append(doc_ins_params, doc.Document.Name)
		doc_cnt_ins++
		doc_ins_params = append(doc_ins_params, doc.Document.Company_id.GetValue())
		doc_cnt_ins++
		
		if doc_cnt_ins%DOC_CNT_INSERT == 0 {
			if !uploadDocumentExecQuery(conn, log, "study_document_registers", query_header, doc_ins_q, doc_ins_params, userID, userDescr, operationID) {
				return
			}

			doc_cnt_ins = 0
			doc_ins_param_cnt = 0
			doc_ins_params = make([]interface{}, 0)
			doc_ins_q = ""
			
		}
		doc_cnt++
	}
	
	if doc_ins_q != "" {
		if !uploadDocumentExecQuery(conn, log, "study_document_registers", query_header, doc_ins_q, doc_ins_params, userID, userDescr, operationID) {
			return
		}
	}
	
	uploadDocumentEnd(conn, log, "StudyDocumentRegister", doc_cnt, err_str, error_excel_f, userID, operationID)
}

func uploadDocumentExecQuery(conn *pgx.Conn, log logger.Logger, objectType, queryHeader, docQuery string, queryParams []interface{}, userID int64, userDescr, operationID string) bool {
fmt.Println("Executing ", queryHeader + docQuery, "params=", queryParams)
	rows, err := conn.Query(context.Background(), queryHeader + docQuery + fmt.Sprintf(" RETURNING id, coalesce(%s_ref(%s)->>'descr','')", objectType, objectType), queryParams...)
	if err != nil {				
		if _, err_tr := conn.Exec(context.Background(), `ROLLBACK`); err_tr != nil {
			endUserOperationWithError(log, conn, userID, operationID, err_tr)
		}else{
			endUserOperationWithError(log, conn, userID, operationID, err)
		}
		return false
	}
	//go new ids
	mod_body := ""	
	for rows.Next() {
		var id int64
		var descr string
		if err := rows.Scan(&id, &descr); err != nil {		
			if _, err_tr := conn.Exec(context.Background(), `ROLLBACK`); err_tr != nil {
				endUserOperationWithError(log, conn, userID, operationID, err_tr)
			}else{
				endUserOperationWithError(log, conn, userID, operationID, err)
			}
			return false
		}
		if mod_body != "" {
			mod_body+= ", "
		}
		mod_body+= fmt.Sprintf(`('%s', '%s', %d, '%s', now(), 'insert')`, userDescr, objectType, id, descr)
	}
	if err := rows.Err(); err != nil {
		if _, err_tr := conn.Exec(context.Background(), `ROLLBACK`); err_tr != nil {
			endUserOperationWithError(log, conn, userID, operationID, err_tr)
		}else{
			endUserOperationWithError(log, conn, userID, operationID, err)
		}
		return false
	}
fmt.Println("Executing mod ", MOD_HEAD_Q + mod_body)	
	if _, err := conn.Exec(context.Background(), MOD_HEAD_Q + mod_body); err != nil {
		if _, err_tr := conn.Exec(context.Background(), `ROLLBACK`); err_tr != nil {
			endUserOperationWithError(log, conn, userID, operationID, err_tr)
		}else{
			endUserOperationWithError(log, conn, userID, operationID, err)
		}
		return false
	}
	
	return true				
}

func uploadDocumentEnd(conn *pgx.Conn, log logger.Logger, docType string, docCnt int, errTxt string, errorExcel *excelize.File, userID int64, operationID string) {
	if _, err := conn.Exec(context.Background(), `COMMIT`); err != nil {
		endUserOperationWithError(log, conn, userID, operationID, err)
		return
	}
	comment_text := fmt.Sprintf("Загружено документов: %d", docCnt)
	if errorExcel != nil {
		var b bytes.Buffer
		if _, err := errorExcel.WriteTo(bufio.NewWriter(&b)); err != nil {
			endUserOperationWithError(log, conn, userID, operationID, err)
			return
		}	
		//end operation
		if _, err := conn.Exec(context.Background(), 
			`UPDATE user_operations
			SET
				status = 'end',
				comment_text = $1,
				error_text = $2,
				date_time_end = now(),
				file_content = $3
			WHERE user_id = $4 AND operation_id = $5`,
			comment_text,
			errTxt,
			b.Bytes(),
			userID,
			operationID,				
		); err != nil {
			endUserOperationWithError(log, conn, userID, operationID, err)
		}		
		
	}else{	
		if _, err := conn.Exec(context.Background(), 
			`UPDATE user_operations
			SET
				status = 'end',
				date_time_end = now(),
				comment_text = $1
			WHERE user_id = $2 AND operation_id = $3`,
			comment_text,
			userID,
			operationID,
		); err != nil {
			endUserOperationWithError(log, conn, userID, operationID, err)
		}
	}	
	//one event
	conn.Exec(context.Background(), fmt.Sprintf(`SELECT pg_notify('%s.insert', json_build_object('params', json_build_object('id',0))::text)`, docType))
}

func isNotDigit(s string) bool {
	is_not_digit := func(c rune) bool { return c < '0' || c > '9' }
	return strings.IndexFunc(s, is_not_digit) == -1
}

func extractStudyDocumentRegisters(conn *pgx.Conn, txtFile *os.File, colMap columnMap, maxCount int, parse bool) <-chan *excelDocumentRegisterRecord {
	doc := make(chan *excelDocumentRegisterRecord)

	go func() {	
		scanner := bufio.NewScanner(txtFile)
		ind:= 0;
		for scanner.Scan() {
			arr := strings.Split(scanner.Text(), EXCEL_FIELD_DELIM)
			excel_doc := &excelDocumentRegisterRecord{}		
			if ind > 0 {
				if !parse {
					//do not parse, preview only
					excel_doc.Preview = parsePreview(arr, colMap)
				}else{
				
					excel_doc.Document = &studyDocumentRegister{}
					excel_doc.Error = setDocument(reflect.ValueOf(&excel_doc.Document), colMap, arr)
					excel_doc.Values = make([]string, len(arr))
					for i, arr_v := range arr {					
						excel_doc.Values[i] = parseExcelStringVal(arr_v)
					}
				}
			}else {
				//header
				excel_doc.IsHeader = true
				excel_doc.Values = make([]string, len(arr))
				for i, arr_v := range arr {					
					excel_doc.Values[i] = parseExcelStringVal(arr_v)
				}
			}
			
			doc <- excel_doc
			
			ind++
			if !parse && ind == maxCount {
				break
			}
		}
		close(doc)
	}()
	return doc
}

//*********
func parsePreview(arr []string, colMap columnMap) map[string]string{
	//если файтических колонок меньше, чем в структуре (какие-то отсутствуют)
	col_map_len := len(colMap)
	col_cnt := 0
	if len(arr) > col_map_len {
		col_cnt = len(arr)
	}else{
		col_cnt = col_map_len
	}
	preview := make(map[string]string, col_cnt)
	for i, arr_v := range arr {
		dt := ""
		descr := ""
		for _, col := range colMap {
			if col.Ind == i {
				dt = col.DataType
				descr = col.Descr
				break
			}
		}
		if dt == "DateTimeTZ" || dt == "DateTime" || dt == "Date" {
			col_v, err := parseExcelDateVal(arr_v, descr)
			if err == nil {
				preview[fmt.Sprintf("f%d", i)] = col_v.Format("02/01/2006")
			}else{
				preview[fmt.Sprintf("f%d", i)] = parseExcelStringVal(arr_v)
			}
		}else{
			preview[fmt.Sprintf("f%d", i)] = parseExcelStringVal(arr_v)
		}
	}
	if len(arr) < col_cnt {
		//add missing columns
		for i := len(arr); i < col_cnt; i++ {
			preview[fmt.Sprintf("f%d", i)] = ""
		}
		
	}
	return preview
}

func setDocument(pDocument reflect.Value, colMap columnMap, arr []string) error {
	s := reflect.Indirect(pDocument.Elem())
	for _, col := range colMap {
		if col.Ind < len(arr) && arr[col.Ind] != "" {
			f := s.FieldByName(col.Name)
			if !f.IsValid() {
				return errors.New(fmt.Sprintf("Field '%s' IsValid=false", col.Name))
			}
			if !f.CanSet() {
				return errors.New(fmt.Sprintf("Field '%s' CanSet=false", col.Name))
			}
		
			if col.DataType == "DateTimeTZ" {
				if f.Kind() != reflect.Struct {
					return errors.New(fmt.Sprintf("Field '%s' Kind() != Struct", col.Name))
				}
				col_v, err := parseExcelDateVal(arr[col.Ind], col.Descr)
				if err != nil {
					return err
				}
				v := fields.ValDateTimeTZ{}
				v.SetValue(col_v)
				f.Set(reflect.ValueOf(v))

			} else if col.DataType == "Date" {
				if f.Kind() != reflect.Struct {
					return errors.New(fmt.Sprintf("Field '%s' Kind() != Struct", col.Name))
				}
				col_v, err := parseExcelDateVal(arr[col.Ind], col.Descr)
				if err != nil {
					return err
				}
				v := fields.ValDate{}
				v.SetValue(col_v)
				f.Set(reflect.ValueOf(v))
			
			}else{
				//string
				col_v := parseExcelStringVal(arr[col.Ind])
				if f.Kind() == reflect.String {
					f.SetString(col_v)
				}else{
					v := fields.ValText{}
					v.SetValue(col_v)
					f.Set(reflect.ValueOf(v))
				}
			}
						
		}else if col.Ind < len(arr) && arr[col.Ind] == "" && col.Required {
			//required column not set
			return errors.New(fmt.Sprintf("Колонка '%s' должна быть заполнена", col.Descr))
		}
	}
	return nil
}

func parseExcelStringVal(excelStr string) string{
	excelStr = strings.Trim(excelStr," ")
	excel_b := []byte(excelStr)
	if len(excel_b)>0 {
		return fields.ExtRemoveQuotes(excel_b)
	}
	return ""
}

func parseExcelIntVal(excelStr, colDescr string) (int64, error) {
	col_v := parseExcelStringVal(excelStr)
	if col_v == "" {
		return 0, nil
	}
	return strconv.ParseInt(col_v, 10, 64)
}

//converts to template 2006-01-02
func fullYearDateTemplate(d, sep string) string {
	d_parts := strings.Split(d, sep)
	return "20" + d_parts[2] + "-" + d_parts[1] + "-" + d_parts[0]
}

func parseExcelDateVal(excelStr, colDescr string) (time.Time, error) {
	col_v := parseExcelStringVal(excelStr)
	isNotDigit := func(c rune) bool { return c < '0' || c > '9' }
	tmpl := ""
	if len(col_v) == 10 && strings.IndexFunc(col_v[0:4], isNotDigit) == -1 && col_v[4:5] == "/" && col_v[7:8] == "/" {
		tmpl = "2006/01/02"

	}else if len(col_v) == 10 && strings.IndexFunc(col_v[0:4], isNotDigit) == -1 && col_v[4:5] == "." && col_v[7:8] == "." {
		tmpl = "2006.01.02"
		
		
	}else if len(col_v) == 10 && strings.IndexFunc(col_v[0:2], isNotDigit) == -1 && col_v[2:3] == "/" && col_v[5:6] == "/" {
		tmpl = "02/01/2006"
	
	}else if len(col_v) == 8 && strings.IndexFunc(col_v[0:2], isNotDigit) == -1 && col_v[2:3] == "/" && col_v[5:6] == "/" {
		//02/01/22
		tmpl = fullYearDateTemplate(col_v, "/")

	}else if len(col_v) == 10 && strings.IndexFunc(col_v[0:2], isNotDigit) == -1 && col_v[2:3] == "." && col_v[5:6] == "." {
		tmpl = "02.01.2006"

	}else if len(col_v) == 8 && strings.IndexFunc(col_v[0:2], isNotDigit) == -1 && col_v[2:3] == "." && col_v[5:6] == "." {
		//02.01.06
		tmpl = fullYearDateTemplate(col_v, ".")
		
	}else if len(col_v) == 19 {
		tmpl = "02/01/2006 15:04:05"
		
	}else if len(col_v) == 16 {
		tmpl = "02/01/2006 15:04"
		
	}else if len(col_v) == 25 {
		tmpl = "2006-01-02 15:04:05-07:00"		
		
	}else{
		return time.Time{}, errors.New("Unknown date format: "+col_v)
	}
	if date_time, e := time.Parse(tmpl, col_v); e != nil {
		return time.Time{}, errors.New(fmt.Sprintf("Ошибка парсинга даты для колонки '%s': %v", colDescr, e))
	}else{
		return date_time, nil
	}
}

func getCompanyID(companySearchVal string, lineInd int, log logger.Logger, conn *pgx.Conn, userID int64, operationID string) int64 {
	//Company_search= inn/name
	if len(companySearchVal) == 0 {
		if _, err := conn.Exec(context.Background(), `ROLLBACK`); err != nil {
			endUserOperationWithError(log, conn, userID, operationID, err)
		}else{
			endUserOperationWithError(log, conn, userID, operationID, errors.New(fmt.Sprintf("Строка: %d, пустое значение для площадки", lineInd)))
		}
		return 0
	}
	
	company_search := "name"
	if len(companySearchVal) == 10 || len(companySearchVal) == 12 && !isNotDigit(companySearchVal) {
		company_search = "inn"
	}
	
	var company_id int64
	err := conn.QueryRow(context.Background(),
		fmt.Sprintf(`SELECT id FROM clients WHERE %s = $1`, company_search),
		companySearchVal).Scan(&company_id)
		
	if err != nil {
		if _, err_t := conn.Exec(context.Background(), `ROLLBACK`); err_t != nil {
			endUserOperationWithError(log, conn, userID, operationID, err_t)
			
		}else if err == pgx.ErrNoRows {
			endUserOperationWithError(log, conn, userID, operationID, errors.New(fmt.Sprintf("Строка: %d, площадка не определена по значению '%s'", lineInd, companySearchVal)))
			
		}else{
			endUserOperationWithError(log, conn, userID, operationID, err)
		}
		return 0
	}
	return company_id
}

func delExcelTemplate(xlsFileName string) error {
	xls_file_path := CACHE_PATH + xlsFileName
	if view.FileExists(xls_file_path) {
		if err := os.Remove(xls_file_path); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("delExcelTemplate(): %v",err))
		}
	}
	return nil	
}

func getExcelTemplate(app osbe.Applicationer, sock socket.ClientSocketer, resp *response.Response, xlsFileName string, constID string) error {
	xls_file_path := CACHE_PATH + xlsFileName
	if !view.FileExists(xls_file_path) {
		//db connect
		d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
		var conn_id pgds.ServerID
		var pool_conn *pgxpool.Conn
		pool_conn, conn_id, err_с := d_store.GetSecondary("")
		if err_с != nil {
			return err_с
			//notify
		}
		defer d_store.Release(pool_conn, conn_id)
		conn := pool_conn.Conn()

		var fields []models.ExcelUploadFieldDescr
		if err := conn.QueryRow(context.Background(),
			fmt.Sprintf(`SELECT jsonb_agg(q.o)
			FROM (
				SELECT
					jsonb_build_object(
						'name', d.r->>'name',
						'descr', d.r->>'descr',
						'dataType', d.r->>'dataType',
						'maxLength', text_to_int_safe_cast(d.r->>'maxLength'),
						'required', text_to_bool_safe_cast(d.r->>'required'),
						'ind', (ROW_NUMBER() OVER())::int - 1
					) AS o
				FROM (	
					SELECT json_array_elements(%s_val()->'rows') AS r
				) AS d				
			) AS q`, constID),
			).Scan(&fields); err != nil {
		
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("getExcelTemplate conn.QueryRow(): %v",err))
		}
		excel_f := excelize.NewFile()
		sheet_name := "Sheet1"
		for i, f := range fields {
			descr := f.Descr
			if f.Required {
				descr = "*"+descr
			}
			cell := getExcelCellRowForIndex(i)
			if cell == "" {
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "getExcelTemplate too many columns")
			}
			excel_f.SetCellValue(sheet_name, cell+"1", descr)
			//excel_f.SetColWidth(sheet_name, cell+"1", cell+"1", W)
		}
		
		if err := excel_f.SaveAs(xls_file_path); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("getExcelTemplate SaveAs: %v", err))
		}
	}

	//download
	xls_f, err := os.Open(xls_file_path)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("getExcelTemplate os.Open: %v", err))
	}
	defer xls_f.Close()
	
	if err := httpSrv.DownloadFile(resp, sock, xls_f, xlsFileName, "", ""); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("getExcelTemplate DownloadFile(): %v", err))
	}
	return nil
}

func getAnalyzeCount(app osbe.Applicationer, sock socket.ClientSocketer, resp *response.Response, constID string) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetSecondary("")
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	sess := sock.GetSession()	
	user_id := sess.GetInt("USER_ID")
		
	analyze_s := struct {
		Analyze_count int `json:"analyze_count"`
	}{}	
	
	if err := conn.QueryRow(context.Background(),
		fmt.Sprintf(`SELECT
			coalesce(
				(SELECT analyze_count FROM study_document_upload_user_orders WHERE user_id = $1),
				text_to_int_safe_cast(%s_val()->>'analyze_count')
		)`, constID),
		user_id,	
	).Scan(&analyze_s.Analyze_count); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("getAnalyzeCount conn.QueryRow(): %v",err))
	}
	
	m := &model.Model{ID: model.ModelID("AnalyzeCount_Model"), Rows: make([]model.ModelRow, 1)}
	m.Rows[0] = &analyze_s
	resp.AddModel(m)

	return nil
}

func getExcelCellRowForIndex(ind int) string {
	letters := []string{"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
	cell := ""
	fl := ind/26
	if fl > 26 {
		return ""
	}
	if fl > 0 {
		cell = letters[fl-1] + letters[ind%26]				
	}else{
		cell = letters[ind]
	}
	return cell
}

func getExcelError(app osbe.Applicationer, sock socket.ClientSocketer, resp *response.Response, xlsFileName string, operaionID string, userID int64) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetSecondary("")
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	var file_content []byte
	if err := conn.QueryRow(context.Background(),
		`SELECT
			file_content
		FROM user_operations
		WHERE user_id = $1 AND operation_id = $2`,
		userID, operaionID,
		).Scan(&file_content); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("getExcelTemplate conn.QueryRow(): %v",err))
	}

	sock_http, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "getExcelTemplate sock must be *httpSrv.HTTPSocket")
	}
	httpSrv.ServeContent(sock_http, &file_content, xlsFileName, httpSrv.MIME_TYPE_xls, time.Now(), httpSrv.CONTENT_DISPOSITION_ATTACHMENT)
	resp = nil
	
	return nil
}

func checkUserCompany(companyID, userID int64, roleID string, conn *pgx.Conn) error {
	if roleID != "admin" {
		//Нужны проверки
		allowed:= false;
		if err := conn.QueryRow(context.Background(), 
			fmt.Sprintf(`WITH user_client AS (SELECT users.company_id AS id FROM users WHERE users.id = %d)		
				SELECT
					coalesce(
						(SELECT user_client.id = %d FROM user_client)
						OR
						%d IN (SELECT clients.id FROM clients WHERE parent_id = (SELECT user_client.id FROM user_client) ),
					FALSE)`, userID, companyID, companyID)).Scan(&allowed); err != nil {
		
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentRegister_Controller_upload_excel user client check: %v",err))
		}
		if !allowed {
			return osbe.NewPublicMethodError(ER_NOT_ALLOWED_CODE, ER_NOT_ALLOWED_DESCR)
		}
	}
	return nil
}
