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
type View_Controller struct {
	osbe.Base_Controller
}

func NewController_View() *View_Controller {
	c := &View_Controller{osbe.Base_Controller{ID: "View", PublicMethods: make(osbe.PublicMethodCollection)}}

	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &View_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},				
	}

	//************************** method complete *************************************
	c.PublicMethods["complete"] = &View_Controller_complete{
		osbe.Base_PublicMethod{
			ID: "complete",
			Fields: fields.GenModelMD(reflect.ValueOf(models.View_complete{})),
		},		
	}
	
	//************************** method get_section_list **********************************
	c.PublicMethods["get_section_list"] = &View_Controller_get_section_list{
		osbe.Base_PublicMethod{
			ID: "get_section_list",
			Fields: model.Cond_Model_fields,
		},		
	}
	
	return c	
}

//************************* GET LIST **********************************************
//Public method: get_list
type View_Controller_get_list struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *View_Controller_get_list) Unmarshal(payload []byte) (res reflect.Value, err error) {

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
func (pm *View_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["ViewList"], &models.ViewList{}, nil)
}

//********************************************************************************************
//Public method: complete
type View_Controller_complete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *View_Controller_complete) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.View_complete_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *View_Controller_complete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.CompleteOnArgs(app, resp, rfltArgs, app.GetMD().Models["ViewList"], &models.ViewList{}, nil)
}

//Custom method
type View_Controller_get_section_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *View_Controller_get_section_list) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.View_get_section_list_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *View_Controller_get_section_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return nil
}
