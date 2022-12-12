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
	"fmt"
	"context"
	
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

const (
	RESP_ER_REG_CAPTCHA_CODE = 1001
	RESP_ER_REG_CAPTCHA_DESCR = "Неверный код с картинки"
)

//Controller
type Client_Controller struct {
	osbe.Base_Controller
}

func NewController_Client() *Client_Controller{
	c := &Client_Controller{osbe.Base_Controller{ID: "Client", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.Client_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &Client_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.Client{})),
			EventList: osbe.PublicMethodEventList{"Client.insert"},
		},
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &Client_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"Client.delete"},
		},
	}
	
	//************************** method update *************************************
	c.PublicMethods["update"] = &Client_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.Client_old_keys{})),
			EventList: osbe.PublicMethodEventList{"Client.update"},
		},
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &Client_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &Client_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
	//************************** method complete *************************************
	c.PublicMethods["complete"] = &Client_Controller_complete{
		osbe.Base_PublicMethod{
			ID: "complete",
			Fields: fields.GenModelMD(reflect.ValueOf(models.Client_complete{})),
		},
	}
	
	//************************** method check_for_register *************************************
	c.PublicMethods["check_for_register"] = &Client_Controller_check_for_register{
		osbe.Base_PublicMethod{
			ID: "check_for_register",
			Fields: fields.GenModelMD(reflect.ValueOf(models.Client_check_for_register{})),
		},
	}
			
	//************************** method update_attrs *************************************
	c.PublicMethods["update_attrs"] = &Client_Controller_update_attrs{
		osbe.Base_PublicMethod{
			ID: "update_attrs",
			Fields: fields.GenModelMD(reflect.ValueOf(models.Client_update_attrs{})),
		},
	}

	//************************** method select_company *************************************
	c.PublicMethods["select_company"] = &Client_Controller_select_company{
		osbe.Base_PublicMethod{
			ID: "select_company",
			Fields: fields.GenModelMD(reflect.ValueOf(models.Client_select_company{})),
		},
	}
	
	//************************** method set_viewed *************************************
	c.PublicMethods["set_viewed"] = &Client_Controller_set_viewed{
		osbe.Base_PublicMethod{
			ID: "set_viewed",
			Fields: fields.GenModelMD(reflect.ValueOf(models.Client_set_viewed{})),
		},
	}
	
	return c
}

type Client_Controller_keys_argv struct {
	Argv models.Client_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type Client_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *Client_Controller_insert) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}
func (pm *Client_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["Client"], &models.Client_keys{}, sock.GetPresetFilter("Client"))	
}

//************************* DELETE **********************************************
type Client_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *Client_Controller_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *Client_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["Client"], sock.GetPresetFilter("Client"))	
}

//************************* GET OBJECT **********************************************
type Client_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *Client_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *Client_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["ClientDialog"], &models.ClientDialog{}, sock.GetPresetFilter("ClientDialog"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type Client_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *Client_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *Client_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["ClientList"], &models.ClientList{}, sock.GetPresetFilter("ClientList"))	
}

//************************* UPDATE **********************************************
//Public method: update
type Client_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *Client_Controller_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_old_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *Client_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["Client"], sock.GetPresetFilter("Client"))	
}
//************************** COMPLETE ********************************************************
//Public method: complete
type Client_Controller_complete struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *Client_Controller_complete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_complete_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *Client_Controller_complete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.CompleteOnArgs(app, resp, rfltArgs, app.GetMD().Models["ClientList"], &models.ClientList{}, sock.GetPresetFilter("ClientList"))	
}


//************************* check_for_register **********************************************
//Public method: check_for_register
type Client_Controller_check_for_register struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *Client_Controller_check_for_register) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_check_for_register_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

type clientExistsRow struct {
	Val bool `json:"val"`
}
	
//Method implemenation
//Возвращает:
//	ClientDialog_Model
//	Offer
//	ClientExists_Model
func (pm *Client_Controller_check_for_register) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	args := rfltArgs.Interface().(*models.Client_check_for_register)
	
	var ret_error error
	defer (func(){
		if ret_error != nil {
			addNewCaptcha(sock.GetSession(), app.GetLogger(), resp, ORG_CHECK_INN_CAPTCHA)
		}
	})()
	
	//captcha check
	if ok, err := CaptchaVerify(sock.GetSession(), app.GetLogger(), []byte(args.Captcha_key.GetValue()), ORG_CHECK_INN_CAPTCHA); !ok || err != nil {
		if err != nil {
			ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register CaptchaVerify(): %v",err))
		}else{
			ret_error = osbe.NewPublicMethodError(RESP_ER_REG_CAPTCHA_CODE, RESP_ER_REG_CAPTCHA_DESCR)
		}
		return ret_error
	}
	
	
	//check if org exists
	client_row := models.ClientDialog{}
	client_fields, client_ids, err := osbe.MakeStructRowFields(&client_row)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login osbe.MakeStructRowFields(): %v",err))
	}
	
	if err := conn.QueryRow(context.Background(),
		fmt.Sprintf(`SELECT %s
			FROM clients_dialog
			WHERE inn = $1`, client_ids),
		args.Inn.GetValue()).Scan(client_fields...); err == nil{
		
		//organization exists - done
		
		sock.GetSession().Set("REG_ORG_INN", args.Inn.GetValue())
		if err := sock.GetSession().Flush(); err != nil {
			ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register REG_ORG_INN Session.Set(): %v",err))	
			return ret_error
		}
		
		resp.AddModelFromStruct(model.ModelID("ClientDialog_Model"), &client_row)		
		resp.AddModelFromStruct(model.ModelID("ClientExists_Model"), &clientExistsRow{Val: true})
		
		//+access information
		client_acc_row := models.ClientAccess{}
		client_acc_fields, client_acc_ids, err := osbe.MakeStructRowFields(&client_acc_row)
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login osbe.MakeStructRowFields(ClientAccess): %v",err))
		}		
		if err := conn.QueryRow(context.Background(),
			fmt.Sprintf(`SELECT %s
				FROM client_accesses
				WHERE client_id = $1 AND date_to >= now()::date
				ORDER BY date_to DESC
				LIMIT 1`, client_acc_ids),
			client_row.Id,
			).Scan(client_acc_fields...); err != nil && err != pgx.ErrNoRows {
			
			ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register client_accesses: %v",err))	
			return ret_error		
			
		}else if err != pgx.ErrNoRows {
			resp.AddModelFromStruct(model.ModelID("ClientAccess_Model"), &client_acc_row)
		}
		
		return nil
		
	}else if err != nil && err != pgx.ErrNoRows {
		//db server error
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register SELECT Scan(): %v",err))
	}
	
	//**** +1c schet - async call
	//Это для теста!!!
	//go createSchet(app, client_row)
			
	if err := fillClientByINN(app, conn, args.Inn.GetValue(), &client_row); err != nil {
		ret_error = err
		return ret_error
	}
	//new organization
	resp.AddModelFromStruct(model.ModelID("ClientDialog_Model"), &client_row)	
	resp.AddModelFromStruct(model.ModelID("ClientExists_Model"), &clientExistsRow{Val: false})
	//+offer
	/*
	 * client_offer_params
	 *	name_full text,
    	 *	name text,
    	 *	inn text,
    	 *	kpp text,
    	 *	ogrn text	
	 */
	client_contract := struct {
		Text string `json:"text"`
	}{}
	if err := conn.QueryRow(context.Background(),
		`SELECT client_offer(ROW($1, $2, $3, $4, $5))`,
		client_row.Name_full,
		client_row.Name,
		client_row.Inn,
		client_row.Kpp,
		client_row.Ogrn,
		).Scan(&client_contract.Text); err != nil {
		
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register client_offer: %v",err))	
		return ret_error		
	}
	resp.AddModelFromStruct(model.ModelID("ClientContract_Model"), &client_contract)
	
	sock.GetSession().Set("REG_ORG_INN", args.Inn.GetValue())
	if err := sock.GetSession().Flush(); err != nil {
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register REG_ORG_INN Session.Set(): %v",err))	
		return ret_error
	}
		
	return nil
}

//************************* update_attrs **********************************************
//Сомнительный метод обновления атрибутов организации через форму регистрации
//Public method: update_attrs
type Client_Controller_update_attrs struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *Client_Controller_update_attrs) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_update_attrs_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *Client_Controller_update_attrs) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	
	client_id := sock.GetSession().GetInt("REG_ORG_ID")
	if client_id == 0 {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "Client_Controller_update_attrs client_id=0")	
	}
	
	field_param_vals := make([]interface{}, 0)
	field_params := ""
	field_param_cnt := 0
	
	args := rfltArgs.Interface().(*models.Client_update_attrs)
	if args.Name.GetIsSet() {
		if field_params != "" {
			field_params+= ","
		}
		field_param_vals = append(field_param_vals, args.Name.GetValue())
		field_param_cnt++
		field_params+= fmt.Sprintf("name = $%d", field_param_cnt)
	}
	if args.Name_full.GetIsSet() {
		if field_params != "" {
			field_params+= ","
		}
		field_param_vals = append(field_param_vals, args.Name_full.GetValue())
		field_param_cnt++
		field_params+= fmt.Sprintf("name_full = $%d", field_param_cnt)
	}
	if args.Ogrn.GetIsSet() {
		if field_params != "" {
			field_params+= ","
		}
		field_param_vals = append(field_param_vals, args.Ogrn.GetValue())
		field_param_cnt++
		field_params+= fmt.Sprintf("ogrn = $%d", field_param_cnt)
	}
	if args.Kpp.GetIsSet() {
		if field_params != "" {
			field_params+= ","
		}
		field_param_vals = append(field_param_vals, args.Kpp.GetValue())
		field_param_cnt++
		field_params+= fmt.Sprintf("kpp = $%d", field_param_cnt)
	}
	if args.Okved.GetIsSet() {
		if field_params != "" {
			field_params+= ","
		}
		field_param_vals = append(field_param_vals, args.Okved.GetValue())
		field_param_cnt++
		field_params+= fmt.Sprintf("okved = $%d", field_param_cnt)
	}
	if args.Legal_address.GetIsSet() {
		if field_params != "" {
			field_params+= ","
		}
		field_param_vals = append(field_param_vals, args.Legal_address.GetValue())
		field_param_cnt++
		field_params+= fmt.Sprintf("legal_address = $%d", field_param_cnt)
	}
	if args.Post_address.GetIsSet() {
		if field_params != "" {
			field_params+= ","
		}
		field_param_vals = append(field_param_vals, args.Post_address.GetValue())
		field_param_cnt++
		field_params+= fmt.Sprintf("post_address = $%d", field_param_cnt)
	}
	if field_params == "" {
		return nil
	}
	
	//update
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	field_param_vals = append(field_param_vals, client_id)
	field_param_cnt++
//fmt.Println(fmt.Sprintf(`UPDATE clients SET %s WHERE id = $%d`, field_params, field_param_cnt), field_param_vals)	
	if _, err := conn.Exec(context.Background(), 
		fmt.Sprintf(`UPDATE clients SET %s WHERE id = $%d`, field_params, field_param_cnt),
		field_param_vals...); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_update_attrs UPDATE: %v",err))
	}
	return nil
}

//************************* select_company **********************************************
//Public method: select_company
type Client_Controller_select_company struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *Client_Controller_select_company) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_select_company_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *Client_Controller_select_company) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.Client_select_company)

	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetSecondary("")
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	m := app.GetMD().Models["ClientList"]
	return osbe.AddQueryResult(resp, m, &models.ClientList{},
			fmt.Sprintf(`SELECT %s FROM clients_list WHERE parent_id = $1`, m.GetFieldList("")),
			"", []interface{}{args.Parent_id}, conn, false)	
}

//************************* set_viewed **********************************************
//Public method: set_seen
type Client_Controller_set_viewed struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *Client_Controller_set_viewed) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.Client_set_viewed_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}


func (pm *Client_Controller_set_viewed) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_set_viewed: %v", err))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	args := rfltArgs.Interface().(*models.Client_set_viewed)

	if _, err := conn.Exec(context.Background(),
		`UPDATE clients SET viewed = TRUE WHERE id = $1`,
		args.Client_id.GetValue()); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_set_viewed update: %v", err))
	}

	if _, err := conn.Exec(context.Background(),
		fmt.Sprintf(`SELECT pg_notify('Client.update'
			,json_build_object(
				'params',json_build_object('id', %d)
			)::text)`, args.Client_id.GetValue())); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_set_viewed pg_notify: %v", err))
	}

	return nil
}


