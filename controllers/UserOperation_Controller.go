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
	
	"dpassport/models"
	
	"osbe"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	
	
	//"github.com/jackc/pgx/v4"
)

//Controller
type UserOperation_Controller struct {
	osbe.Base_Controller
}

func NewController_UserOperation() *UserOperation_Controller{
	c := &UserOperation_Controller{osbe.Base_Controller{ID: "UserOperation", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.UserOperation_keys{}))
	
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &UserOperation_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"UserOperation.delete"},
		},
	}
	
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &UserOperation_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	
			
	
	return c
}

type UserOperation_Controller_keys_argv struct {
	Argv models.UserOperation_keys `json:"argv"`	
}


//************************* DELETE **********************************************
type UserOperation_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *UserOperation_Controller_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.UserOperation_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *UserOperation_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["UserOperation"], sock.GetPresetFilter("UserOperation"))	
}

//************************* GET OBJECT **********************************************
type UserOperation_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *UserOperation_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.UserOperation_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *UserOperation_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["UserOperationDialog"], &models.UserOperationDialog{}, sock.GetPresetFilter("UserOperationDialog"))	
}


