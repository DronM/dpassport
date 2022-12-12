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
	"context"
	"fmt"
	
	"dpassport/models"
	
	"ds/pgds"
	
	"osbe"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"	
	
	"github.com/jackc/pgx/v4/pgxpool"
	"github.com/jackc/pgx/v4"
)

//Controller
type LoginDevice_Controller struct {
	osbe.Base_Controller
}

func NewController_LoginDevice() *LoginDevice_Controller{
	c := &LoginDevice_Controller{osbe.Base_Controller{ID: "LoginDevice", PublicMethods: make(osbe.PublicMethodCollection)}}	
		
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &LoginDevice_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
	//************************** method switch_banned *************************************
	c.PublicMethods["switch_banned"] = &LoginDevice_Controller_switch_banned{
		osbe.Base_PublicMethod{
			ID: "switch_banned",
			Fields: fields.GenModelMD(reflect.ValueOf(models.LoginDevice_switch_banned{})),			
		},
	}
			
	
	return c
}





//************************* GET LIST **********************************************
//Public method: get_list
type LoginDevice_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *LoginDevice_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *LoginDevice_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["LoginDeviceList"], &models.LoginDeviceList{}, sock.GetPresetFilter("LoginDeviceList"))	
}

//************************* switch_banned **********************************************
//Public method: switch_banned
type LoginDevice_Controller_switch_banned struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *LoginDevice_Controller_switch_banned) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.LoginDevice_switch_banned_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *LoginDevice_Controller_switch_banned) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {

	args := rfltArgs.Interface().(*models.LoginDevice_switch_banned)
	
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_conn := d_store.GetPrimary()
	if err_conn != nil {
		return err_conn
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	if args.Banned.GetValue() {
		_, err := conn.Exec(context.Background(), "BEGIN")
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("LoginDevice_Controller_switch_banned pgx.Conn.Exec() BEGIN: %v",err))
		}	
		//DELETE FROM session_vals WHERE id IN
		var session_id fields.ValText
		if err := conn.QueryRow(context.Background(),
			`SELECT
				session_id
			FROM logins
			WHERE user_id = $1
			AND md5(login_devices_uniq(user_agent)) = $2
			AND date_time_out IS NULL
			ORDER BY date_time_in DESC
			LIMIT 1`,
			args.User_id.GetValue(), args.Hash.GetValue()).Scan(&session_id); err != nil && err != pgx.ErrNoRows {
			
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("LoginDevice_Controller_switch_banned pgx.Conn.QueryRow() SELECT session_id: %v",err))
			
		}else if err == nil {
			app.GetSessManager().SessionDestroy(session_id.GetValue())
		}
		_, err = conn.Exec(context.Background(),
			`INSERT INTO login_device_bans (user_id, hash) VALUES ($1, $2)`,
			args.User_id.GetValue(), args.Hash.GetValue())
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("LoginDevice_Controller_switch_banned pgx.Conn.Exec() INSERT login_device_bans: %v",err))
		}	
	
		_, err = conn.Exec(context.Background(), "COMMIT")
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("LoginDevice_Controller_switch_banned pgx.Conn.Exec() COMMIT: %v",err))
		}	
		//Send event!!!
		//deleted from logins after delete!!!
	
	}else{
		_, err := conn.Exec(context.Background(),
			"DELETE FROM login_device_bans WHERE user_id = $1 AND hash = $2",
			args.User_id.GetValue(), args.Hash.GetValue())
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("LoginDevice_Controller_switch_banned pgx.Conn.Exec() DELETE login_device_bans: %v",err))
		}	
	}
	
	return nil
}

