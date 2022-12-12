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
type StudyDocumentType_Controller struct {
	osbe.Base_Controller
}

func NewController_StudyDocumentType() *StudyDocumentType_Controller{
	c := &StudyDocumentType_Controller{osbe.Base_Controller{ID: "StudyDocumentType", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.StudyDocumentType_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &StudyDocumentType_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentType{})),
			EventList: osbe.PublicMethodEventList{"StudyDocumentType.insert"},
		},
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &StudyDocumentType_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"StudyDocumentType.delete"},
		},
	}
	
	//************************** method update *************************************
	c.PublicMethods["update"] = &StudyDocumentType_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentType_old_keys{})),
			EventList: osbe.PublicMethodEventList{"StudyDocumentType.update"},
		},
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &StudyDocumentType_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &StudyDocumentType_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
			
	
	return c
}

type StudyDocumentType_Controller_keys_argv struct {
	Argv models.StudyDocumentType_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type StudyDocumentType_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentType_Controller_insert) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentType_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}
func (pm *StudyDocumentType_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//modified
	return InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentType"], &models.StudyDocumentType_keys{}, sock.GetPresetFilter("StudyDocumentType"))	
}

//************************* DELETE **********************************************
type StudyDocumentType_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentType_Controller_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentType_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentType_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//modified
	return DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentType"], sock.GetPresetFilter("StudyDocumentType"))	
}

//************************* GET OBJECT **********************************************
type StudyDocumentType_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentType_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentType_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentType_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentType"], &models.StudyDocumentType{}, sock.GetPresetFilter("StudyDocumentType"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type StudyDocumentType_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentType_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentType_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentType"], &models.StudyDocumentType{}, sock.GetPresetFilter("StudyDocumentType"))	
}

//************************* UPDATE **********************************************
//Public method: update
type StudyDocumentType_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentType_Controller_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentType_old_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentType_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//modified
	return UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentType"], sock.GetPresetFilter("StudyDocumentType"))	
}
