package controllers

/**
 * Добавлен метод logout вызывается из события Login.logout (из триггера)
 * находит сокет по параметру pub_key события и закрывает его
 */

import (
	"encoding/json"
	"reflect"
	"fmt"
	//"strings"
	
	"transport/models"
	
	"osbe"
	"osbe/srv"
	"osbe/evnt"
	"osbe/socket"
	"osbe/model"
	"osbe/fields"
	"osbe/response"	
	
	//"github.com/jackc/pgx/v4"
)

//Controller
type Login_Controller struct {
	osbe.Base_Controller
}

func NewController_Login() *Login_Controller{
	
	c := &Login_Controller{osbe.Base_Controller{ID: "Login", PublicMethods: make(osbe.PublicMethodCollection)}}

	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &Login_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}

	c.PublicMethods["logout"] = &Login_Controller_logout{
		osbe.Base_PublicMethod{
			ID: "logout",
			Fields: fields.GenModelMD(reflect.ValueOf(evnt.Event{})),
		},
	}
	
	return c
}

type Login_Controller_keys_argv struct {
	Argv models.Login_keys `json:"argv"`	
}




//************************* GET LIST **********************************************
//Public method: get_list
type Login_Controller_get_list struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *Login_Controller_get_list) Unmarshal(payload []byte) (res reflect.Value, err error) {

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
func (pm *Login_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["LoginList"], &models.LoginList{}, sock.GetPresetFilter("LoginList"))
}

//************************* logout **********************************************
//Public method: logout
type Login_Controller_logout struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *Login_Controller_logout) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &evnt.Event_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *Login_Controller_logout) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*evnt.Event)
	
	session_id_i, ok := args.Params["session_id"]
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "Login_Controller_logout session_id parameter is missing")
	}
	session_id, ok := session_id_i.(string)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "Login_Controller_logout session_id parameter is not a string")
	}
	
	//find socket on public key	
	ws_srv := app.GetServer("ws")
	if ws_srv == nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "Login_Controller_logout Application server with ID 'ws' not found")
	}

	//response with event model
	sock_resp := response.NewResponse("", app.GetMD().Version.Value)
	sock_resp.AddModelFromStruct(model.ModelID(evnt.EVNT_MODEL_ID), evnt.Event{Id: "User.logout"})
	resp_b, err := json.Marshal(sock_resp)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Login_Controller_logout json.marhsal(): %v", err))
	}
	sockets := ws_srv.GetClientSockets()
	for sock_item := range sockets.Iter() {			
		/*token := sock_item.Socket.GetToken()
		p := strings.Index(token,":")
		if p >=0 && session_id == token[:p] {
		*/
		if session_id == sock_item.GetToken() {
			app.GetLogger().Debugf("Found connection to close with token %s", session_id)
			
			if err := ws_srv.SendToClient(sock_item, resp_b); err != nil {
				app.GetLogger().Errorf("Login_Controller_logout ws_srv.SendToClient(): %v", err)
				continue
			}
			sock_item.GetDemandLogout()<- true
		}
	}
	
	return nil
}


