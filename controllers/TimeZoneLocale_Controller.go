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
	"osbe/model"
	"osbe/response"	
	
	//"github.com/jackc/pgx/v4"
)

//Controller
type TimeZoneLocale_Controller struct {
	osbe.Base_Controller
}

func NewController_TimeZoneLocale() *TimeZoneLocale_Controller{
	c := &TimeZoneLocale_Controller{osbe.Base_Controller{ID: "TimeZoneLocale", PublicMethods: make(osbe.PublicMethodCollection)}}
	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.TimeZoneLocale_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &TimeZoneLocale_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.TimeZoneLocale{})),
			EventList: osbe.PublicMethodEventList{"TimeZoneLocale.insert"},
		},				
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &TimeZoneLocale_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"TimeZoneLocale.delete"},
		},		
	}

	//************************** method update *************************************
	c.PublicMethods["update"] = &TimeZoneLocale_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.TimeZoneLocale_old_keys{})),
			EventList: osbe.PublicMethodEventList{"TimeZoneLocale.update"},
		},		
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &TimeZoneLocale_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}

	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &TimeZoneLocale_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},		
	}
	
	return c
}

//************************* INSERT **********************************************
//Public method: insert
type TimeZoneLocale_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *TimeZoneLocale_Controller_insert) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.TimeZoneLocale_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}

	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}
func (pm *TimeZoneLocale_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["TimeZoneLocale"], &models.TimeZoneLocale_keys{}, sock.GetPresetFilter("TimeZoneLocale"))
}

//************************* DELETE **********************************************
type TimeZoneLocale_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *TimeZoneLocale_Controller_delete) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.TimeZoneLocale_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *TimeZoneLocale_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["TimeZoneLocale"], sock.GetPresetFilter("TimeZoneLocale"))
}

//************************* GET OBJECT **********************************************
type TimeZoneLocale_Controller_get_object struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *TimeZoneLocale_Controller_get_object) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.TimeZoneLocale_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *TimeZoneLocale_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["TimeZoneLocale"], &models.TimeZoneLocale{}, sock.GetPresetFilter("TimeZoneLocale"))
}


//************************* GET LIST **********************************************
//Public method: get_list
type TimeZoneLocale_Controller_get_list struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *TimeZoneLocale_Controller_get_list) Unmarshal(payload []byte) (res reflect.Value, err error) {

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
func (pm *TimeZoneLocale_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["TimeZoneLocale"], &models.TimeZoneLocale{}, sock.GetPresetFilter("TimeZoneLocale"))
}

//************************* UPDATE **********************************************
//Public method: update
type TimeZoneLocale_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *TimeZoneLocale_Controller_update) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.TimeZoneLocale_old_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *TimeZoneLocale_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["TimeZoneLocale"], sock.GetPresetFilter("TimeZoneLocale"))
}

