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
	"osbe/srv"
	"osbe/socket"
	"osbe/response"
	"osbe/fields"		
	
	//"github.com/jackc/pgx/v4"
)

//Controller
type Captcha_Controller struct {
	osbe.Base_Controller
}

func NewController_Captcha() *Captcha_Controller{
	c := &Captcha_Controller{osbe.Base_Controller{ID: "Captcha", PublicMethods: make(osbe.PublicMethodCollection)}}	

	//************************** method get *************************************
	c.PublicMethods["get"] = &Captcha_Controller_get{
		osbe.Base_PublicMethod{
			ID: "get",
			Fields: fields.GenModelMD(reflect.ValueOf(models.Captcha_get{})),
		},
	}
	
	return c
}

//************************* get **********************************************
//Public method: get
type Captcha_Controller_get struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *Captcha_Controller_get) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.Captcha_get_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return

}


//Method implemenation
func (pm *Captcha_Controller_get) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.Captcha_get)
	return addNewCaptcha(sock.GetSession(), app.GetLogger(), resp, args.Id.GetValue())
}	



