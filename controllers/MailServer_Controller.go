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
type MailServer_Controller struct {
	osbe.Base_Controller
}

func NewController_MailServer() *MailServer_Controller{
	c := &MailServer_Controller{osbe.Base_Controller{ID: "MailServer", PublicMethods: make(osbe.PublicMethodCollection)}}	
	
	//************************** method change_interval *************************************
	c.PublicMethods["change_interval"] = &MailServer_Controller_change_interval{
		osbe.Base_PublicMethod{
			ID: "change_interval",
		},
	}
	
	return c
}

//************************* change_interval **********************************************
type MailServer_Controller_change_interval struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *MailServer_Controller_change_interval) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	return res, nil
}

//Method implemenation
func (pm *MailServer_Controller_change_interval) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	app.GetLogger().Warn("MailServer_Controller_change_interval")
	
	quitMailReader <- true	
	StartMailSender(app.GetDataStorage().(*pgds.PgProvider), app.GetLogger(), app.GetBaseDir())
	
	return nil
}


