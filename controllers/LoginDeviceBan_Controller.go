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
type LoginDeviceBan_Controller struct {
	osbe.Base_Controller
}

func NewController_LoginDeviceBan() *LoginDeviceBan_Controller{
	c := &LoginDeviceBan_Controller{osbe.Base_Controller{ID: "LoginDeviceBan", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.LoginDeviceBan_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &LoginDeviceBan_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.LoginDeviceBan{})),
			EventList: osbe.PublicMethodEventList{"LoginDeviceBan.insert"},
		},
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &LoginDeviceBan_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"LoginDeviceBan.delete"},
		},
	}
	
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &LoginDeviceBan_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &LoginDeviceBan_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
			
	
	return c
}

type LoginDeviceBan_Controller_keys_argv struct {
	Argv models.LoginDeviceBan_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type LoginDeviceBan_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *LoginDeviceBan_Controller_insert) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.LoginDeviceBan_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}
func (pm *LoginDeviceBan_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["LoginDeviceBan"], &models.LoginDeviceBan_keys{}, sock.GetPresetFilter("LoginDeviceBan"))	
}

//************************* DELETE **********************************************
type LoginDeviceBan_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *LoginDeviceBan_Controller_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.LoginDeviceBan_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *LoginDeviceBan_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["LoginDeviceBan"], sock.GetPresetFilter("LoginDeviceBan"))	
}

//************************* GET OBJECT **********************************************
type LoginDeviceBan_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *LoginDeviceBan_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.LoginDeviceBan_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *LoginDeviceBan_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["LoginDeviceBan"], &models.LoginDeviceBan{}, sock.GetPresetFilter("LoginDeviceBan"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type LoginDeviceBan_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *LoginDeviceBan_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *LoginDeviceBan_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["LoginDeviceBan"], &models.LoginDeviceBan{}, sock.GetPresetFilter("LoginDeviceBan"))	
}

