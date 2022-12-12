package controllers

/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

import (
	"encoding/json"
	"reflect"
	
	"transport/models"
	
	"osbe"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	
	//"github.com/jackc/pgx/v4"
)

//Controller
type VariantStorage_Controller struct {
	osbe.Base_Controller
}

func NewController_VariantStorage() *VariantStorage_Controller{
	c := &VariantStorage_Controller{osbe.Base_Controller{ID: "VariantStorage", PublicMethods: make(osbe.PublicMethodCollection)}}
	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.VariantStorage_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &VariantStorage_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.VariantStorage{})),
			EventList: osbe.PublicMethodEventList{"VariantStorage.insert"},
		},
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &VariantStorage_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"VariantStorage.delete"},
		},				
	}

	//************************** method update *************************************
	c.PublicMethods["update"] = &VariantStorage_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.VariantStorage_old_keys{})),
			EventList: osbe.PublicMethodEventList{"VariantStorage.update"},
		},				
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &VariantStorage_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},	
	}

	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &VariantStorage_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},		
	}

	
	//************************** method upsert_filter_data **********************************
	c.PublicMethods["upsert_filter_data"] = &VariantStorage_Controller_upsert_filter_data{
		osbe.Base_PublicMethod{
			ID: "upsert_filter_data",
			Fields: fields.GenModelMD(reflect.ValueOf(models.VariantStorage_upsert_filter_data{})),
		},				
	}	
	//************************** method upsert_col_visib_data **********************************
	c.PublicMethods["upsert_col_visib_data"] = &VariantStorage_Controller_upsert_col_visib_data{
		osbe.Base_PublicMethod{
			ID: "upsert_col_visib_data",
			Fields: fields.GenModelMD(reflect.ValueOf(models.VariantStorage_upsert_col_visib_data{})),
		},				
	}	
	//************************** method upsert_col_order_data **********************************
	c.PublicMethods["upsert_col_order_data"] = &VariantStorage_Controller_upsert_col_order_data{
		osbe.Base_PublicMethod{
			ID: "upsert_col_order_data",
			Fields: fields.GenModelMD(reflect.ValueOf(models.VariantStorage_upsert_col_order_data{})),
		},				
	}	
	//************************** method get_filter_data **********************************
	c.PublicMethods["get_filter_data"] = &VariantStorage_Controller_get_filter_data{
		osbe.Base_PublicMethod{
			ID: "get_filter_data",
			Fields: fields.GenModelMD(reflect.ValueOf(models.VariantStorage_get_filter_data{})),
		},				
	}	
	//************************** method get_col_visib_data **********************************
	c.PublicMethods["get_col_visib_data"] = &VariantStorage_Controller_get_col_visib_data{
		osbe.Base_PublicMethod{
			ID: "get_col_visib_data",
			Fields: fields.GenModelMD(reflect.ValueOf(models.VariantStorage_get_col_visib_data{})),
		},				
	}	
	//************************** method get_col_order_data **********************************
	c.PublicMethods["get_col_order_data"] = &VariantStorage_Controller_get_col_order_data{
		osbe.Base_PublicMethod{
			ID: "get_col_order_data",
			Fields: fields.GenModelMD(reflect.ValueOf(models.VariantStorage_get_col_order_data{})),
		},				
	}
	return c	
}

type VariantStorage_Controller_keys_argv struct {
	Argv models.VariantStorage_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type VariantStorage_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_insert) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}

	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}
func (pm *VariantStorage_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["VariantStorage"], models.VariantStorage_keys{}, nil)
}

//************************* DELETE **********************************************
type VariantStorage_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_delete) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["VariantStorage"], nil)
}

//************************* GET OBJECT **********************************************
type VariantStorage_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_get_object) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["VariantStorage"], &models.VariantStorage{}, sock.GetPresetFilter("VariantStorage"))
}

//************************* GET LIST **********************************************
//Public method: get_list
type VariantStorage_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_get_list) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &model.Controller_get_list_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["VariantStorage"], &models.VariantStorage{}, sock.GetPresetFilter("VariantStorage"))
}

//************************* UPDATE **********************************************
//Public method: update
type VariantStorage_Controller_update struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_update) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_old_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["VariantStorage"], nil)
}
//Custom method
type VariantStorage_Controller_upsert_filter_data struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_upsert_filter_data) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_upsert_filter_data_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_upsert_filter_data) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return nil
}
//Custom method
type VariantStorage_Controller_upsert_col_visib_data struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_upsert_col_visib_data) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_upsert_col_visib_data_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_upsert_col_visib_data) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return nil
}
//Custom method
type VariantStorage_Controller_upsert_col_order_data struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_upsert_col_order_data) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_upsert_col_order_data_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_upsert_col_order_data) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return nil
}
//Custom method
type VariantStorage_Controller_get_filter_data struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_get_filter_data) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_get_filter_data_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_get_filter_data) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return nil
}
//Custom method
type VariantStorage_Controller_get_col_visib_data struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_get_col_visib_data) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_get_filter_data_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_get_col_visib_data) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return nil
}
//Custom method
type VariantStorage_Controller_get_col_order_data struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *VariantStorage_Controller_get_col_order_data) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.VariantStorage_get_col_order_data_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *VariantStorage_Controller_get_col_order_data) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return nil
}
