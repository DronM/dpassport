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
	RESP_REG_ORG_EXISTS_CODE = 1000
	RESP_REG_ORG_EXISTS_DESCR = "Организация зарегистрирована"
	
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

//Method implemenation
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
		
		//organization exists
		resp.AddModelFromStruct(model.ModelID("ClientDialog_Model"), &client_row)
		//ret_error = osbe.NewPublicMethodError(RESP_REG_ORG_EXISTS_CODE, RESP_REG_ORG_EXISTS_DESCR)
		return nil
		
	}else if err != nil && err != pgx.ErrNoRows {
		//db server error
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register SELECT Scan(): %v",err))
	}
	
	//organization does not exists!
	search_res, err := searchClientByINN(app, conn, args.Inn.GetValue())
	if err != nil {
		//dadata error
		ret_error = err
		return err
	}
	
	field_ids := "name, inn"
	field_vals := make([]interface{}, 2)
	field_params := "$1, $2"
	field_param_cnt := 2
	
	data := search_res.Suggestions[0].Data
	if data.Name != nil && data.Name.Short != nil {
		field_vals[0] = *data.Name.Short
	}else{
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL,"Client_Controller_check_for_register org name is null")	
		return ret_error
	}	
	field_vals[1] = args.Inn.GetValue()
	
	if data.Name != nil && data.Name.Full_with_opf != nil {
		field_ids+= ",name_full"
		field_vals = append(field_vals, *data.Name.Full_with_opf)
		field_param_cnt++
		field_params+= fmt.Sprintf(", $%d", field_param_cnt)
	}
	
	/*if data.Management != nil && data.Management.Name != nil {
		field_ids+= ",manager_name"
		field_vals = append(field_vals, *data.Management.Name)
		field_param_cnt++
		field_params+= fmt.Sprintf(", $%d", field_param_cnt)
	}*/
	
	/*if data.Management != nil && data.Management.Post != nil {
		field_ids+= ",manager_post"
		field_vals = append(field_vals, *data.Management.Post)
		field_param_cnt++
		field_params+= fmt.Sprintf(", $%d", field_param_cnt)
	}*/
	if data.Kpp != nil {
		field_ids+= ",kpp"
		field_vals = append(field_vals, *data.Kpp)		
		field_param_cnt++
		field_params+= fmt.Sprintf(", $%d", field_param_cnt)
	}
	if data.Ogrn != nil {
		field_ids+= ",ogrn"
		field_vals = append(field_vals, *data.Ogrn)		
		field_param_cnt++
		field_params+= fmt.Sprintf(", $%d", field_param_cnt)
	}
	if data.Okpo != nil {
		field_ids+= ",okpo"
		field_vals = append(field_vals, *data.Okpo)		
	}
	if data.Okved != nil {
		field_ids+= ",okved"
		field_vals = append(field_vals, *data.Okved)		
	}
	/*if data.Okato != nil {
		field_ids+= ",okato"
		field_vals = append(field_vals, *data.Okato)		
		field_param_cnt++
		field_params+= fmt.Sprintf(", $%d", field_param_cnt)
	}*/
	if data.Address != nil && data.Address.Unrestricted_value != nil {
		field_ids+= ",legal_address"
		field_vals = append(field_vals, *data.Address.Unrestricted_value)		
		field_param_cnt++
		field_params+= fmt.Sprintf(", $%d", field_param_cnt)
	}
	var client_id int64
	if err := conn.QueryRow(context.Background(),
		fmt.Sprintf(`INSERT INTO clients (%s) VALUES (%s) RETURNING id`, field_ids, field_params),
		field_vals...).Scan(&client_id); err != nil {
	
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register INSERT conn.QueryRow(): %v",err))	
		return ret_error
	}
	
	if err := conn.QueryRow(context.Background(),
		fmt.Sprintf(`SELECT %s
		FROM clients_dialog
		WHERE id = $1`, client_ids),
		client_id).Scan(client_fields...); err != nil {
		
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register SELECT FROM clients_dialog conn.QueryRow(): %v",err))	
		return ret_error
	}	
	resp.AddModelFromStruct(model.ModelID("ClientDialog_Model"), &client_row)
	
	//new org registered!
	sock.GetSession().Set("REG_ORG_ID", client_id)
	if err := sock.GetSession().Flush(); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_check_for_register Session.Set(): %v",err))	
	}
	
	return nil
}

//************************* update_attrs **********************************************
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
fmt.Println(fmt.Sprintf(`UPDATE clients SET %s WHERE id = $%d`, field_params, field_param_cnt), field_param_vals)	
	if _, err := conn.Exec(context.Background(), 
		fmt.Sprintf(`UPDATE clients SET %s WHERE id = $%d`, field_params, field_param_cnt),
		field_param_vals...); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Client_Controller_update_attrs UPDATE: %v",err))
	}
	return nil
}
