package controllers

/**
 * Andrey Mikhalevich 01/09/22
 */

import (
	"reflect"	
	
	"ds/pgds"
	"osbe"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
		
	//"github.com/jackc/pgx/v4"
)

//Controller
type Server1C_Controller struct {
	osbe.Base_Controller
}

func NewController_Server1C() *Server1C_Controller{
	c := &Server1C_Controller{osbe.Base_Controller{ID: "Server1C", PublicMethods: make(osbe.PublicMethodCollection)}}	
	
	//************************** method change_pay_check_interval *************************************
	c.PublicMethods["change_pay_check_interval"] = &Server1C_Controller_change_pay_check_interval{
		osbe.Base_PublicMethod{
			ID: "change_pay_check_interval",
		},
	}
	
	return c
}

//************************* change_pay_check_interval **********************************************
type Server1C_Controller_change_pay_check_interval struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *Server1C_Controller_change_pay_check_interval) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	return res, nil
}

//Method implemenation
func (pm *Server1C_Controller_change_pay_check_interval) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	app.GetLogger().Warn("Server1C_Controller_change_pay_check_interval")
	
	quitServer1C <- true	
	StartServer1C(app.GetDataStorage().(*pgds.PgProvider), app.GetLogger())
	
	return nil
}


