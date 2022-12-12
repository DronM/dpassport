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
	
	"dpassport/models"
	
	"ds/pgds"
	
	"osbe"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	
	//"github.com/jackc/pgx/v4/pgxpool"
)

//Controller
type StudyDocumentInsert_Controller struct {
	osbe.Base_Controller
}

func NewController_StudyDocumentInsert() *StudyDocumentInsert_Controller{
	c := &StudyDocumentInsert_Controller{osbe.Base_Controller{ID: "StudyDocumentInsert", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsert_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &StudyDocumentInsert_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsert{})),
			EventList: osbe.PublicMethodEventList{"StudyDocumentInsert.insert"},
		},
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &StudyDocumentInsert_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"StudyDocumentInsert.delete"},
		},
	}
	
	//************************** method update *************************************
	c.PublicMethods["update"] = &StudyDocumentInsert_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsert_old_keys{})),
			EventList: osbe.PublicMethodEventList{"StudyDocumentInsert.update"},
		},
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &StudyDocumentInsert_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &StudyDocumentInsert_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
	//************************** method complete *************************************
	c.PublicMethods["complete"] = &StudyDocumentInsert_Controller_complete{
		osbe.Base_PublicMethod{
			ID: "complete",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsert_complete{})),
		},
	}
	
	//************************** method batch_update *************************************
	c.PublicMethods["batch_update"] = &StudyDocumentInsert_Controller_batch_update{
		osbe.Base_PublicMethod{
			ID: "batch_update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsert_batch_update{})),
		},
	}
	
	//************************** method batch_delete *************************************
	c.PublicMethods["batch_delete"] = &StudyDocumentInsert_Controller_batch_delete{
		osbe.Base_PublicMethod{
			ID: "batch_delete",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsert_batch_delete{})),
		},
	}
		
	return c
}

type StudyDocumentInsert_Controller_keys_argv struct {
	Argv models.StudyDocumentInsert_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type StudyDocumentInsert_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentInsert_Controller_insert) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsert_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}
func (pm *StudyDocumentInsert_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentInsert"], &models.StudyDocumentInsert_keys{}, sock.GetPresetFilter("StudyDocumentInsert"))	
}

//************************* DELETE **********************************************
type StudyDocumentInsert_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentInsert_Controller_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsert_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsert_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentInsert"], sock.GetPresetFilter("StudyDocumentInsert"))	
}

//************************* GET OBJECT **********************************************
type StudyDocumentInsert_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentInsert_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsert_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsert_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentInsertList"], &models.StudyDocumentInsertList{}, sock.GetPresetFilter("StudyDocumentInsertList"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type StudyDocumentInsert_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsert_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsert_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentInsertList"], &models.StudyDocumentInsertList{}, sock.GetPresetFilter("StudyDocumentInsertList"))	
}

//************************* UPDATE **********************************************
//Public method: update
type StudyDocumentInsert_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsert_Controller_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsert_old_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsert_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentInsert"], sock.GetPresetFilter("StudyDocumentInsert"))	
}

//************************** COMPLETE ********************************************************
//Public method: complete
type StudyDocumentInsert_Controller_complete struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsert_Controller_complete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsert_complete_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsert_Controller_complete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.CompleteOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentInsertSelectList"], &models.StudyDocumentInsertSelectList{}, sock.GetPresetFilter("StudyDocumentInsertSelectList"))	
}

//************************* batch_update **********************************************
//Public method: batch_update
type StudyDocumentInsert_Controller_batch_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsert_Controller_batch_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsert_batch_update_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsert_Controller_batch_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsert_Controller_batch_update Request.GetPrimary(): %v",err_с))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	//*****************
	
	args := rfltArgs.Interface().(*models.StudyDocumentInsert_batch_update)
	
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsert_Controller_batch_update BEGIN: %v",err))
	}
	
	pr_f := sock.GetPresetFilter("StudyDocumentInsert")
	m := app.GetMD().Models["StudyDocumentInsert"]
	for _, ob := range args.Objects {
		rflct := reflect.ValueOf(&ob).Elem()
		if err := osbe.UpdateOnArgsWithConn(conn, app, pm, resp, sock, rflct, m, pr_f); err != nil {
			conn.Exec(context.Background(), "ROLLBACK")
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsert_Controller_batch_update Update(): %v",err))
		}
	}

	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsert_Controller_batch_update BEGIN: %v",err))
	}
	
	return nil
}

//************************* batch_delete **********************************************
//Public method: batch_delete
type StudyDocumentInsert_Controller_batch_delete struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsert_Controller_batch_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsert_batch_delete_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsert_Controller_batch_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsert_Controller_batch_delete Request.GetPrimary(): %v",err_с))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	//*****************
	
	args := rfltArgs.Interface().(*models.StudyDocumentInsert_batch_delete)
	
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsert_Controller_batch_delete BEGIN: %v",err))
	}
	
	pr_f := sock.GetPresetFilter("StudyDocumentInsert")
	m := app.GetMD().Models["StudyDocumentInsert"]
	for _, ob := range args.Keys {
		rflct := reflect.ValueOf(&ob).Elem()
		if err := osbe.DeleteOnArgKeysWithConn(conn, app, pm, resp, sock, rflct, m, pr_f); err != nil {
			conn.Exec(context.Background(), "ROLLBACK")
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsert_Controller_batch_delete Delete(): %v",err))
		}
	}

	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsert_Controller_batch_delete BEGIN: %v",err))
	}
	
	return nil
}
