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
	"osbe/model"
	
	//"github.com/jackc/pgx/v4"
)

//Controller
type MailTemplate_Controller struct {
	osbe.Base_Controller
}

func NewController_MailTemplate() *MailTemplate_Controller{
	c := &MailTemplate_Controller{osbe.Base_Controller{ID: "MailTemplate", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.MailTemplate_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &MailTemplate_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.MailTemplate{})),
			EventList: osbe.PublicMethodEventList{"MailTemplate.insert"},
		},
	}
	
	
	//************************** method update *************************************
	c.PublicMethods["update"] = &MailTemplate_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.MailTemplate_old_keys{})),
			EventList: osbe.PublicMethodEventList{"MailTemplate.update"},
		},
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &MailTemplate_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &MailTemplate_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
			
	
	return c
}

type MailTemplate_Controller_keys_argv struct {
	Argv models.MailTemplate_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type MailTemplate_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *MailTemplate_Controller_insert) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.MailTemplate_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}
func (pm *MailTemplate_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["MailTemplate"], &models.MailTemplate_keys{}, sock.GetPresetFilter("MailTemplate"))	
}


//************************* GET OBJECT **********************************************
type MailTemplate_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *MailTemplate_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.MailTemplate_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *MailTemplate_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["MailTemplate"], &models.MailTemplate{}, sock.GetPresetFilter("MailTemplate"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type MailTemplate_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *MailTemplate_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *MailTemplate_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["MailTemplateList"], &models.MailTemplateList{}, sock.GetPresetFilter("MailTemplateList"))	
}

//************************* UPDATE **********************************************
//Public method: update
type MailTemplate_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *MailTemplate_Controller_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.MailTemplate_old_keys_argv{}

	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *MailTemplate_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["MailTemplate"], sock.GetPresetFilter("MailTemplate"))	
}
