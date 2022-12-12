package controllers

/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

import (
	"reflect"	
	"encoding/json"
	"context"
	"fmt"
	"os"
	"time"
		
	"dpassport/models"
	
	"ds/pgds"
	
	"osbe"
	"osbe/fields"	
	"osbe/srv"
	"osbe/srv/httpSrv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	
	"github.com/jackc/pgx/v4/pgxpool"
	"github.com/jackc/pgx/v4"
)

const STUDY_DOCUMENT_TEMPLATE = "Шаблон сертификатов.xlsx"


//Controller
type StudyDocument_Controller struct {
	osbe.Base_Controller
}

func NewController_StudyDocument() *StudyDocument_Controller{
	c := &StudyDocument_Controller{osbe.Base_Controller{ID: "StudyDocument", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.StudyDocument_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &StudyDocument_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument{})),
			EventList: osbe.PublicMethodEventList{"StudyDocument.insert"},
		},
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &StudyDocument_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"StudyDocument.delete"},
		},
	}
	
	//************************** method update *************************************
	c.PublicMethods["update"] = &StudyDocument_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_old_keys{})),
			EventList: osbe.PublicMethodEventList{"StudyDocument.update"},
		},
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &StudyDocument_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &StudyDocument_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}

	//************************** method get_with_pict_list *************************************
	c.PublicMethods["get_with_pict_list"] = &StudyDocument_Controller_get_with_pict_list{
		osbe.Base_PublicMethod{
			ID: "get_with_pict_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
	//************************** method complete *************************************
	c.PublicMethods["complete"] = &StudyDocument_Controller_complete{
		osbe.Base_PublicMethod{
			ID: "complete",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_complete{})),
		},
	}
			
	//************************** method get_preview *************************************
	c.PublicMethods["get_preview"] = &StudyDocument_Controller_get_preview{
		osbe.Base_PublicMethod{
			ID: "get_preview",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_get_preview{})),
		},
	}
	
	//************************** method analyze_excel *************************************
	c.PublicMethods["analyze_excel"] = &StudyDocument_Controller_analyze_excel{
		osbe.Base_PublicMethod{
			ID: "analyze_excel",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_analyze_excel{})),
		},
	}

	//************************** method upload_excel *************************************
	c.PublicMethods["upload_excel"] = &StudyDocument_Controller_upload_excel{
		osbe.Base_PublicMethod{
			ID: "upload_excel",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_upload_excel{})),
		},
	}

	//************************** method get_analyze_count *************************************
	c.PublicMethods["get_analyze_count"] = &StudyDocument_Controller_get_analyze_count{
		osbe.Base_PublicMethod{
			ID: "get_analyze_count",
		},
	}
	
	//************************** method save_field_order *************************************
	c.PublicMethods["save_field_order"] = &StudyDocument_Controller_save_field_order{
		osbe.Base_PublicMethod{
			ID: "save_field_order",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_save_field_order{})),
		},
	}
	
	//************************** method get_excel_template *************************************
	c.PublicMethods["get_excel_template"] = &StudyDocument_Controller_get_excel_template{
		osbe.Base_PublicMethod{
			ID: "get_excel_template",
		},
	}
	
	//************************** method get_excel_error *************************************
	c.PublicMethods["get_excel_error"] = &StudyDocument_Controller_get_excel_error{
		osbe.Base_PublicMethod{
			ID: "get_excel_error",
		},
	}

	//************************** method change_fields *************************************
	c.PublicMethods["change_fields"] = &StudyDocument_Controller_change_fields{
		osbe.Base_PublicMethod{
			ID: "change_fields",
		},
	}

	//************************** method batch_update *************************************
	c.PublicMethods["batch_update"] = &StudyDocument_Controller_batch_update{
		osbe.Base_PublicMethod{
			ID: "batch_update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_batch_update{})),
			EventList: osbe.PublicMethodEventList{"StudyDocument.update"},
		},
	}

	//************************** method batch_delete *************************************
	c.PublicMethods["batch_delete"] = &StudyDocument_Controller_batch_delete{
		osbe.Base_PublicMethod{
			ID: "batch_delete",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_batch_delete{})),
			EventList: osbe.PublicMethodEventList{"StudyDocument.delete"},
		},
	}

	//************************** method get_list_for_person *************************************
	/*c.PublicMethods["get_list_for_person"] = &StudyDocument_Controller_get_list_for_person{
		osbe.Base_PublicMethod{
			ID: "get_list_for_person",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocument_get_list_for_person{})),
		},
	}*/
	
	return c
}

type StudyDocument_Controller_keys_argv struct {
	Argv models.StudyDocument_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type StudyDocument_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_insert) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}
func (pm *StudyDocument_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocument"], &models.StudyDocument_keys{}, sock.GetPresetFilter("StudyDocument"))	
}

//************************* DELETE **********************************************
type StudyDocument_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocument"], sock.GetPresetFilter("StudyDocument"))	
}

//************************* GET OBJECT **********************************************
type StudyDocument_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentDialog"], &models.StudyDocumentDialog{}, sock.GetPresetFilter("StudyDocumentDialog"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type StudyDocument_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentList"], &models.StudyDocumentList{}, sock.GetPresetFilter("StudyDocumentList"))	
}

//************************* UPDATE **********************************************
//Public method: update
type StudyDocument_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_old_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	sess := sock.GetSession()
	role_id := sess.GetString(osbe.SESS_ROLE)
	if role_id != "admin" {
		args := rfltArgs.Interface().(*models.StudyDocument_old_keys)
		var conn *pgx.Conn
		company_id := sess.GetString(SESS_VAR_COMPANY_ID)
		
		//check user_id		
		if args.User_id.GetIsSet() {
			//db connect
			d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
			pool_conn, conn_id, err_с := d_store.GetSecondary("")
			if err_с != nil {
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_update Request.GetPrimary(): %v",err_с))
			}
			defer d_store.Release(pool_conn, conn_id)
			conn = pool_conn.Conn()
			
			user_company := false
			if err := conn.QueryRow(context.Background(),
				fmt.Sprintf(`SELECT
					(u.company_id = %d)
					OR
					u.company_id IN (SELECT t.id FROM clients AS t WHERE t.parent_id = %d)
				FROM users AS u
				WHERE u.id = %d`, company_id, company_id, args.User_id)).Scan(&user_company); err != nil {
			
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_update SELECT company: %v",err))
			}
		}
		//check company		
	}
	return UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocument"], sock.GetPresetFilter("StudyDocument"))	
}
//************************** COMPLETE ********************************************************
//Public method: complete
type StudyDocument_Controller_complete struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_complete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_complete_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_complete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.CompleteOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentList"], &models.StudyDocumentList{}, sock.GetPresetFilter("StudyDocumentList"))	
}

//
//************************* get_preview **********************************************
//Public method: get_preview
type StudyDocument_Controller_get_preview struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_get_preview) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_get_preview_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

func (pm *StudyDocument_Controller_get_preview) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return nil
}

//
//************************* get_analyze_count **********************************************
//Public method: get_analyze_count
type StudyDocument_Controller_get_analyze_count struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_get_analyze_count) Unmarshal(payload []byte) (reflect.Value, error) {
	return reflect.Value(reflect.ValueOf(nil)), nil
}

func (pm *StudyDocument_Controller_get_analyze_count) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return getAnalyzeCount(app, sock, resp, "const_study_document_fields")
}

//************************* upload_excel **********************************************
//Public method: upload_excel
type StudyDocument_Controller_upload_excel struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_upload_excel) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_upload_excel_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_upload_excel) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	http_sock, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "StudyDocument_Controller_upload_excel: not HTTPSocket type")
	}	

	//arguments
	args := rfltArgs.Interface().(*models.StudyDocument_upload_excel)

	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_upload_excel Request.GetPrimary(): %v",err_с))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	//*****************
	t := time.Now()
	t = t.Add(time.Millisecond)	
	user_oper := struct{
		Operation_id string `json:"operation_id"`
	}{Operation_id: GetMd5(t.Format("20060102150405.000"))}	
	
	sess := sock.GetSession()
	user_id := sess.GetInt(SESS_VAR_ID)
	 
	//Либо у пользователя эта компания, либо это компания является компанией которая выбрана у пользователя
	company_id := args.Company_id.GetValue()
	if err := checkUserCompany(company_id, user_id, sess.GetString(osbe.SESS_ROLE), conn); err != nil {
		return err
	}
	//uploaded file
	file, _, err := http_sock.Request.FormFile("content_data[]")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_upload_excel Request.FormFile(): %v",err))
	}
	//**************
	
	//update user params
	field_map := make(columnMap, len(args.Field_order))//indexed list	
	user_fields := make([]models.ExcelUploadFieldDescr, len(args.Field_order)) //for db
	i := 0
	for _, f := range args.Field_order {
		field_map[f.Name] = f
		//add all params from const
		user_fields[i] = f
		i++
	}
	/*
	УБРАНО!!!
	if _, err := conn.Exec(context.Background(), 
		`INSERT INTO study_document_upload_user_orders (user_id, fields, analyze_count)
		VALUES ($1, $2, $3)
		ON CONFLICT (user_id) DO UPDATE
		SET
			fields = $2,
			analyze_count = $3`,
		user_id,
		user_fields,
		args.Analyze_count.GetValue(),
	); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_upload_excel study_document_upload_user_orders conn.Exec(): %v",err))
	}	
	*/
	
	if _, err := conn.Exec(context.Background(), 
		`INSERT INTO user_operations (user_id, operation_id, operation, status) VALUES ($1, $2, 'excel_upload', 'start')`,
		user_id,
		user_oper.Operation_id,
	); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_upload_excel user_operations conn.Exec(): %v",err))
	}	

	//async upload
	go uploadStudyDocuments(d_store, app.GetLogger(), app.GetBaseDir(), file, field_map, user_id, sess.GetString(SESS_VAR_DESCR), sess.GetString(osbe.SESS_ROLE),
		user_oper.Operation_id, company_id)

	resp.AddModelFromStruct(model.ModelID("UserOperation_Model"), &user_oper)
	
	return nil
}

//************************* analyze_excel **********************************************
//Public method: analyze_excel
type StudyDocument_Controller_analyze_excel struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_analyze_excel) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_analyze_excel_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_analyze_excel) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	http_sock, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "StudyDocument_Controller_analyze_excel: not HTTPSocket type")
	}	

	//uploaded file
	file, _, err := http_sock.Request.FormFile("content_data[]")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_analyze_excel Request.FormFile(): %v",err))
	}
	defer file.Close()
	//**************
	
	//convert file
	txt_file, err := convertExcelFile(app.GetBaseDir(), file)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_analyze_excel convertExcelFile(): %v",err))
	}
	defer txt_file.Close()
	txt_file_nm := txt_file.Name()
	defer os.Remove(txt_file_nm)
	//**************
	
	//arguments
	args := rfltArgs.Interface().(*models.StudyDocument_analyze_excel)
	
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
	//*********************
	
	//read && analyze	
	var fields []models.ExcelUploadFieldDescr
	//user or default value
	if err := conn.QueryRow(context.Background(),
		`SELECT
			coalesce(
				(SELECT fields FROM study_document_upload_user_orders WHERE user_id = $1),
				(SELECT jsonb_agg(q.o)
				FROM (
					SELECT
						jsonb_build_object(
							'name', d.r->>'name',
							'descr', d.r->>'descr',
							'dataType', d.r->>'dataType',
							'maxLength', text_to_int_safe_cast(d.r->>'maxLength'),
							'ind', (ROW_NUMBER() OVER())::int - 1
						) AS o
					FROM (	
						SELECT json_array_elements(const_study_document_fields_val()->'rows') AS r
					) AS d				
				) AS q				
				)
			)`,
			sock.GetSession().GetInt(SESS_VAR_ID),
		).Scan(&fields); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_analyze_excel conn.QueryRow(): %v",err))
	}
	field_map := make(columnMap, len(fields))//indexed list	
	for _, f := range fields {
		field_map[f.Name] = f
	}
	h_model := &model.Model{ID: model.ModelID("FileHeader_Model")}
	doc_model := &model.Model{ID: model.ModelID("FileContent_Model"), Rows: make([]model.ModelRow, 0)}
	for doc := range extractStudyDocuments(conn, txt_file, field_map, int(args.Analyze_count.GetValue()), false) {        	
		if doc.Error != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_analyze_excel extractStudyDocuments(): %v",doc.Error))
			break
		}
		if h_model.Rows == nil {
			//initialize
			col_cnt := 0
			if len(fields) > len(doc.Preview) {
				col_cnt = len(fields)
			}else{
				col_cnt = len(doc.Preview)
			}
			h_model.Rows = make([]model.ModelRow, col_cnt)//actual column count
			for ind := 0; ind < col_cnt; ind++ {
				field := models.ExcelUploadFieldDescr{Ind: ind}
				for _, f := range fields {
					if ind == f.Ind {
						field.Name = f.Name
						field.Descr = f.Descr
						field.DataType = f.DataType
						field.MaxLength = f.MaxLength
						break
					}
				}
				h_model.Rows[ind] = &field
			}
		}
		doc_model.Rows = append(doc_model.Rows, &doc.Preview)
	}
	resp.AddModel(doc_model)
	resp.AddModel(h_model)
	
	return nil
}


//************************* save_field_order **********************************************
//Public method: save_field_order
type StudyDocument_Controller_save_field_order struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_save_field_order) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_save_field_order_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_save_field_order) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_save_field_order Request.GetPrimary(): %v",err_с))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	args := rfltArgs.Interface().(*models.StudyDocument_save_field_order)
	
	sess := sock.GetSession()
	user_id := sess.GetInt(SESS_VAR_ID)
	
	user_fields := make([]models.ExcelUploadFieldDescr, len(args.Field_order)) //for db
	i := 0
	for _, f := range args.Field_order {
		//add all params from const
		user_fields[i] = f
		i++
	}
	if _, err := conn.Exec(context.Background(), 
		`INSERT INTO study_document_upload_user_orders (user_id, fields, analyze_count)
		VALUES ($1, $2, $3)
		ON CONFLICT (user_id) DO UPDATE
		SET
			fields = $2,
			analyze_count = $3`,
		user_id,
		user_fields,
		args.Analyze_count.GetValue(),
	); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_save_field_order study_document_upload_user_orders conn.Exec(): %v",err))
	}	
	
	return nil
}

//************************* GET WITH PICT LIST **********************************************
//Public method: get_with_pict_list
type StudyDocument_Controller_get_with_pict_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_get_with_pict_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_get_with_pict_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentWithPictList"], &models.StudyDocumentWithPictList{}, sock.GetPresetFilter("StudyDocumentWithPictList"))	
}

//************************* get_excel_template **********************************************
//Public method: get_excel_template
type StudyDocument_Controller_get_excel_template struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_get_excel_template) Unmarshal(payload []byte) (reflect.Value, error) {
	return reflect.ValueOf(nil), nil
}

//Method implemenation
func (pm *StudyDocument_Controller_get_excel_template) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return getExcelTemplate(app, sock, resp, STUDY_DOCUMENT_TEMPLATE, "const_study_document_fields")
}

//************************* get_excel_error **********************************************
//Public method: get_excel_error
type StudyDocument_Controller_get_excel_error struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_get_excel_error) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_get_excel_error_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil

}

//Method implemenation
func (pm *StudyDocument_Controller_get_excel_error) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.StudyDocument_get_excel_error)
	return getExcelError(app, sock, resp, "Ошибки.xlsx", args.Operation_id.GetValue(), sock.GetSession().GetInt(SESS_VAR_ID))
}

//************************* change_fields **********************************************
//From constant trigger!!!
//Public method: change_fields
type StudyDocument_Controller_change_fields struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_change_fields) Unmarshal(payload []byte) (reflect.Value, error) {
	return reflect.Value(reflect.ValueOf(nil)), nil

}

//Method implemenation
func (pm *StudyDocument_Controller_change_fields) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//delete template
	return delExcelTemplate(app.GetBaseDir(), STUDY_DOCUMENT_TEMPLATE)
}

//************************* batch_update **********************************************
//Public method: batch_update
type StudyDocument_Controller_batch_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_batch_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_batch_update_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_batch_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_update Request.GetPrimary(): %v",err_с))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	//*****************
	
	args := rfltArgs.Interface().(*models.StudyDocument_batch_update)
	
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_update BEGIN: %v",err))
	}
	
	pr_f := sock.GetPresetFilter("StudyDocument")
	m := app.GetMD().Models["StudyDocument"]
	
	mod_body := ""
	sess := sock.GetSession()
	user_descr := sess.GetString(SESS_VAR_DESCR)	
	user_role := sess.GetString(osbe.SESS_ROLE)
	user_company_id := sess.GetInt(SESS_VAR_COMPANY_ID)
	user_id := sess.GetInt(SESS_VAR_ID)
	object_t := "study_documents"
	query_t := `SELECT coalesce(study_documents_ref(t)->>'descr', '')
			FROM study_documents AS t
			WHERE t.id = %d`
		
	company_id := 0
	if sess.GetString(osbe.SESS_ROLE) != "admin" {		
		if err := conn.QueryRow(context.Background(), 
			fmt.Sprintf("SELECT company_id FROM users WHERE id = %d", sess.GetInt(SESS_VAR_ID))).Scan(&company_id); err != nil {
		
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_update FROM users: %v",err))	
		}
		query_t+= fmt.Sprintf(` AND (t.company_id = %d OR t.company_id IN (SELECT cl.id FROM clients AS cl WHERE cl.parent_id = %d))`, company_id, company_id)
	}
	
	checked_docs := make(map[int64]bool, 0)
	for _, ob := range args.Objects {
		//check protocol!
		if company_id > 0 && ob.Study_document_register_id.GetIsSet() {
			if _, ok := checked_docs[ob.Study_document_register_id.GetValue()]; !ok {
				checked_ok := false
				if err := conn.QueryRow(context.Background(),
					fmt.Sprintf(`SELECT
						(t.company_id = %d OR t.company_id IN (SELECT cl.id FROM clients AS cl WHERE cl.parent_id = %d)) AS fits
					FROM study_document_registers AS t
					WHERE t.id = %d`, company_id, company_id, ob.Study_document_register_id.GetValue())).Scan(&checked_ok); err != nil {
				
					conn.Exec(context.Background(), "ROLLBACK")	
					return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_update SELECT check company: %v",err))
				}
				if !checked_ok {
					conn.Exec(context.Background(), "ROLLBACK")	
					return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "StudyDocument_Controller_batch_update Чужой протокол")
				}
				checked_docs[ob.Study_document_register_id.GetValue()] = true
			}
		}
		descr := ""
		q := fmt.Sprintf(query_t, ob.Old_id.GetValue())		

		if err := conn.QueryRow(context.Background(), q).Scan(&descr); err != nil {		
			conn.Exec(context.Background(), "ROLLBACK")	
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_update SELECT: %v",err))
		}
		if mod_body != "" {
			mod_body+= ", "
		}
		mod_body+= fmt.Sprintf(`('%s', '%s', %d, '%s', now(), 'update')`, user_descr, object_t, ob.Old_id.GetValue(), descr)
	
		rflct := reflect.ValueOf(&ob).Elem()
		if err := osbe.UpdateOnArgsWithConn(conn, app, pm, resp, sock, rflct, m, pr_f); err != nil {
			conn.Exec(context.Background(), "ROLLBACK")
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_update Update(): %v",err))
		}
		
		if user_role == "client_admin1" || user_role == "client_admin2" {
			EmitEvent(conn, fmt.Sprintf("StudyDocument.update_comp_%d", user_company_id), ob.Old_id.GetValue())
		}
		if user_role == "client_admin2" {
			EmitEvent(conn, fmt.Sprintf("StudyDocument.update_usr_%d", user_id), ob.Old_id.GetValue())
		}		
		
	}
	if mod_body != "" {
		if _, err := conn.Exec(context.Background(), MOD_HEAD_Q + mod_body); err != nil {
			conn.Exec(context.Background(), `ROLLBACK`)			
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_update INSERT object_mod_log: %v",err))
		}
	}

	//+events

	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_update BEGIN: %v",err))
	}
	
	return nil
}

//************************* batch_delete **********************************************
//Public method: batch_delete
type StudyDocument_Controller_batch_delete struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_batch_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocument_batch_delete_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_batch_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_delete Request.GetPrimary(): %v",err_с))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	//*****************
	
	args := rfltArgs.Interface().(*models.StudyDocument_batch_delete)
	
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_delete BEGIN: %v",err))
	}
	
	pr_f := sock.GetPresetFilter("StudyDocument")
	m := app.GetMD().Models["StudyDocument"]
	
	mod_body := ""
	sess := sock.GetSession()
	user_descr := sess.GetString(SESS_VAR_DESCR)
	user_role := sess.GetString(osbe.SESS_ROLE)
	user_company_id := sess.GetInt(SESS_VAR_COMPANY_ID)
	user_id := sess.GetInt(SESS_VAR_ID)
	object_t := "study_documents"
	
	for _, ob := range args.Keys {
		descr := ""
		if err := conn.QueryRow(context.Background(),			
			`SELECT coalesce(study_documents_ref(t)->>'descr', '')
			FROM study_documents AS t
			WHERE t.id = $1`,
			ob.Id).Scan(&descr); err != nil {
		
			conn.Exec(context.Background(), "ROLLBACK")	
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_delete SELECT: %v, id=%d",err, ob.Id.GetValue()))
		}
		if mod_body != "" {
			mod_body+= ", "
		}
		mod_body+= fmt.Sprintf(`('%s', '%s', %d, '%s', now(), 'delete')`, user_descr, object_t, ob.Id.GetValue(), descr)
		
		rflct := reflect.ValueOf(&ob).Elem()
		if err := osbe.DeleteOnArgKeysWithConn(conn, app, pm, resp, sock, rflct, m, pr_f); err != nil {
			conn.Exec(context.Background(), "ROLLBACK")
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_delete Delete(): %v",err))
		}
		
		if user_role == "client_admin1" || user_role == "client_admin2" {
			EmitEvent(conn, fmt.Sprintf("StudyDocument.delete_comp_%d", user_company_id), ob.Id.GetValue())
		}
		if user_role == "client_admin2" {
			EmitEvent(conn, fmt.Sprintf("StudyDocument.delete_usr_%d", user_id), ob.Id.GetValue())
		}
	}
	if mod_body != "" {
		if _, err := conn.Exec(context.Background(), MOD_HEAD_Q + mod_body); err != nil {
			conn.Exec(context.Background(), `ROLLBACK`)			
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_delete INSERT object_mod_log: %v",err))
		}		
	}
	
	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocument_Controller_batch_delete BEGIN: %v",err))
	}
	
	return nil
}
/*
//************************* get_list_for_person **********************************************
//Public method: get_list_for_person
type StudyDocument_Controller_get_list_for_person struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocument_Controller_get_list_for_person) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Controller_get_list_for_person_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocument_Controller_get_list_for_person) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err := d_store.GetSecondary(GetModelLsnValue(modelStruct))
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	args := rfltArgs.Interface().(*models.Controller_get_list_for_person)
	f := sock.GetPresetFilter("StudyDocumentList")
	if args.Search.GetIsSet() {
		f = append(f,
			&sql.FilterCond{Expression: fmt.Sprintf("post ilike '%%'",
			org_id, org_id),
		})
		
	}
		
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentList"], &models.StudyDocumentList{}, f)	
}
*/
