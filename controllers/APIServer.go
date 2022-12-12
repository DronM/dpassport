package controllers

//API сервер для получения изменений в данных
//Период запуска регламентируется константой

import(
	"time"
	"context"
	"net/http"
	"bytes"
	"io/ioutil"
	"encoding/json"
	"sync"
	"fmt"
	"errors"
	"strings"
	"os"
	
	"golang.org/x/sync/errgroup"
	
	"osbe/logger"
	"ds/pgds"
	"osbe/fields"

	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"

)

const API_USER_DESCR = "API"

var quitAPIServer chan bool

type APIObjectType struct {
	Model_name string `json:"model_name"`
	Model_id int `json:"model_id"`
	UUID string `json:"uuid"`
}

type APIData struct {
	Update []APIObjectType `json:"update"`
	Delete []APIObjectType `json:"delete"`
}

type APIServer struct {
	DStore *pgds.PgProvider
	L logger.Logger
	BaseDir string
	Host string
	Token string
	CheckInterval int
	WorkerCount int
	mu sync.Mutex
	DoneObjects []string
}

//Вытягивание вложения
func (a *APIServer) getAttachment(uiid string) ([]byte, error) {	
	url := fmt.Sprintf(`%s.pdf?token=%s&method=show_attach&uuid=%s`, a.Host, a.Token, uiid)
	resp, err := http.Get(url)
	if err != nil {
		a.L.Errorf("getAttachment http.Get(): %v", err)
		return []byte{}, err
	}
	if resp.StatusCode != 200 {		
		return []byte{}, errors.New(fmt.Sprintf("getAttachment status: %d",  resp.StatusCode))
	}
	defer resp.Body.Close()
	return ioutil.ReadAll(resp.Body)
}

//********** USER ********************************
type APIUser struct {
	Model_id fields.ValInt `json:"model_id"`
	Name fields.ValText `json:"name"`
	Name_full fields.ValText `json:"name_full"`
	Post fields.ValText `json:"post"`
	Sex string `json:"sex"`
	Sex_e fields.ValText
	Birthdate string `json:"birthdate"`
	Birthdate_d fields.ValDate
	Snils fields.ValText `json:"snils"`
	Photo bool `json:"photo"`
	QRCode string `json:"qrcode"`
	Company_id fields.ValInt `json:"Company_id"`
	Client_id fields.ValInt `json:"client_id"`
	Photo_content fields.ValBytea
	UUID string `json:"uuid"`
}

func (a *APIServer) parse_User(body []byte, uuid string) {
	user := APIUser{UUID: uuid}
	if err := json.Unmarshal(body, &user); err != nil {
		a.L.Errorf("parse_User json.Unmarshal(): %v", err)
		return
	}
	
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := a.DStore.GetPrimary()
	if err_с != nil {
		a.L.Errorf("parse_User GetPrimary(): %v", err_с)
		return
	}
	defer a.DStore.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		a.L.Errorf("parse_User BEGIN conn.Exec(): %v", err)
		return
	}
	
	if err := a.commitUser(&user, conn, true); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		a.L.Errorf("parse_User: %v", err)
		return
	}
	
	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		a.L.Errorf("parse_User COMMIT conn.Exec(): %v", err)
		return
	}
	
	a.setObjectDone(uuid)
}
	
func (a *APIServer) commitUser(user *APIUser, conn *pgx.Conn, addAttachment bool) error {	
	user.Snils.SetValue(UnformatSnils(user.Snils.GetValue()))
	
	if strings.ToLower(user.Sex) == "male" {
		user.Sex_e.SetValue("male")
	}else if strings.ToLower(user.Sex) == "female" {
		user.Sex_e.SetValue("female")
	}else{
		user.Sex_e.IsNull = true
	}
	
	if user.Birthdate == "" {
		user.Birthdate_d.IsNull = true
	}else{
		if d, err := api_parse_date(user.Birthdate); err != nil {
			a.L.Errorf("commitUser api_parse_date(): %v", err)			
			user.Birthdate_d.IsNull = true
		}else{
			user.Birthdate_d.SetValue(d)
		}
	}	
	user.Photo_content.IsNull = true	
	if user.Photo && addAttachment {
		//get user attachment
		if photo, err := a.getAttachment(user.UUID); err != nil {
			a.L.Errorf("commitUser getAttachment(): %v", err)				
		}else{
			user.Photo_content.SetValue(photo)
		}
	}
	
	if addAttachment {
		if _, err := conn.Exec(context.Background(),
			`INSERT INTO users
			(id, name, name_full, post, sex, birthdate, snils, photo, person_url, role_id)
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, 'person')
			ON CONFLICT (id) DO UPDATE
			SET
				name = $2,
				name_full = $3,
				post = $4,
				sex = $5,
				birthdate = $6,
				snils = $7,
				photo = $8,
				person_url = $9
			RETURNING id`,
			user.Model_id, user.Name, user.Name_full, user.Post, user.Sex_e, user.Birthdate_d, user.Snils, user.Photo_content, user.QRCode,
			); err != nil {
			
			return errors.New(fmt.Sprintf("commitUser INSERT INTO users conn.Exec(): %v", err))
		}
	}else{
		//no url
		if _, err := conn.Exec(context.Background(),
			`INSERT INTO users
			(id, name, name_full, post, sex, birthdate, snils, photo, role_id)
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 'person')
			ON CONFLICT (id) DO UPDATE
			SET
				name = $2,
				name_full = $3,
				post = $4,
				sex = $5,
				birthdate = $6,
				snils = $7,
				photo = $8
			RETURNING id`,
			user.Model_id, user.Name, user.Name_full, user.Post, user.Sex_e, user.Birthdate_d, user.Snils, user.Photo_content,
			); err != nil {
			
			return errors.New(fmt.Sprintf("commitUser INSERT INTO users conn.Exec(): %v", err))
		}
	}	
	
	user_desc := ""
	if user.Name.GetValue() != "" {
		user_desc = user.Name.GetValue()
		
	}else if user.Name_full.GetValue() != "" {
		user_desc = user.Name_full.GetValue()
	}else if user.QRCode != "" {
		user_desc = user.QRCode
	}else{
		user_desc = "Без представления"
	}
	
	if _, err := conn.Exec(context.Background(),
		`INSERT INTO object_mod_log
		(user_descr, object_type, object_id, object_descr, date_time, action, details)
		VALUES ($1, 'users', $2, $3, now(), 'insert', null)`, 
		API_USER_DESCR, user.Model_id, user_desc,
		); err != nil {
				
		return errors.New(fmt.Sprintf("commitUser INSERT INTO object_mod_log: %v", err))
	}
	
	return nil
}

//********** PROTOCOL ********************************
type APIProtocol struct {
	Model_id fields.ValInt `json:"model_id"`
	Client_id fields.ValInt `json:"client_id"`
	Company_id fields.ValInt `json:"company_id"`
	Name fields.ValText `json:"name"`
	Issue_date string `json:"date_time"`
	Issue_date_d fields.ValDate
	UUID string `json:"uuid"`
}

func (a *APIServer) parse_StudyDocumentRegister(body []byte, uuid string) {
	doc := APIProtocol{UUID: uuid}
	if err := json.Unmarshal(body, &doc); err != nil {
		a.L.Errorf("parse_StudyDocumentRegister json.Unmarshal(): %v", err)
		return
	}
		
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := a.DStore.GetPrimary()
	if err_с != nil {
		a.L.Errorf("parse_StudyDocumentRegister GetPrimary(): %v", err_с)
		return
	}
	defer a.DStore.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		a.L.Errorf("parse_StudyDocumentRegister BEGIN conn.Exec(): %v", err)
		return
	}
	
	if err := a.commitStudyDocumentRegister(&doc, conn, true); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		a.L.Errorf("parse_StudyDocumentRegister: %v", err)
		return
	}

	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		a.L.Errorf("parse_StudyDocumentRegister COMMIT conn.Exec(): %v", err)
		return
	}
	
	a.setObjectDone(uuid)		
}

func (a *APIServer) commitStudyDocumentRegister(doc *APIProtocol, conn *pgx.Conn, addAttachment bool) error {	
	if doc.Issue_date == "" {
		doc.Issue_date_d.IsNull = true
	}else{		
		if d, err := api_parse_date(doc.Issue_date); err != nil {
			a.L.Errorf("commitStudyDocumentRegister api_parse_date(): %v", err)			
			doc.Issue_date_d.IsNull = true
		}else{
			doc.Issue_date_d.SetValue(d)
		}
	}	
	if _, err := conn.Exec(context.Background(),
		`INSERT INTO study_document_registers
		(id, company_id, name, issue_date, create_type)
		VALUES ($1, $2, $3, $4, 'api')
		ON CONFLICT (id) DO UPDATE
		SET
			company_id = $2,
			name = $3,
			issue_date = $4,
			create_type = 'api'
		RETURNING id`,
		doc.Model_id,
		doc.Company_id,
		doc.Name,
		doc.Issue_date_d,
		); err != nil {
		
		return errors.New(fmt.Sprintf("commitStudyDocumentRegister INSERT INTO clients: %v", err))
	}
	descr := ""
	if  doc.Name.GetValue() != "" {
		descr =  doc.Name.GetValue()
	}else{		
		descr = fmt.Sprintf("ID: %d", doc.Model_id)
	}
	
	if _, err := conn.Exec(context.Background(),
		`INSERT INTO object_mod_log
		(user_descr, object_type, object_id, object_descr, date_time, action, details)
		VALUES ($1, 'study_document_registers', $2, $3, now(), 'insert', null)`, 
		API_USER_DESCR, doc.Model_id, descr,
		); err != nil {
			
		a.L.Errorf("INSERT INTO object_mod_log: %v", err)	
	}
	
	if addAttachment {
		return a.addAttachmentToDB(conn, "study_document_registers", doc.Model_id.GetValue(), doc.UUID)
	}else{
		return nil
	}
}

//********** CERTIFICATE ********************************
type APICertificate struct {
	Model_id fields.ValInt `json:"model_id"`
	Client_id fields.ValInt `json:"client_id"`
	Company_id fields.ValInt `json:"company_id"`
	Study_document_register_id fields.ValInt `json:"study_document_register_id"`
	User_id fields.ValInt `json:"user_id" required:"true"`
	Snils fields.ValText `json:"snils"`
	Issue_date string `json:"issue_date"`
	Issue_date_d fields.ValDate
	End_date string `json:"end_date"`
	End_date_d fields.ValDate
	Post fields.ValText `json:"post"`
	Work_place fields.ValText `json:"work_place"`
	Organization fields.ValText `json:"organization"`
	Series fields.ValText `json:"series"`
	Number fields.ValText `json:"number"`
	Study_prog_name fields.ValText `json:"study_prog_name"`
	Profession fields.ValText `json:"profession"`
	Reg_number fields.ValText `json:"reg_number"`
	Study_period fields.ValInt `json:"study_period"`
	Study_period_s string
	Study_type fields.ValText `json:"study_type"`
	Name_first fields.ValText `json:"name_first"`
	Name_second fields.ValText `json:"name_second"`
	Name_middle fields.ValText `json:"name_middle"`
	Qualification_name fields.ValText `json:"qualification_name"`
	UUID string `json:"uuid"`
}

//Обработка Сертификат
func (a *APIServer) parse_StudyDocument(body []byte, uuid string) {
	doc := APICertificate{UUID: uuid}
	if err := json.Unmarshal(body, &doc); err != nil {
		a.L.Errorf("parse_StudyDocument json.Unmarshal(): %v", err)
		return
	}
	
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := a.DStore.GetPrimary()
	if err_с != nil {
		a.L.Errorf("parse_StudyDocument GetPrimary(): %v", err_с)
		return
	}
	defer a.DStore.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		a.L.Errorf("parse_StudyDocument BEGIN conn.Exec(): %v", err)
		return
	}
	
	if err := a.commitStudyDocument(&doc, conn, true); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		a.L.Errorf("parse_StudyDocument: %v", err)
		return
	}
	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		a.L.Errorf("parse_StudyDocument COMMIT conn.Exec(): %v", err)
		return
	}
	
	a.setObjectDone(uuid)
}

	
func (a *APIServer) commitStudyDocument(doc *APICertificate, conn *pgx.Conn, addAttachment bool) error {	
	if doc.Issue_date == "" {
		doc.Issue_date_d.IsNull = true
	}else{				
		if d, err := api_parse_date(doc.Issue_date); err != nil {
			a.L.Errorf("commitStudyDocument api_parse_date(): %v", err)
			doc.Issue_date_d.IsNull = true
		}else{
			doc.Issue_date_d.SetValue(d)
		}
	}
	if doc.End_date == "" {
		doc.End_date_d.IsNull = true
	}else{				
		if d, err := api_parse_date(doc.End_date); err != nil {
			a.L.Errorf("commitStudyDocument api_parse_date(): %v", err)			
			doc.End_date_d.IsNull = true
		}else{
			doc.End_date_d.SetValue(d)
		}
	}	
	doc.Study_period_s = fmt.Sprintf("%d", doc.Study_period.GetValue())
	doc.Snils.SetValue(UnformatSnils(doc.Snils.GetValue()))
	if _, err := conn.Exec(context.Background(),
		`INSERT INTO study_documents
		(id, company_id, study_document_register_id, user_id, post, issue_date, end_date, work_place, organization, series,
		number, study_prog_name, profession, reg_number, study_period, name_first, name_second, name_middle, qualification_name,
		study_type, snils, create_type)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
			$11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, 'api')
		ON CONFLICT (id) DO UPDATE
		SET
			company_id = $2,
			study_document_register_id = $3,
			user_id = $4,
			post = $5,
			issue_date = $6,
			end_date = $7,
			work_place = $8,
			organization = $9,
			series = $10,
			number = $11,
			study_prog_name = $12,
			profession = $13,
			reg_number = $14,
			study_period = $15,
			name_first = $16,
			name_second = $17,
			name_middle = $18,
			qualification_name = $19,
			study_type = $20,
			snils = $21,
			create_type = 'api'`,
		doc.Model_id,
		doc.Company_id,
		doc.Study_document_register_id,
		doc.User_id,
		doc.Post,
		doc.Issue_date_d,
		doc.End_date_d,		
		doc.Work_place,
		doc.Organization,
		doc.Series,
		doc.Number,
		doc.Study_prog_name,
		doc.Profession,
		doc.Reg_number,
		doc.Study_period_s,
		doc.Name_first,
		doc.Name_second,
		doc.Name_middle,
		doc.Qualification_name,
		doc.Study_type,
		doc.Snils,
		); err != nil {
		
		return errors.New(fmt.Sprintf("INSERT INTO study_documents: %v", err))
	}

	if _, err := conn.Exec(context.Background(),
		`INSERT INTO object_mod_log
		(user_descr, object_type, object_id, object_descr, date_time, action, details)
		VALUES ($1, 'study_documents', $2, $3, now(), 'insert', null)`, 
		API_USER_DESCR, doc.Model_id, fmt.Sprintf("ID: %d", doc.Model_id),
		); err != nil {
		
		a.L.Errorf("commitStudyDocument INSERT INTO object_mod_log: %v", err)		
	}
	if addAttachment {
		return a.addAttachmentToDB(conn, "study_documents", doc.Model_id.GetValue(), doc.UUID)
	}else{
		return nil
	}
}

//********** CLIENT/COMPANY ********************************
type APIClient struct {
	Model_id fields.ValInt `json:"model_id"`
	Client_id fields.ValInt `json:"client_id"`
	Name fields.ValText `json:"name"`
	Name_full fields.ValText `json:"name_full"`
	Post_address fields.ValText `json:"post_address"`
	Legal_address fields.ValText `json:"legal_address"`
	Okved fields.ValText `json:"okved"`
	Okpo fields.ValText `json:"okpo"`
	Inn fields.ValText `json:"inn"`
	Kpp fields.ValText `json:"kpp"`
	Ogrn fields.ValText `json:"ogrn"`
}

//Обработка Client
func (a *APIServer) parse_Client(body []byte, uuid string) {
	client := APIClient{}
	if err := json.Unmarshal(body, &client); err != nil {
		a.L.Errorf("parse_Client json.Unmarshal(): %v", err)
		return
	}
	
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := a.DStore.GetPrimary()
	if err_с != nil {
		a.L.Errorf("parse_Client GetPrimary(): %v", err_с)
		return
	}
	defer a.DStore.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		a.L.Errorf("parse_Client BEGIN conn.Exec(): %v", err)
		return
	}
	
	if err := a.commitClient(&client, conn); err != nil {
		a.L.Errorf("parse_Client: %v", err)
		return
	}

	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		a.L.Errorf("parse_Client COMMIT conn.Exec(): %v", err)
		return
	}
	
	a.setObjectDone(uuid)
}	

func (a *APIServer) commitClient(client *APIClient, conn *pgx.Conn) error {	
	if _, err := conn.Exec(context.Background(),
		`INSERT INTO clients
		(id, name, name_full, inn, kpp, ogrn, legal_address, post_address, okpo, okved,
		parent_id)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
		ON CONFLICT (id) DO UPDATE
		SET
			name = $2,
			name_full = $3,
			inn = $4,
			kpp = $5,
			ogrn = $6,
			legal_address = $7,
			post_address = $8,
			okpo = $9,
			okved = $10,
			parent_id = $11
		RETURNING id`,
		client.Model_id, client.Name, client.Name_full, client.Inn, client.Kpp, client.Ogrn, client.Legal_address, client.Post_address,
			client.Okpo, client.Okved,
			client.Client_id,
		); err != nil {
		
		return errors.New(fmt.Sprintf("INSERT INTO clients: %v", err))
	}
	descr := ""
	if  client.Name_full.GetValue() != "" {
		descr =  client.Name_full.GetValue()
	}else if  client.Name.GetValue() != "" {
		descr =  client.Name.GetValue()
	}else if  client.Inn.GetValue() != "" {
		descr =  client.Inn.GetValue()
	}else{		
		descr = fmt.Sprintf("ID: %d", client.Model_id)
	}
	
	if _, err := conn.Exec(context.Background(),
		`INSERT INTO object_mod_log
		(user_descr, object_type, object_id, object_descr, date_time, action, details)
		VALUES ($1, 'clients', $2, $3, now(), 'insert', null)`, 
		API_USER_DESCR, client.Model_id, descr,
		); err != nil {
		
		a.L.Errorf("INSERT INTO object_mod_log: %v", err)		
	}
	return nil	
}

//Команда обновление
func (a *APIServer) doUpdate(uuid, objectType string) {
	req, err := a.newRequest("show", map[string]string{"uuid":uuid})	
	if err != nil {
		a.L.Errorf("doUpdate newRequest(): %v", err)
		return
	}
	client := &http.Client{}
	resp, err := client.Do(req)	
	if err != nil {
		a.L.Errorf("doUpdate client.Do(): %v", err)
		return
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		a.L.Errorf("doUpdate ioutil.ReadAll(): %v", err)
		return
	}
	if resp.StatusCode != 200 {		
		if resp.StatusCode == 500 {
			//Отметим как обработанный
			a.setObjectDone(uuid)
		}
		a.L.Errorf("doUpdate uuid: %s, StatusCode: %d", uuid, resp.StatusCode)
		return
	}
	
	switch objectType {
		case "User": a.parse_User(body, uuid)
		case "Certificate": a.parse_StudyDocument(body, uuid)
		case "Company": a.parse_Client(body, uuid)
		case "Client": a.parse_Client(body, uuid)
		case "Protocol": a.parse_StudyDocumentRegister(body, uuid)
		default:
			a.L.Errorf("doUpate uuid: %s, unknown object: %s", uuid, objectType)
	}	
}

//Удаление объекта
func (a *APIServer) doDelete(obj APIObjectType) {
	var tb_table string
	switch obj.Model_name {
		case "User": tb_table = "users"
		case "Certificate": tb_table = "study_documents"
		case "Company": tb_table = "clients"
		case "Client": tb_table = "clients"
		case "StudyDocumentRegister": tb_table = "study_document_registers"
		case "Protocol": tb_table = "study_document_registers"
		default:
			a.L.Errorf("doUpate doDelete: %s, unknown object: %s",  obj.UUID, obj.Model_name)
	}
	
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := a.DStore.GetPrimary()
	if err_с != nil {
		a.L.Errorf("doDelete GetPrimary(): %v", err_с)
		return
	}
	defer a.DStore.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
		
	if _, err := conn.Exec(context.Background(),
		fmt.Sprintf(`DELETE FROM %s WHERE id = %d`, tb_table, obj.Model_id)); err != nil {
	
		a.L.Errorf("doDelete DELETE Exec(): %v", err)
		return
	}
	
	//либо нет, либо удалили
	a.setObjectDone(obj.UUID)
}

//Добавление вложения, превью
func (a *APIServer) addAttachmentToDB(conn *pgx.Conn, objType string, objID int64, uuid string) error {
	if attach_bt, err := a.getAttachment(uuid); err == nil {
		//Есть вложение
		var preview_bt []byte //buffer
		file_id := uuid
		real_name := "Вложение.pdf"
		preview_fn := getPreviewCacheFileName(a.BaseDir, file_id)
		att_n := getAttachmentCacheFileName(a.BaseDir, file_id)
		
		f, _ := os.Create(att_n)
		defer func(){
			f.Close()
			os.Remove(att_n)
		}()
		if _, err := f.Write(attach_bt); err == nil {			
			if err := genThumbnail(att_n, preview_fn, real_name); err != nil {
				//Это не критические ошибки
				a.L.Errorf("genThumbnail(): %v", err)
			}else {
				preview_bt, err = ioutil.ReadFile(preview_fn)
				if err != nil {
					//Это не критические ошибки
					a.L.Errorf("ioutil.ReadFile(): %v", err)
				}		
			}
			os.Remove(preview_fn)
		}
		conn.Exec(context.Background(), 
			fmt.Sprintf(`DELETE FROM study_document_attachments
			WHERE study_documents_ref->>'dataType'='%s' AND (study_documents_ref->'keys'->>'id')::int=%d`,
				objType, objID))
		
		if _, err := conn.Exec(context.Background(), 
			fmt.Sprintf(`INSERT INTO study_document_attachments
				(study_documents_ref, content_info, content_data, content_preview)
				VALUES
				('{"dataType": "%s", "keys": {"id": %d}}',
				'{"id": "%s", "name": "%s", "size": %d}',
				$1, $2)`, objType, objID, file_id, real_name, len(attach_bt)),
			attach_bt, preview_bt); err != nil {
		
			return errors.New(fmt.Sprintf("INSERT INTO study_document_attachments: %v, dataType=%s, id=%d", err, objType, objID))
		}
		
	}else if err != nil {
		errors.New(fmt.Sprintf("APIServer addAttachmentToDB(): %v", err))
	}
	return nil
}

//Добавление обработанного объекта в список
func (a *APIServer) setObjectDone(uuid string) {
	a.mu.Lock()
	a.DoneObjects = append(a.DoneObjects, uuid)
	a.mu.Unlock()	
}

//Очистка обработанных данных
func (a *APIServer) clearDone() {
	a.mu.Lock()
	defer a.mu.Unlock()

	if len(a.DoneObjects) == 0 {
		return
	}
	done_objects, err := json.Marshal(&a.DoneObjects)
	if err != nil {
		a.L.Errorf("clearDone json.Marshal(): %v", err)
		return
	}
	req, err := a.newRequest("delete", map[string]string{"uuid": string(done_objects)})	
	if err != nil {
		a.L.Errorf("clearDone newRequest(): %v", err)
		return
	}	
	client := &http.Client{}
	resp, err := client.Do(req)	
	if err != nil {
		a.L.Errorf("clearDone client.Do(): %v", err)
		return
	}
	if resp.StatusCode != 200 {
		a.L.Errorf("clearDone StatusCode: %d", resp.StatusCode)
		return
	}
	
	a.DoneObjects = make([]string, 0)
}

//Обработка данных, создание потоков макс. a.WorkerCount
//Выходим по завершению всех воркеров
//Чистим обработанные
func (a *APIServer) processData(objects *APIData) {
	//количество заданий
	upd_cnt := len(objects.Update)
	del_cnt := len(objects.Delete)
	work_cnt := upd_cnt + del_cnt
	if work_cnt == 0 {
		return
	}
	//Количество пакетов запусков воркеров
	worker_iter_cnt := work_cnt / a.WorkerCount
	if work_cnt % a.WorkerCount > 0 {
		worker_iter_cnt++
	}
	
	//индексы начала запуска
	upd_ind := 0
	del_ind := 0
		
	//Имеем worker_iter_cnt пакетов по a.WorkerCount или остаток
//a.L.Debugf("Всего заданий: %d, макс. количество потоков: %d, всего итераций: %d", work_cnt, a.WorkerCount, worker_iter_cnt)	
	for w_iter := 0; w_iter < worker_iter_cnt; w_iter++ {
		iter_w_upd_cnt := 0 //количество воркеров update в этом пакете
		if upd_cnt > 0 {
			if upd_cnt <= a.WorkerCount {
				iter_w_upd_cnt = upd_cnt
			}else{
				iter_w_upd_cnt = a.WorkerCount
			}
		}
		iter_w_del_cnt := 0 //количество воркеров delete в этом пакете
		if del_cnt > 0 && iter_w_upd_cnt < a.WorkerCount {
			//есть место для запуска delete воркеров
			if del_cnt <= (a.WorkerCount - upd_cnt) {
				iter_w_del_cnt = del_cnt
			}else{
				iter_w_del_cnt = a.WorkerCount - upd_cnt
			}			
		}
//a.L.Debugf("запускаем пакет заданий iter_w_upd_cnt=%d, iter_w_del_cnt=%d", iter_w_upd_cnt, iter_w_del_cnt)
		//запускаем пакет заданий из iter_w_upd_cnt и iter_w_del_cnt
		var wg sync.WaitGroup
		wg.Add(iter_w_upd_cnt + iter_w_del_cnt)
		
		for i := 0; i < iter_w_upd_cnt; i++ {
			ind := upd_ind
			go func() {
				defer wg.Done()
				a.doUpdate(objects.Update[ind].UUID, objects.Update[ind].Model_name)
			}()			
			upd_ind++
			upd_cnt-- 
		}
		for i := 0; i < iter_w_del_cnt; i++ {
			ind := del_ind
			go func() {
				defer wg.Done()
				a.doDelete(objects.Delete[ind])
			}()			
			del_ind++
			del_cnt--
		}
		
		wg.Wait()
	}
//a.L.Debug("Все задания выполнены")		
	//delete
	a.clearDone()
}

//Чтение новых данных
func (a *APIServer) checkData() {	
	//1) выгребаем новые данные	
	req, err := a.newRequest("index", nil)	
	if err != nil {
		a.L.Errorf("checkData newRequest(): %v", err)
		return
	}
	client := &http.Client{}
	resp, err := client.Do(req)		
	if err != nil {
		a.L.Errorf("checkData client.Do(): %v", err)
		return
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		a.L.Errorf("ioutil.ReadAll(): %v", err)
		return
	}
	if resp.StatusCode != 200 {
		a.L.Errorf("StatusCode: %d", resp.StatusCode)
		//, body: %s, string(body)
		return
	}
	
	objects := APIData{}
	if err := json.Unmarshal(body, &objects); err != nil {
		a.L.Errorf("json.Unmarshal(): %v, body=", err, string(body))
		return
	}
	a.processData(&objects)
}

type attachmentForDownload struct {
	Type string
	Id int64
	UUID string
}

type attachmentsForDownload struct {
	sync.Mutex
	AttachmentList []attachmentForDownload
}

type APIUserExt struct {
	APIUser	
	Companies []APIClient `json:"companies"`
	Protocols []APIProtocol `json:"protocols"`
	Certificates []APICertificate `json:"certificates"`
}
//********** ВСЕ ДАННЫЕ ПОЛЬЗОВАТЕЛЯ ПО ЮРЛ ********************************
//вызывается из PersonData_Controller
//returns UserID
func (a *APIServer) GetPersonData(personURL string) (int64, error) {
	req, err := a.newRequest("index", map[string]string{"qrcode": personURL})	
	if err != nil {
		return 0, err
	}
	client := &http.Client{}
	resp, err := client.Do(req)	
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)

	if err != nil {
		return 0, err
	}
	if resp.StatusCode != 200 {		
		return 0, errors.New(fmt.Sprintf("StatusCode: %d", resp.StatusCode))
	}
	user_ext := APIUserExt{}
	if err := json.Unmarshal(body, &user_ext); err != nil {
		return 0, err
	}
	
	return a.processPersonData(&user_ext)
}

//returns UserID
func (a *APIServer) processPersonData(user_ext *APIUserExt) (int64, error) {
	var wg errgroup.Group	
	
	//commit user
	user := APIUser{Model_id: user_ext.Model_id,
		Name: user_ext.Name,
		Name_full: user_ext.Name_full,
		Post: user_ext.Post,
		Sex: user_ext.Sex,
		Birthdate: user_ext.Birthdate,
		Snils: user_ext.Snils,
		Photo: user_ext.Photo,
		QRCode: user_ext.QRCode,
		Company_id: user_ext.Company_id,
		Client_id: user_ext.Client_id,
		UUID: user_ext.UUID,
	}
	wg.Go(func() error {		
		pool_conn, conn_id, err := a.DStore.GetPrimary()
		if err != nil {
			return err
		}
		defer a.DStore.Release(pool_conn, conn_id)
		conn := pool_conn.Conn()
		
		if err := a.commitUser(&user, conn, false); err != nil {
			return err
		}
		return nil	
	})

	//Companies
	wg.Go(func() error {		
		pool_conn, conn_id, err := a.DStore.GetPrimary()
		if err != nil {
			return err
		}
		defer a.DStore.Release(pool_conn, conn_id)
		conn := pool_conn.Conn()
	
		for _, cl := range user_ext.Companies {
			if err := a.commitClient(&cl, conn); err != nil {
				return err
			}
		}
		
		return nil	
	})	

	att := attachmentsForDownload{AttachmentList: make([]attachmentForDownload, 0)}

	//protocols
	wg.Go(func() error {		
		pool_conn, conn_id, err := a.DStore.GetPrimary()
		if err != nil {
			return err
		}
		defer a.DStore.Release(pool_conn, conn_id)
		conn := pool_conn.Conn()
	
		for _, prot := range user_ext.Protocols {
			if err := a.commitStudyDocumentRegister(&prot, conn, false); err != nil {
				return err
			}
			att.Lock()
			att.AttachmentList = append(att.AttachmentList, attachmentForDownload{Type: "study_document_registers",
					Id: prot.Model_id.GetValue(),
					UUID: prot.UUID,
					})
			att.Unlock()
		}
		
		return nil	
	})	
	
	//Certificates
	wg.Go(func() error {		
		pool_conn, conn_id, err := a.DStore.GetPrimary()
		if err != nil {
			return err
		}
		defer a.DStore.Release(pool_conn, conn_id)
		conn := pool_conn.Conn()
	
		for _, cert := range user_ext.Certificates {
			if err := a.commitStudyDocument(&cert, conn, false); err != nil {
				return err
			}
			att.Lock()
			att.AttachmentList = append(att.AttachmentList, attachmentForDownload{Type: "study_documents",
					Id: cert.Model_id.GetValue(),
					UUID: cert.UUID,
					})
			att.Unlock()
		}
		
		return nil	
	})	
		
	 if err := wg.Wait(); err != nil {
	 	return 0, err
	 }

	 go func(){
		pool_conn, conn_id, err := a.DStore.GetPrimary()
		if err != nil {
			return
		}
		defer a.DStore.Release(pool_conn, conn_id)
		conn := pool_conn.Conn()
		
		if user.Photo {
			if photo, err := a.getAttachment(user.UUID); err == nil {
				if _, err := conn.Exec(context.Background(),
					`UPDATE users
					SET
						photo = $1,
						person_url = $2
					WHERE id = $3`,
					photo, user_ext.QRCode, 
					user.Model_id.GetValue()); err != nil {
				
					a.L.Errorf("processPersonData UPDATE users with photo : %v", err)	
				}
			}else {
				a.L.Errorf("processPersonData a.getAttachment() : %v", err)					
				if _, err := conn.Exec(context.Background(),				
					`UPDATE users SET person_url = $1 WHERE id = $2`, user_ext.QRCode, user.Model_id.GetValue()); err != nil {
				
					a.L.Errorf("processPersonData UPDATE user url after  getAttachment error : %v", err)	
				}
			}
			
		}else if _, err := conn.Exec(context.Background(),
			`UPDATE users SET person_url = $1 WHERE id = $2`, user_ext.QRCode, user.Model_id.GetValue()); err != nil {
			
				a.L.Errorf("processPersonData UPDATE users without photo : %v", err)	
		}
		for _, att_v := range att.AttachmentList {
			if err := a.addAttachmentToDB(conn, att_v.Type, att_v.Id, att_v.UUID); err != nil {
				a.L.Errorf("processPersonData(): %v", err)	
			}
		}
	}()
	
	 return user_ext.Model_id.GetValue(), nil
}

//Создает новый HTTP запрос для API
func (a *APIServer) newRequest(method string, params map[string]string) (*http.Request, error) {
	params_s := ""
	if params != nil {
		for k, v := range params {
			n := len(v)
			if n == 0 {
				continue
			}
			if !( (v[0:1] == "[" && v[n-1:] == "]") || (v[0:1] == "{" && v[n-1:] == "}") ) {
				v = `"` + v + `"`
			}
			params_s+= fmt.Sprintf(`, "%s": %s`, k, v)
		}
	}
	payload := fmt.Sprintf(`{"token": "%s", "method": "%s"%s}`, a.Token, method, params_s)
	req, err := http.NewRequest(http.MethodPost, a.Host, bytes.NewBuffer([]byte(payload)))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "*/*")
	return req, nil
}


func NewAPIServer(dStore *pgds.PgProvider, l logger.Logger, baseDir string) (*APIServer, error) {
	api_srv := APIServer{DStore: dStore, L: l, BaseDir: baseDir}
	
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := dStore.GetSecondary("")
	if err != nil {
		return nil, err
	}
	conn := pool_conn.Conn()
	defer dStore.Release(pool_conn, conn_id)
	
	if err := conn.QueryRow(context.Background(),
		`SELECT
			text_to_int_safe_cast(val->>'check_interval_ms'),
			text_to_int_safe_cast(val->>'worker_count'),
			coalesce(val->>'host', ''),
			coalesce(val->>'token', '')
		FROM const_api_server LIMIT 1`,
		).Scan(&api_srv.CheckInterval, &api_srv.WorkerCount, &api_srv.Host, &api_srv.Token); err != nil {
		
		return nil, err
	}

	if api_srv.Host =="" || api_srv.CheckInterval == 0 {
		return nil, errors.New("NewAPIServer wrong parameter values")
	}

	return &api_srv, nil
}

//Старт сервера чтения по API
func StartAPIServer(dStore *pgds.PgProvider, l logger.Logger, baseDir string) {
	api_srv, err := NewAPIServer(dStore, l, baseDir)
	if err!= nil {
		l.Errorf("StartAPIServer NewAPIServer(): %v", err)
		return
	}
	
	quitAPIServer = make(chan bool)	
	
	go (func(api_srv *APIServer) {			
		
		l.Debugf("APIServer: starting check loop, interval (ms): %d", api_srv.CheckInterval)
		
		for {
			select {
			case <- quitAPIServer:				
				l.Debug("APIServer: check loop is stopped")
				return
			default:		
				api_srv.checkData()
				time.Sleep(time.Duration(api_srv.CheckInterval) * time.Millisecond)				
			}
		}						
	})(api_srv)
	
	
	//api_srv.checkData()
	//person data check
	/*l.Debug("GetPersonData...")
	if err := api_srv.GetPersonData("ef159690ceef1a60bff667a1632e1905"); err != nil {
		l.Errorf("GetPersonData error: %v", err)
		return
	}
	l.Debug("GetPersonData OK!!!")
	*/
	
	//api_srv.setObjectDone("4e96e718-159c-4530-bf0a-ded07c1ab44b")
	//api_srv.clearDone()
	//api_srv.checkData()
	/*
	u := `{"model_name":"User","model_id":83,"name":"","name_full":"Шульц Алевтина Сергеевна","post":"Программист","sex":"male","birthdate":null,"snils":"","photo":true,"qrcode":"1e7215892cfee903c2c394e6a22af957","company_id":6,"client_id":6}`
	api_srv.parse_User([]byte(u), "4e96e718-159c-4530-bf0a-ded07c1ab44b")
	//api_srv.clearDone()
	api_srv.clearOne("4e96e718-159c-4530-bf0a-ded07c1ab44b")
	*/
	/*
	cl := `{"model_name":"Company","model_id":5881,"client_id":1866,"name":"ООО \"СервисПлюс\"","inn":null,"name_full":null,"legal_address":", , ","post_address":", , ","kpp":null,"ogrn":null,"okpo":null,"okved":null}`
	api_srv.parse_Client([]byte(cl), "682a66ff-a2d6-424d-b3e7-b9a8f45b7d76")
	*/
	
	
	//protocol := `{"model_name":"Protocol","model_id":31438,"name":"1708/5380-ОТ-2022","date_time":"2022-09-14","client_id":5380}`
	//api_srv.parse_StudyDocumentRegister([]byte(protocol), "53e5f16a-5bf3-4bc0-bf0c-85e2f03f9bc2")
	
	
	/*
	o := `{"model_name":"Certificate","model_id":351729,"client_id":1866,"study_document_register_id":31378,
		"user_id":98856,
		"number":"0186637770",
		"date_time":"29.08.2022",
		"snils":"",
		"post":"Механик",
		"work_place":"ИП Черсак Ю.В.",
		"organization":"АНО ДПО «Системные технологии безопасности труда»",
		"issue_date":"29.08.2022","end_date":"2025-08-29","study_type":"Общеобразовательная","series":"2022",
		"reg_number":"122-ОТ-2022/1","name_first":"Денис","name_second":"Мехонцев",
		"name_middle":"Алексеевич","study_prog_name":"Охрана труда для руководителей и специалистов *",
		"profession":null,"study_period":40,"qualification_name":"Охрана труда для руководителей и специалистов *"}`
	api_srv.parse_StudyDocument([]byte(o), "11111111")
	*/
	
	
	//fmt.Println("Updated=", api_srv.DoneObjects)	
}


func api_parse_date(inDate string) (time.Time, error) {
	var res time.Time
	
	if strings.Contains(inDate, " ") {
		//1)10 октября 1983
		d_parts := strings.Split(inDate, " ")
		if len(d_parts) == 3 {			
			m_list := map[string]string{"января": "01", "февраля": "02", "марта": "03", "апреля": "04", "мая": "05",
				"июня": "06", "июля": "07", "августа": "08", "сентября": "09", "октября": "10", "ноября": "11", "декабря": "12",
			}
			if n, ok := m_list[strings.ToLower(d_parts[1])]; ok {
				d := d_parts[0]
				if len(d) == 1 {
					d = "0" + d
				}
				inDate = fmt.Sprintf("%s-%s-%s", d_parts[2], n, d)
			}		
		}			
	}else if strings.Contains(inDate, ".") {	
		//2) 29.08.2022
		d_parts := strings.Split(inDate, ".")
		if len(d_parts) == 3 {			
			inDate = fmt.Sprintf("%s-%s-%s", d_parts[2], d_parts[1], d_parts[0])
		}
		
	}else if len(inDate) > 10 {
		inDate = inDate[:10]
	}
	
	if d, err := time.Parse("2006-01-02", inDate); err != nil {
		return res, err
	}else{
		res = d
	}
	
	return res, nil
}


