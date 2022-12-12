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
	"fmt"
	"context"
	"os"
	"time"
	
	"dpassport/models"
	
	"osbe"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	"osbe/srv/httpSrv"	
	"osbe/view"
	"ds/pgds"	
	
	"github.com/jackc/pgx/v4/pgxpool"
	"github.com/jackc/pgx/v4"	
)

//Controller
type StudyDocumentAttachment_Controller struct {
	osbe.Base_Controller
}

func NewController_StudyDocumentAttachment() *StudyDocumentAttachment_Controller{
	c := &StudyDocumentAttachment_Controller{osbe.Base_Controller{ID: "StudyDocumentAttachment", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.StudyDocumentAttachment_keys{}))
	
	
	
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &StudyDocumentAttachment_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &StudyDocumentAttachment_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
	//************************** method delete_file *************************************
	c.PublicMethods["delete_file"] = &StudyDocumentAttachment_Controller_delete_file{
		osbe.Base_PublicMethod{
			ID: "delete_file",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentAttachment_delete_file{})),
		},
	}
	//************************** method add_file *************************************
	c.PublicMethods["add_file"] = &StudyDocumentAttachment_Controller_add_file{
		osbe.Base_PublicMethod{
			ID: "add_file",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentAttachment_add_file{})),
		},
	}
	//************************** method get_file *************************************
	c.PublicMethods["get_file"] = &StudyDocumentAttachment_Controller_get_file{
		osbe.Base_PublicMethod{
			ID: "get_file",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentAttachment_get_file{})),
		},
	}
			
	
	return c
}

type StudyDocumentAttachment_Controller_keys_argv struct {
	Argv models.StudyDocumentAttachment_keys `json:"argv"`	
}



//************************* GET OBJECT **********************************************
type StudyDocumentAttachment_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentAttachment_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentAttachment_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentAttachment_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentAttachmentList"], &models.StudyDocumentAttachmentList{}, sock.GetPresetFilter("StudyDocumentAttachmentList"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type StudyDocumentAttachment_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentAttachment_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentAttachment_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentAttachmentList"], &models.StudyDocumentAttachmentList{}, sock.GetPresetFilter("StudyDocumentAttachmentList"))	
}

//************************* delete_file **********************************************
//Public method: delete_file
type StudyDocumentAttachment_Controller_delete_file struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentAttachment_Controller_delete_file) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentAttachment_delete_file_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentAttachment_Controller_delete_file) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	args := rfltArgs.Interface().(*models.StudyDocumentAttachment_delete_file)
	
	if _, err := conn.Exec(context.Background(),
		`DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = $1
			AND (study_documents_ref->'keys'->>'id')::int = $2
			AND content_info->>'id' = $3`,
		args.Study_documents_ref.DataType,
		args.Study_documents_ref.Keys.Id,
		args.Content_id,
	); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_delete_file conn.Exec(): %v",err))	
	}
	
	//action to document
	addScanAction(app, conn, sock, "delete_scan", int64(args.Study_documents_ref.Keys.Id), args.Study_documents_ref.DataType)	
	
	att_n := getAttachmentCacheFileName(app.GetBaseDir(), args.Content_id.GetValue())
	if view.FileExists(att_n) {
		if err := os.Remove(att_n); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_delete_file os.Remove(): %v",err))	
		}
	}
	preview_fn := getPreviewCacheFileName(app.GetBaseDir(), args.Content_id.GetValue())
	if view.FileExists(preview_fn) {
		if err := os.Remove(preview_fn); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_delete_file os.Remove(): %v",err))	
		}
	}
	return nil
}

//************************* get_file **********************************************
//Public method: get_file
type StudyDocumentAttachment_Controller_get_file struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentAttachment_Controller_get_file) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentAttachment_get_file_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentAttachment_Controller_get_file) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//returns file
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	args := rfltArgs.Interface().(*models.StudyDocumentAttachment_get_file)
	
	var att_id int64
	var att_name fields.ValText
	if err := conn.QueryRow(context.Background(),
		`SELECT
			id,
			content_info->>'name'
		FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = $1
			AND (study_documents_ref->'keys'->>'id')::int = $2
			AND content_info->>'id' = $3`,
		args.Study_documents_ref.DataType,
		args.Study_documents_ref.Keys.Id,
		args.Content_id,
	).Scan(&att_id, &att_name); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_get_file conn.QueryRow(): %v",err))	
	}
	
	var cont_disp httpSrv.CONTENT_DISPOSITION
	if args.Inline.GetValue() == 1 {
		cont_disp = httpSrv.CONTENT_DISPOSITION_INLINE
	}else{
		cont_disp = httpSrv.CONTENT_DISPOSITION_ATTACHMENT
	}
	
	var cache_f *os.File
	var err error
	cache_fn := getAttachmentCacheFileName(app.GetBaseDir(), args.Content_id.GetValue())
	if view.FileExists(cache_fn) {
		//from cache		
		cache_f, err = os.Open(cache_fn)
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_get_file os.Open(): %v", err))
		}
		defer cache_f.Close()		
		
		if err := httpSrv.DownloadFile(resp, sock, cache_f, att_name.GetValue(), "", cont_disp); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_get_file DownloadFile(): %v", err))
		}
		
	}else{
		//no cache, read from db && save
		var f_cont []byte//&fields.ValBytea{}
		if err := conn.QueryRow(context.Background(),
			`SELECT
				content_data
			FROM study_document_attachments
			WHERE id = $1`,
			att_id,
		).Scan(&f_cont); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_get_file conn.QueryRow(): %v",err))	
		}
		
		cache_f, err = os.Create(cache_fn)
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_get_file os.Create(): %v", err))
		}
		defer cache_f.Close()
		if _, err := cache_f.Write(f_cont); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_get_file Write(): %v", err))
		}
		sock_http, ok := sock.(*httpSrv.HTTPSocket)
		if !ok {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "StudyDocumentAttachment_Controller_get_file no cache sock must be *HTTPSocket")
		}
		
		httpSrv.ServeContent(sock_http, &f_cont, att_name.GetValue(), "", time.Time{}, cont_disp)		
	}
	
	return nil
}

//************************* add_file **********************************************
//Public method: add_file
type StudyDocumentAttachment_Controller_add_file struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentAttachment_Controller_add_file) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentAttachment_add_file_argv{}
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
//Structs described in attachments.go
func (pm *StudyDocumentAttachment_Controller_add_file) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	http_sock, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "StudyDocumentAttachment_Controller_add_file Not HTTPSocket type")
	}	
	
	args := rfltArgs.Interface().(*models.StudyDocumentAttachment_add_file)	

	file, file_h, err := http_sock.Request.FormFile("content_data[]")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file Request.FormFile(): %v",err))
	}
	defer file.Close()

	//проверка по типу
	if !FileHeaderContainsMime(file_h, httpSrv.MIME_TYPE_pdf) &&
		!FileHeaderContainsMime(file_h, httpSrv.MIME_TYPE_png) &&
		!FileHeaderContainsMime(file_h, httpSrv.MIME_TYPE_jpg) &&
		!FileHeaderContainsMime(file_h, httpSrv.MIME_TYPE_jpeg) &&
		!FileHeaderContainsMime(file_h, httpSrv.MIME_TYPE_jpe) {
		return osbe.NewPublicMethodError(ER_UNSUPPORTED_MIME_CODE, ER_UNSUPPORTED_MIME_DESCR)
	}

	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
			
	args.Content_info.Name = file_h.Filename
	preview_bt, err := AddFileThumbnailToDb(conn, app.GetBaseDir(), file, &args.Content_info, &args.Study_documents_ref);
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentAttachment_Controller_add_file AddFileThumbnailToDb(): %v",err))	
	}
	
	//action to document
	addScanAction(app, conn, sock, "upload_scan", int64(args.Study_documents_ref.Keys.Id), args.Study_documents_ref.DataType)

	AddPreviewModel(resp, args.Content_info.Id, preview_bt)
		
	return nil
}

func addScanAction(app osbe.Applicationer, conn *pgx.Conn, sock socket.ClientSocketer, oper string, ID int64, dataType string) {
	keys := make(map[string]interface{}, 1)
	keys["id"] = ID
	model_md_id := ""
	if dataType == "study_documents" {
		model_md_id = "StudyDocument"
		
	}else if dataType == "study_document_registers" {
		model_md_id = "StudyDocumentRegister"
	}	
	if model_md, ok := app.GetMD().Models[model_md_id]; ok {
		addAction(conn, sock, model_md, oper, keys)
	}else{
		fmt.Println("dataType=", dataType, "no model MD")
	}
}
