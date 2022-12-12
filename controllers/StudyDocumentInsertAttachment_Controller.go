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
	"strings"
	"fmt"
	"context"
	
	"dpassport/models"
	
	"ds/pgds"
	"osbe"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	"osbe/srv/httpSrv"
	
	//"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

const SNILS_LEN = 11
const ATT_CNT_INSERT = 10

//Controller
type StudyDocumentInsertAttachment_Controller struct {
	osbe.Base_Controller
}

func NewController_StudyDocumentInsertAttachment() *StudyDocumentInsertAttachment_Controller{
	c := &StudyDocumentInsertAttachment_Controller{osbe.Base_Controller{ID: "StudyDocumentInsertAttachment", PublicMethods: make(osbe.PublicMethodCollection)}}	
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &StudyDocumentInsertAttachment_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
	//************************** method add_file *************************************
	c.PublicMethods["add_files"] = &StudyDocumentInsertAttachment_Controller_add_files{
		osbe.Base_PublicMethod{
			ID: "add_files",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsertAttachment_add_files{})),
		},
	}
			
	return c
}

//************************* GET LIST **********************************************
//Public method: get_list
type StudyDocumentInsertAttachment_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsertAttachment_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsertAttachment_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentInsertAttachmentList"], &models.StudyDocumentInsertAttachmentList{}, sock.GetPresetFilter("StudyDocumentInsertAttachmentList"))	
}

//************************* add_files **********************************************

//Public method: add_files
type StudyDocumentInsertAttachment_Controller_add_files struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsertAttachment_Controller_add_files) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsertAttachment_add_files_argv{}
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsertAttachment_Controller_add_files) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	http_sock, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "StudyDocumentInsertAttachment_Controller_add_files Not HTTPSocket type")
	}	

	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	args := rfltArgs.Interface().(*models.StudyDocumentInsertAttachment_add_files)
	
	//Structs described in attachments.go
	var content_info []models.Content_info_Type
	if err := json.Unmarshal(args.Content_info.GetValue(), &content_info); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertAttachment_Controller_add_file json.Unmarshal(): %v",err))
	}
	
	//Читаем ФИО всех сотров SNILS!!!
	user_names := make(map[string]int64)	
	user_snils := make(map[string]int64)	
	rows, err := conn.Query(context.Background(),
		`SELECT
			id,
			coalesce(lower(trim(name_full)), ''),
			coalesce(snils, '')
		FROM study_document_inserts_list
		WHERE study_document_insert_head_id = $1`,
		args.Study_document_insert_head_id.GetValue(),
	)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertAttachment_Controller_add_file SELECT pgx.Conn.Query(): %v",err))
	}	

	for rows.Next() {
		name_full := ""	
		snils:= ""
		var id int64
		if err := rows.Scan(&id, &name_full, &snils); err != nil {		
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertAttachment_Controller_add_file SELECT Scan(): %v",err))
		}
		//Полное ФИО
		user_names[name_full] = id
		//Фамилия!!!
		name_full_parts := strings.Split(name_full, " ")
		if len(name_full_parts) > 0 {
			user_names[name_full_parts[0]] = id			
		}
		
		user_snils[snils] = id
	}
	if err := rows.Err(); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertAttachment_Controller_add_file SELECT pgx.Conn.Query(): %v",err))
	}
	rows.Close()

	isNotDigit := func(c rune) bool { return c < '0' || c > '9' }
	
	files := http_sock.Request.MultipartForm.File["content_data[]"]
	if len(content_info) != len(files) {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "StudyDocumentAttachment_Controller_add_file len(content_info) != len(files)")
	}
	for i, file_h := range files {		
		if !FileHeaderContainsMime(file_h, httpSrv.MIME_TYPE_pdf) {
			return osbe.NewPublicMethodError(ER_UNSUPPORTED_MIME_CODE, ER_UNSUPPORTED_MIME_DESCR)
		}
		
		//Разбор имени файла, поиск юзера по ФИО(полное и только фамилия)/СНИЛС
		name := strings.ToLower(file_h.Filename)
		name_parts := strings.Split(name, ".")
		study_document_insert_id := fields.NewValInt(0, true)
		if len(name_parts) > 0 {
			name_parts = name_parts[:len(name_parts)-1]
			name = strings.Join(name_parts, ".")
			name = strings.TrimSpace(name)
		}
		if id, ok:= user_names[name]; ok {
			//found by name
			study_document_insert_id.SetValue(id)
			
		}else{
			//delete all - and space util.go
			name = UnformatSnils(name)
		}
		if len(name) == SNILS_LEN && strings.IndexFunc(name, isNotDigit) == -1 {
			if id, ok := user_snils[name]; ok {
				//found by snils
				study_document_insert_id.SetValue(id)
			}
		}
		/*
		study_document_insert_attachment_id := 0
		if err := conn.QueryRow(context.Background(),
			`UPDATE study_document_inserts
			(study_document_insert_head_id, study_document_insert_id)
			VALUES ($1, $2)
			ON CONFLICT (study_document_insert_head_id, study_document_insert_id)
			DO UPDATE
			SET study_document_insert_head_id = $1 
			RETURNING id`,
			args.Study_document_insert_head_id,
			study_document_insert_id,
			).Scan(&study_document_insert_attachment_id); err != nil {
			
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertAttachment_Controller_add_file INSERT: %v",err))
		}
		*/
		
		//Если не нашли, пропускаем?
		if study_document_insert_id.GetValue() == 0 {
			continue
		}
		
		//сделать превью, все сохранить в базу
		file, err := file_h.Open()
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertAttachment_Controller_add_file file_h.Open(): %v",err))
		}
		defer file.Close()
		ref := &models.Study_documents_ref_Type{DataType: "study_document_inserts",
			Keys: models.StudyDocKey{Id: models.HttpInt(study_document_insert_id.GetValue())},
		}
		if _, err := AddFileThumbnailToDb(conn, app.GetBaseDir(), file, &content_info[i], ref); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertAttachment_Controller_add_file AddFileThumbnailToDb(): %v",err))
		}		
	}
	
	return nil	
}


