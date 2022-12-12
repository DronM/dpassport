package controllers

import (
	"fmt"
	"encoding/json"
	"reflect"
	"context"
	"strings"
	"strconv"
	"time"
	
	"dpassport/models"
	
	"ds/pgds"
	"osbe/sql"
	"osbe"	
	"osbe/fields"
	"osbe/srv"
	"osbe/srv/httpSrv"
	"osbe/socket"
	"osbe/model"
	"osbe/response"
	
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

const (
	PWD_LEN = 6
	DEF_PASSWORD = "123456"
	
	RESP_ER_AUTH_CODE = 1000
	RESP_ER_AUTH_DESCR = "Неверное имя пользователя или пароль"
	RESP_ER_BANNED_CODE = 1001
	RESP_ER_BANNED_DESCR = "Доступ запрещен"
	
	RESP_ER_EMAIL = 1002
	RESP_ER_EMAIL_DESCR = "Ошибка отправки email"

	RESP_ER_AUTH_TOKEN_CODE = 1003
	RESP_ER_AUTH_TOKEN_DESCR = "Неверный токен"
	
	ER_USER_NOT_DEFIND_DESCR = "Пользователь не определен";
	ER_USER_NOT_DEFIND_CODE = 1004
	
	RESP_ER_BANNED_DEV_CODE = 1005
	RESP_ER_BANNED_DEV_DESCR = "Доступ с устройства запрещен"

	RESP_ER_OTHER_USER_DATA_CODE = 1006
	RESP_ER_OTHER_USER_DATA_DESCR = "Запрещено изменять чужие данные"
	
	RESP_ER_NO_EMAIL_CODE = 1007
	RESP_ER_NO_EMAIL_DESCR = "Адрес электронной почты не найден"
	
	RESP_ER_CAPTCHA_CODE = 1008
	RESP_ER_CAPTCHA_DESCR = "Неверный код"

	//Администратор1 при входе с неоплаченной услугой площадки
	RESP_ER_CLIENT_BANNED_CODE = 1009
	RESP_ER_CLIENT_BANNED_DESCR = "Доступ для площадки запрещен"

	RESP_ER_USER_EXISTS_CODE = 1010
	RESP_ER_USER_EXISTS_DESCR = "Пользователь с таким адресом электронной почты или СНИЛС уже зарегистрирован"
	
	SESS_VAR_TEL = "USER_TEL"
	SESS_VAR_NAME = "USER_NAME"
	SESS_VAR_DESCR = "USER_DESCR"
	SESS_VAR_ID = "USER_ID"
	SESS_VAR_COMPANY_ID = "USER_COMPANY_ID"
	SESS_VAR_COMPANY_DESCR = "USER_COMPANY_DESCR"
	SESS_VAR_WIDTH_TYPE = "WIDTH_TYPE"
	SESS_VAR_LOGIN_ID = "USER_LOGIN_ID"
	SESS_VAR_LOGGED = "LOGGED"
	SESS_VAR_PERSON_URL = "PERSON_URL"
)

//Controller
type User_Controller struct {
	osbe.Base_Controller
}

func NewController_User() *User_Controller{
	c := &User_Controller{osbe.Base_Controller{ID: "User", PublicMethods: make(osbe.PublicMethodCollection)}}
	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.User_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &User_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User{})),
			EventList: osbe.PublicMethodEventList{"User.insert"},
		},				
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &User_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"User.delete"},
		},		
	}

	//************************** method update *************************************
	c.PublicMethods["update"] = &User_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_old_keys{})),
			EventList: osbe.PublicMethodEventList{"User.update"},
		},		
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &User_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}

	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &User_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},		
	}

	//************************** method get_excel_file *************************************
	c.PublicMethods["get_excel_file"] = &User_Controller_get_excel_file{
		osbe.Base_PublicMethod{
			ID: "get_excel_file",
			Fields: model.Cond_Model_fields,
		},
	}

	//************************** method reset_pwd *************************************
	c.PublicMethods["reset_pwd"] = &User_Controller_reset_pwd{
		osbe.Base_PublicMethod{
			ID: "reset_pwd",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_reset_pwd{})),
		},		
	}

	//************************** method login *************************************
	c.PublicMethods["login"] = &User_Controller_login{
		osbe.Base_PublicMethod{
			ID: "login",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_login{})),
		},		
	}

	//************************** method login_token *************************************
	c.PublicMethods["login_token"] = &User_Controller_login_token{
		osbe.Base_PublicMethod{
			ID: "login_token",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_login_token{})),
		},		
	}

	//************************** method logout *************************************
	c.PublicMethods["logout"] = &User_Controller_logout{
		osbe.Base_PublicMethod{
			ID: "logout",
		},		
	}
	
	//************************** method get_profile *************************************
	c.PublicMethods["get_profile"] = &User_Controller_get_profile{
		osbe.Base_PublicMethod{
			ID: "get_profile",
		},		
	}
	
	//************************** method complete *************************************
	c.PublicMethods["complete"] = &User_Controller_complete{
		osbe.Base_PublicMethod{
			ID: "complete",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_complete{})),
		},		
	}
	
	//************************** method delete_photo *************************************
	c.PublicMethods["delete_photo"] = &User_Controller_delete_photo{
		osbe.Base_PublicMethod{
			ID: "delete_photo",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_delete_photo{})),
		},		
	}

	//************************** method password_recover *************************************
	c.PublicMethods["password_recover"] = &User_Controller_password_recover{
		osbe.Base_PublicMethod{
			ID: "password_recover",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_password_recover{})),
		},		
	}

	//************************** method register *************************************
	c.PublicMethods["register"] = &User_Controller_register{
		osbe.Base_PublicMethod{
			ID: "register",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_register{})),
			EventList: osbe.PublicMethodEventList{"Client.insert"},
		},		
	}
	
	//************************** method set_viewed *************************************
	c.PublicMethods["set_viewed"] = &User_Controller_set_viewed{
		osbe.Base_PublicMethod{
			ID: "set_viewed",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_set_viewed{})),
		},
	}
			
	//************************** method gen_qrcode *************************************
	c.PublicMethods["gen_qrcode"] = &User_Controller_gen_qrcode{
		osbe.Base_PublicMethod{
			ID: "gen_qrcode",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_gen_qrcode{})),
		},
	}
	//************************** method send_qrcode_email *************************************
	c.PublicMethods["send_qrcode_email"] = &User_Controller_send_qrcode_email{
		osbe.Base_PublicMethod{
			ID: "send_qrcode_email",
			Fields: fields.GenModelMD(reflect.ValueOf(models.User_send_qrcode_email{})),
		},
	}
	
	return c
}

//**************************************************************************************
//Public method: insert
type User_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *User_Controller_insert) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}

	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//custom method
func (pm *User_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.User)

	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn	
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	
	//photo upload
	http_sock, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "User_Controller_update: not HTTPSocket type")
	}	
	data, _, err := http_sock.GetUploadedFileData("photo[]")
	if err == nil {
		args.Photo.SetValue(data)
	}	
	
	//2) custom
	pwd := DEF_PASSWORD//genUniqID(PWD_LEN)
	hash := GetMd5(pwd)
	args.Pwd.SetValue(hash)
	
	//Назначение роли: Если заводит Админ1 - то роль нового - админ2
	sess := sock.GetSession()
	role_id := sess.GetString(osbe.SESS_ROLE)
	if role_id == "client_admin1" {
		args.Role_id.SetValue("client_admin2")
		company_id := sess.GetInt(SESS_VAR_COMPANY_ID)
		args.Company_id.SetValue(company_id)
		//Площадка должна принаждлежать Админ1
		/*
		if !args.Company_id.GetIsSet() || args.Company_id.GetIsNull(){
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "User_Controller_insert company_id is set")
			
		}else if company_id != args.Company_id.GetValue() {
			//check...
			belongs := false
			if err = conn.QueryRow(context.Background(),
				fmt.Sprintf("SELECT %d IN (SELECT t.id FROM clients t WHERE t.parent_id = %d) AS belongs",
				company_id, company_id),
				).Scan(&belongs); err != nil {
				
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_insert company check: %v",err))
			}
			if !belongs {	
				return osbe.NewPublicMethodError(RESP_ER_OTHER_USER_DATA_CODE, RESP_ER_OTHER_USER_DATA_DESCR)			
			}
		}
		*/
	}
	
	//QR
	/*
	user_url := QRPersonURL()
	args.Person_url.SetValue(user_url)
	if qr, err := QROnUserURL(app, conn, user_url); err != nil {
		return err
	}else {
		args.Qr_code.SetValue(qr)
	}	
	*/
	
	field_ids, field_args, field_values := osbe.ArgsToInsertParams(rfltArgs, nil, "")		
	
	//1) begin transaction
	_, err = conn.Exec(context.Background(), "BEGIN")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_insert BEGIN: %v",err))
	}
			
	q := fmt.Sprintf("INSERT INTO users (%s) VALUES (%s) RETURNING id", field_ids, field_args)
	row := &models.User_keys{}
	if err := conn.QueryRow(context.Background(), q, field_values...).Scan(&row.Id); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("pgx.Conn.QueryRow.Scan(&row.Id): %v",err))
	}
	resp.AddModel(model.New_InsertedKey_Model(row))
	
	if err := sendEmailNewPwd(conn, row.Id.GetValue(), pwd); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		return osbe.NewPublicMethodError(RESP_ER_EMAIL, fmt.Sprintf("sendEmailNewPwd(): %v",err))
	}
	
	//events
	params := make(map[string]interface{})
	params["emitterId"] = sock.GetToken()
	app.PublishPublicMethodEvents(pm, params)
	
	//3) action
	keys := make(map[string]interface{})
	keys["id"] = row.Id.GetValue()
	if err := addAction(conn, sock, app.GetMD().Models["User"], "insert", keys); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		return err
	}

	//4) commit
	_, err = conn.Exec(context.Background(), "COMMIT")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_insert COMMIT: %v",err))
	}
	
	return nil
}

//**************************************************************************************
//Public method: delete
type User_Controller_delete struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_delete) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//modified
	return DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["User"], sock.GetPresetFilter("User"))
}


//Public method: get_object
type User_Controller_get_object struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_get_object) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["UserDialog"], &models.UserDialog{}, sock.GetPresetFilter("UserDialog"))
}

//**************************************************************************************
//Public method: get_list
type User_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_get_list) Unmarshal(payload []byte) (res reflect.Value, err error) {

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
func (pm *User_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//custom filter
	f := sock.GetPresetFilter("UserList")	
	if ids := osbe.GetTextArgValByName(rfltArgs, "Cond_fields", ""); ids != "" {
		vals := osbe.GetTextArgValByName(rfltArgs, "Cond_vals", "")
		ics := osbe.GetTextArgValByName(rfltArgs, "Cond_ic", "")
		sgns := osbe.GetTextArgValByName(rfltArgs, "Cond_sgns", "")
		
		f_sep := osbe.ArgsFieldSep(rfltArgs)
		vals_s := strings.Split(vals, f_sep)		
		fields_s := strings.Split(ids, f_sep)
		sgns_s := strings.Split(sgns, f_sep)
		ic_s := strings.Split(ics, f_sep)
		
		if len(vals_s)!= len(fields_s) {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "User_Controller_get_list: len(vals_s)!= len(fields_s)")
		}
		
		for ind, f_id := range fields_s {
			if f_id == "organization" {
				org_id, err := strconv.Atoi(vals_s[ind])
				if err != nil {
					return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "User_Controller_get_list: organization strconv.Itoa()")
				}
				f = append(f,
					&sql.FilterCond{Expression: fmt.Sprintf("company_id = %d OR client_id = %d",
					org_id, org_id),
				})
				//remove
				fields_s = append(fields_s[:ind], fields_s[ind+1:]...)
				sgns_s = append(sgns_s[:ind], sgns_s[ind+1:]...)
				ic_s = append(ic_s[:ind], ic_s[ind+1:]...)
			}
		}
		args := rfltArgs.Interface().(*model.Cond_Model)
		args.Cond_fields.SetValue(strings.Join(fields_s, f_sep))
		args.Cond_sgns.SetValue(strings.Join(sgns_s, f_sep))
		args.Cond_ic.SetValue(strings.Join(ic_s, f_sep))
		
	}
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["UserList"], &models.UserList{}, f)
}

//**************************************************************************************
//Public method: update
type User_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_update) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_old_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	
	args := rfltArgs.Interface().(*models.User_old_keys)
	
	sess := sock.GetSession()
	if sess.GetInt(SESS_VAR_ID)!= args.Old_id.GetValue() {
		//other user data!
		role_id := sess.GetString(osbe.SESS_ROLE)
		if role_id == "person" {
			//self data only!
			return osbe.NewPublicMethodError(RESP_ER_OTHER_USER_DATA_CODE, RESP_ER_OTHER_USER_DATA_DESCR)
			
		}else if (role_id == "client_admin1" || role_id == "client_admin2") {
			//there users only, same client
			
			var company_id int64		
			if !args.Company_id.GetIsSet() {
				//read from db
				d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
				var conn_id pgds.ServerID
				var pool_conn *pgxpool.Conn	
				pool_conn, conn_id, err := d_store.GetSecondary("")
				if err != nil {
					return err
				}
				conn := pool_conn.Conn()				
				if err := conn.QueryRow(context.Background(),
					`SELECT
						coalesce(cl.parent_id, cl.id)
					FROM users AS u
					LEFT JOIN clients AS cl ON cl.id = u.company_id
					WHERE u.id = $1`,
						args.Old_id.GetValue()).Scan(&company_id); err != nil {
					d_store.Release(pool_conn, conn_id)
					return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("SELECT company_id FROM users pgx.Conn.QueryRow(): %v",err))
				}
				d_store.Release(pool_conn, conn_id)
				
			}else{
				company_id = args.Company_id.GetValue()
			}
			if company_id != sess.GetInt(SESS_VAR_COMPANY_ID) {
				return osbe.NewPublicMethodError(RESP_ER_OTHER_USER_DATA_CODE, RESP_ER_OTHER_USER_DATA_DESCR)
			}
		}
	}
		
	//photo upload
	http_sock, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "User_Controller_update: not HTTPSocket type")
	}	

	//uploaded file
	data, _, err := http_sock.GetUploadedFileData("photo[]")
	if err == nil {		
		args.Photo.SetValue(data)
	}
		
	return UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["User"], sock.GetPresetFilter("User"))
}

//Public method: reset_pwd
type User_Controller_reset_pwd struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_reset_pwd) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_reset_pwd_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_reset_pwd) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
		
	//custom
	pwd := genUniqID(PWD_LEN)
	hash := GetMd5(pwd)
	if hash == "" {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "Ошибка генерации пароля")
	}	
	args := rfltArgs.Interface().(*models.User_reset_pwd)
	
	if _, err := conn.Prepare(context.Background(),
		USER_RESET_PWD_Q,
		"UPDATE users SET pwd = $1 WHERE id = $2"); err != nil {
				
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_reset_pwd USER_RESET_PWD_Q pgx.Conn.Prepare(): %v",err))
	}
	
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_reset_pwd BEGIN: %v",err))
	}
		
	if _, err := conn.Exec(context.Background(), USER_RESET_PWD_Q, hash, args.User_id); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_reset_pwd USER_RESET_PWD_Q pgx.Conn.Exec(): %v",err))
	}
	
	if err := sendEmailResetPwd(conn, args.User_id.GetValue(), pwd); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		return osbe.NewPublicMethodError(RESP_ER_EMAIL, fmt.Sprintf("User_Controller_reset_pwd sendEmailResetPwd(): %v",err))
	}
	
	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_reset_pwd COMMIT: %v",err))
	}
	
	return nil
}

//Public method: login
type User_Controller_login struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_login) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_login_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_login) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
				
	user_row := models.UserLogin{}
	user_fields, user_ids, err := osbe.MakeStructRowFields(&user_row)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login osbe.MakeStructRowFields(): %v",err))
	}
	if _, err := conn.Prepare(context.Background(),
			USER_LOGIN_Q,
			fmt.Sprintf("SELECT %s FROM users_login WHERE name = $1 AND pwd = md5($2)", user_ids) ); err != nil {
			
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login USER_LOGIN_Q conn.Prepare(): %v",err))	
	}
	
	args := rfltArgs.Interface().(*models.User_login)
	
	err = conn.QueryRow(context.Background(), USER_LOGIN_Q, args.Name.GetValue(), args.Pwd.GetValue()).Scan(user_fields...)	
	if err == pgx.ErrNoRows {
		return osbe.NewPublicMethodError(RESP_ER_AUTH_CODE, RESP_ER_AUTH_DESCR)	
		
	}else if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login USER_LOGIN_Q conn.QueryRow(): %v",err))	
	}
	
	if user_row.Client_banned.GetValue() {
		return osbe.NewPublicMethodError(RESP_ER_CLIENT_BANNED_CODE, RESP_ER_CLIENT_BANNED_DESCR)			
	}
	
	pub_key, err := doLoginUser(app, sock, conn, &user_row, args.Width_type.GetValue())
	if err != nil {
		return err
	}
		
	//return auth
	/*token := fmt.Sprintf("%s:%s", pub_key, GetMd5(pub_key + sess_id))
	token_r:= fmt.Sprintf("%s:%s", pub_key, GetMd5(pub_key + user_row.Pwd + strconv.FormatInt(user_row.Id.GetValue(), 10))) 
	resp.AddModel(models.NewAuth_Model(token, token_r, sock.GetTokenExpires()))
	*/
	addAuthModel(resp, pub_key, sock.GetSession().SessionID(), user_row.Pwd.GetValue(), user_row.Id.GetValue(), sock.GetTokenExpires())
	
	return nil
}

func addAuthModel(resp *response.Response, pubKey, sessID, pwdHash string, userId int64, exp time.Time) {
	//return auth
	//token := fmt.Sprintf("%s:%s", pubKey, GetMd5(pubKey + sessID))
	//token_r:= fmt.Sprintf("%s:%s", pubKey, GetMd5(pubKey + pwdHash + strconv.FormatInt(userId, 10))) 
	
	resp.AddModel(models.NewAuth_Model(sessID, sessID, exp))
}

//Public method: logout
type User_Controller_logout struct {
	osbe.Base_PublicMethod
}
func (pm *User_Controller_logout) Unmarshal(payload []byte) (res reflect.Value, err error) {
	return
}

//Method implemenation
func (pm *User_Controller_logout) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {

	sess := sock.GetSession()	
	login_id := sess.GetInt("USER_LOGIN_ID")
	if login_id == 0 {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "login_id=0")
	}
	man := app.GetSessManager()
	man.SessionDestroy(sess.SessionID())

	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	if _, err := conn.Prepare(context.Background(),
		USER_LOGIN_CLOSE_Q,
		`UPDATE logins
		SET date_time_out = now()
		WHERE id=$1`); err != nil {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("USER_LOGIN_CLOSE_Q pgx.Prepare(): %v",err))	
	}


	if _, err = conn.Exec(context.Background(), USER_LOGIN_CLOSE_Q, login_id); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("USER_LOGIN_CLOSE_Q pgx.Exec(): %v",err))	
	}		
	return nil
}

func sendEmailNewPwd(conn *pgx.Conn, id int64, pwd string) error {
	//_, err := conn.Exec(context.Background(), "SELECT email_user_new_account($1, $2)", id, pwd)
	//return err
	return nil
}

func sendEmailResetPwd(conn *pgx.Conn, userID int64, newPwd string) error {
	return RegisterMailFromSQL(conn, "mail_password_recover", nil, []interface{}{userID, newPwd})
}

func sendEmailEmailConf(conn *pgx.Conn, id int64, key string) error {
	//_, err := conn.Exec(context.Background(), "SELECT email_user_email_conf($1, $2)", id, key)
	//return err
	return nil
}

//Public method: login_token
type User_Controller_login_token struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *User_Controller_login_token) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_login_token_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_login_token) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.User_login_token)
	token := args.Token.GetValue()
	pub_key_p := strings.Index(token, ":")
	if pub_key_p < 0 {
		return osbe.NewPublicMethodError(RESP_ER_AUTH_TOKEN_CODE, RESP_ER_AUTH_TOKEN_DESCR)
	}
	
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetSecondary("")
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	pub_key := token[:pub_key_p]

	session_id := ""
	pwd_hash := ""
	user_id := 0
	user_row := &models.UserDialog{}
	if _, err := conn.Prepare(context.Background(),
		USER_LOGIN_TOKEN_Q,
			`SELECT
				trim(l.session_id) AS session_id,
				u.pwd,
				u.id,
				ud.id,
				ud.name,
				ud.name_full,
				ud.post,
				ud.role_id,
				ud.phone_cel,
				ud.banned,
				ud.locale_id,
				ud.time_zone_locales_ref
				
			FROM logins l
			LEFT JOIN users_dialog AS ud ON ud.id = l.user_id
			LEFT JOIN users AS u ON u.id = l.user_id
			WHERE l.date_time_out IS NULL AND l.pub_key=$1`); err != nil {
			
		return osbe.NewPublicMethodError(RESP_ER_AUTH_TOKEN_CODE, fmt.Sprintf("USER_LOGIN_TOKEN_Q pgx.Conn.Prepare(): %v", err))
	}
	
	err = conn.QueryRow(context.Background(), USER_LOGIN_TOKEN_Q, pub_key).Scan(&session_id,
				&pwd_hash, &user_id,
				&user_row.Id,
				&user_row.Name,
				&user_row.Name_full,
				&user_row.Post,
				&user_row.Role_id,
				&user_row.Phone_cel,
				&user_row.Banned,
				&user_row.Locale_id,
				&user_row.Time_zone_locales_ref)
			
	if err == pgx.ErrNoRows {
		return osbe.NewPublicMethodError(RESP_ER_AUTH_TOKEN_CODE, RESP_ER_AUTH_TOKEN_DESCR)
	
	}else if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("USER_LOGIN_TOKEN_Q pgx.Rows.Scan(): %v",err))	
	}
	
	if token[pub_key_p+1:] != GetMd5(pub_key + session_id) {
		return osbe.NewPublicMethodError(RESP_ER_AUTH_TOKEN_CODE, RESP_ER_AUTH_TOKEN_DESCR)
	}
	
	sess := sock.GetSession()
	man := app.GetSessManager()
	man.SessionDestroy(sess.SessionID())
	man.SessionStart(session_id)
	
	//return user profile
	m := &model.Model{ID: "UserDialog"}
	m.Rows = make([]model.ModelRow, 1)		
	m.Rows[0] = user_row
	resp.AddModel(m)
	
	//return auth
	token_r:= fmt.Sprintf("%s:%s", pub_key, GetMd5(pub_key + pwd_hash + strconv.Itoa(user_id)) ) 
	resp.AddModel(models.NewAuth_Model(pub_key+":"+token[pub_key_p+1:], token_r, sock.GetTokenExpires()))
	
	return nil
}

//**************************************************************************************
//Public method: get_excel_file
type User_Controller_get_excel_file struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_get_excel_file) Unmarshal(payload []byte) (res reflect.Value, err error) {

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
func (pm *User_Controller_get_excel_file) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//return osbe.GetExcelFileOnArgs(app, resp, rfltArgs, models.User_md, &models.User{}, "Пользователи.xsl", sock.GetPresetFilter("User"))
	return nil
}

//********************************************************************************************
//Public method: get_profile
type User_Controller_get_profile struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *User_Controller_get_profile) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_get_profile) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//current logged user
	sess := sock.GetSession()
	if !sess.GetBool("LOGGED") {
		return osbe.NewPublicMethodError(RESP_ER_AUTH_CODE, RESP_ER_AUTH_DESCR)	
	}
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetSecondary("")
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
		
	cond := make([]interface{}, 1)
	cond[0] = sess.GetInt("USER_ID")
	f_list := app.GetMD().Models["UserProfile"].GetFieldList("")
	return osbe.AddQueryResult(resp,  app.GetMD().Models["UserProfile"], &models.UserProfile{}, fmt.Sprintf("SELECT %s FROM users_profile WHERE id=$1",f_list), "", cond, conn, false)
}

//********************************************************************************************
//Public method: complete
type User_Controller_complete struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_complete) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_complete_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_complete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.CompleteOnArgs(app, resp, rfltArgs, app.GetMD().Models["UserList"], &models.UserList{}, sock.GetPresetFilter("UserList"))
}

//
//Public method: delete_photo
type User_Controller_delete_photo struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *User_Controller_delete_photo) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_delete_photo_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_delete_photo) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.User_delete_photo)

	sess := sock.GetSession()
	role := sess.GetString(osbe.SESS_ROLE)
	user_id := sess.GetInt(SESS_VAR_ID)
	if role != "admin" && user_id != args.User_id.GetValue() {
		//only self data is allowed!
		return osbe.NewPublicMethodError(RESP_ER_OTHER_USER_DATA_CODE, RESP_ER_OTHER_USER_DATA_DESCR)
	}

	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn	
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	if _, err := conn.Exec(context.Background(),
		`UPDATE users
		SET photo = null
		WHERE id = $1`, args.User_id); err != nil {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_delete_photo pgx.Conn.Exec(): %v",err))
	}
	return nil
}

//Public method: password_recover
type User_Controller_password_recover struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *User_Controller_password_recover) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_password_recover_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_password_recover) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.User_password_recover)

	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn	
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	var ret_error error
	defer (func(){
		if ret_error != nil {
			addNewCaptcha(sock.GetSession(), app.GetLogger(), resp, USER_PWD_RECOVERY_CAPTCHA)
		}
	})()

	//captcha check
	if ok, err := CaptchaVerify(sock.GetSession(), app.GetLogger(), []byte(args.Captcha_key.GetValue()), USER_PWD_RECOVERY_CAPTCHA); !ok || err != nil {
		if err != nil {
			ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_password_recover CaptchaVerify(): %v",err))
		}else{
			ret_error = osbe.NewPublicMethodError(RESP_ER_CAPTCHA_CODE, RESP_ER_CAPTCHA_DESCR)
		}
		return ret_error
	}
	
	var user_id int64
	err = conn.QueryRow(context.Background(),
		`SELECT id FROM users WHERE name = $1`,
		args.Email.GetValue(),
		).Scan(&user_id)
		
	if err != nil && err == pgx.ErrNoRows {
		//email does not exist
		
		ret_error = osbe.NewPublicMethodError(RESP_ER_NO_EMAIL_CODE, RESP_ER_NO_EMAIL_DESCR)
		return ret_error
	
	}else if err != nil {
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_password_recover pgx.Conn.QueryRow(): %v",err))
		return ret_error
	}
	
	new_pwd := DEF_PASSWORD
	
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_password_recover BEGIN: %v",err))
		return ret_error
	}
	
	if _, err := conn.Exec(context.Background(),
		"UPDATE users SET pwd = $1 WHERE id = $2",
		GetMd5(new_pwd), user_id); err != nil {
		
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_password_recover UPDATE users: %v",err))
		return ret_error
	}	
	
	if err := RegisterMailFromSQL(conn, "mail_password_recover", nil, []interface{}{user_id, new_pwd}); err != nil {
		if _, err := conn.Exec(context.Background(), "ROLLBACK"); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_password_recover ROLLBACK: %v",err))
		}
	
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_password_recover RegisterMail(): %v",err))
		return ret_error
	}
	
	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_password_recover COMMIT: %v",err))
		return ret_error
	}
	
	return nil
}

//***************************
//Public method: register
type User_Controller_register struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *User_Controller_register) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.User_register_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *User_Controller_register) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.User_register)

	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn	
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	var ret_error error
	defer (func(){
		if ret_error != nil {
			addNewCaptcha(sock.GetSession(), app.GetLogger(), resp, USER_REGISTER_CAPTCHA)
		}
	})()

	//captcha check
	if ok, err := CaptchaVerify(sock.GetSession(), app.GetLogger(), []byte(args.Captcha_key.GetValue()), USER_REGISTER_CAPTCHA); !ok || err != nil {
		if err != nil {
			ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register CaptchaVerify(): %v",err))
		}else{
			ret_error = osbe.NewPublicMethodError(RESP_ER_CAPTCHA_CODE, RESP_ER_CAPTCHA_DESCR)
		}
		return ret_error
	}
	
	org_inn := sock.GetSession().GetString("REG_ORG_INN")
	if org_inn == "" {
		ret_error = osbe.NewPublicMethodError(RESP_ER_CAPTCHA_CODE, RESP_ER_CAPTCHA_DESCR)
		return ret_error
	}

	//Check SNILS, name
	user_exists := false
	if err := conn.QueryRow(context.Background(),
		`SELECT TRUE FROM users WHERE name = $1 OR snils = $2`,
		args.Name.GetValue(), args.Snils.GetValue()).Scan(&user_exists); err != nil && err != pgx.ErrNoRows {
		
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register SELECT TRUE FROM users: %v",err))
		return ret_error
		
	}else if err == nil && user_exists {
		ret_error = osbe.NewPublicMethodError(RESP_ER_USER_EXISTS_CODE, RESP_ER_USER_EXISTS_DESCR)
		return ret_error
	} 

	//Transaction begin
	if _, err := conn.Exec(context.Background(), "BEGIN"); err != nil {		
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register BEGIN conn.Exec(): %v",err))
		return ret_error
	}	
			
	//найдем клиента еще раз в dadata(cache) searchClient.go
	client_row := models.ClientDialog{}
	if err := fillClientByINN(app, conn, args.Inn.GetValue(), &client_row); err != nil {
		ret_error = err
		return ret_error
	}
	
	var client_id int64
	//checking
	if err := conn.QueryRow(context.Background(),
		`SELECT id FROM clients WHERE (inn = $1 OR ogrn = $2) AND (parent_id IS NULL OR parent_id = id)`,
		client_row.Inn.GetValue(), client_row.Ogrn.GetValue()).Scan(&client_id); err != nil && err != pgx.ErrNoRows {
		
		conn.Exec(context.Background(), "ROLLBACK")
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register SELECT id FROM clients: %v",err))
		return ret_error
		
	}else if err != nil && err == pgx.ErrNoRows {
		//new client
		if err := conn.QueryRow(context.Background(),
			`INSERT INTO clients
			(name, name_full, ogrn, inn, kpp, post_address, legal_address, okpo, okved, viewed)
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, FALSE)
			RETURNING id`,
			client_row.Name.GetValue(),
			client_row.Name_full.GetValue(),
			client_row.Ogrn.GetValue(),
			client_row.Inn.GetValue(),
			client_row.Kpp.GetValue(),
			client_row.Post_address.GetValue(),
			client_row.Legal_address.GetValue(),
			client_row.Okpo.GetValue(),
			client_row.Okved.GetValue(),
			).Scan(&client_id); err != nil {		
			
			conn.Exec(context.Background(), "ROLLBACK")
			ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register INSERT INTO clients: %v",err))
			return ret_error
		}
		
		//+action
		keys := make(map[string]interface{})
		keys["id"] = client_id
		if err := addAction(conn, sock, app.GetMD().Models["Client"], "insert", keys); err != nil {			
			conn.Exec(context.Background(), "ROLLBACK")
			ret_error = err
			return ret_error
		}
		
		//+event
		PublishEventsWithKeys(sock, keys, app, pm, osbe.GetDbLsn(conn), "Client")
	}
	
	//New user
	var user_id int64
	new_pwd := DEF_PASSWORD
	if err := conn.QueryRow(context.Background(),
		`INSERT INTO users
		(name, name_full, sex, post, snils, role_id, create_dt, banned, company_id, pwd, viewed)
		VALUES ($1, $2, $3, $4, $5, 'client_admin1', now(), TRUE, $6, md5($7), FALSE)
		RETURNING id`,
		args.Name,
		args.Name_full,
		args.Sex,
		args.Post,
		args.Snils,
		client_id,
		new_pwd,
		).Scan(&user_id); err != nil {		

		if _, err := conn.Exec(context.Background(), "ROLLBACK"); err != nil {
			ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register INSERT ROLLBACK: %v",err))
			return ret_error
		}
		
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register INSERT users conn.Exec(): %v",err))
		return ret_error
	}	

	if err := RegisterMailFromSQL(conn, "mail_admin_1_register", nil, []interface{}{user_id}); err != nil {
		if _, err := conn.Exec(context.Background(), "ROLLBACK"); err != nil {
			ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register ROLLBACK: %v",err))
			return ret_error
		}
	
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register RegisterMail(): %v",err))
		return ret_error
	}

	//**** +1c schet - async call
	client_row.Id.SetValue(client_id)
	go createSchet(app, client_row)

	//Add action
	keys := make(map[string]interface{})
	keys["id"] = user_id
	if err := addAction(conn, sock, app.GetMD().Models["User"], "insert", keys); err != nil {
		conn.Exec(context.Background(), "ROLLBACK")
		return err
	}

	if _, err := conn.Exec(context.Background(), "COMMIT"); err != nil {		
		ret_error = osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_register COMMIT conn.Exec(): %v",err))
		return ret_error
	}	
	
	//+event
	PublishEventsWithKeys(sock, keys, app, pm, osbe.GetDbLsn(conn), "User")
	
	return nil
}

//************************* set_viewed **********************************************
//Public method: set_seen
type User_Controller_set_viewed struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_set_viewed) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.User_set_viewed_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}


func (pm *User_Controller_set_viewed) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_set_viewed: %v", err))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	args := rfltArgs.Interface().(*models.User_set_viewed)

	if _, err := conn.Exec(context.Background(),
		`UPDATE users SET viewed = TRUE WHERE id = $1`,
		args.User_id.GetValue()); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_set_viewed update: %v", err))
	}

	EmitEvent(conn, "User.update", args.User_id.GetValue())

	return nil
}

//************************* gen_qrcode **********************************************
//Public method: set_seen
type User_Controller_gen_qrcode struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_gen_qrcode) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.User_gen_qrcode_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}


func (pm *User_Controller_gen_qrcode) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.User_gen_qrcode)
	user_id := args.User_id.GetValue()
	
	//те, что меньше кодом - не из этой программы!!!
	if user_id < 1000000000 {
		return osbe.NewPublicMethodError(RESP_ER_OTHER_USER_DATA_CODE, RESP_ER_OTHER_USER_DATA_DESCR)
	}	
	
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_gen_qrcode: %v", err))
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	if sock != nil {
		sess := sock.GetSession()
		role_id := sess.GetString(osbe.SESS_ROLE)
		company_id := sess.GetInt(SESS_VAR_COMPANY_ID)
		comp_match := true
		if role_id == "client_admin1" {
			//только своим client_admin2 && person		
			comp_match = false
			if err := conn.QueryRow(context.Background(),
				`SELECT coalesce(
						(SELECT
							(coalesce(cl.parent_id,cl.id) = $1)
						FROM users AS u
						LEFT JOIN clients AS cl ON cl.id = u.company_id
						WHERE u.id = $2 AND (u.role_id = 'client_admin2' OR u.role_id = 'person')),
					FALSE) AS match`, company_id, user_id).Scan(&comp_match); err != nil {
			
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_gen_qrcode SELECT: %v", err))		
			}
			
		}else if role_id == "client_admin2" {
			//только своим person
			comp_match = false
			if err = conn.QueryRow(context.Background(),
				`SELECT coalesce(
						(SELECT
							(coalesce(cl.parent_id,cl.id) = $1)
						FROM users AS u
						LEFT JOIN clients AS cl ON cl.id = u.company_id
						WHERE u.id = $2 AND u.role_id = 'person'),
					FALSE) AS match`, company_id, user_id).Scan(&comp_match); err != nil {
			
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_gen_qrcode SELECT: %v", err))		
			}		
		}
		
		if !comp_match {
			return osbe.NewPublicMethodError(RESP_ER_OTHER_USER_DATA_CODE, RESP_ER_OTHER_USER_DATA_DESCR)
		}
	}
	person_url := ""		
	if err = conn.QueryRow(context.Background(),
		`SELECT coalesce(person_url, '') AS person_url
		FROM users
		WHERE id = $1`,
		user_id).Scan(&person_url); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_gen_qrcode SELECT person_url: %v", err))		
	}		
	if person_url == "" {
		person_url = QRPersonURL()
	}
	person_qr, err := QROnUserURL(app, conn, person_url)
	if err != nil {
		return err
	}	

	if _, err := conn.Exec(context.Background(),
		`UPDATE users SET
			person_url = $1,
			qr_code = $2
		WHERE id = $3`,
		person_url,
		person_qr,
		user_id); err != nil {
	
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_gen_qrcode update: %v", err))
	}
	//mail is sent in user trigger!
	EmitEvent(conn, "User.update", user_id)
	
	return nil
}

//************************* send_qrcode_email **********************************************
//Public method: set_seen
type User_Controller_send_qrcode_email struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *User_Controller_send_qrcode_email) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.User_send_qrcode_email_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}


func (pm *User_Controller_send_qrcode_email) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {	
	args := rfltArgs.Interface().(*models.User_send_qrcode_email)
	
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	user_id := args.User_id.GetValue()
	if err := RegisterMailFromSQL(conn, "mail_person_url", nil, []interface{}{user_id}); err != nil {
		return err
	}
	
	//
	if _, err := conn.Exec(context.Background(),
		`UPDATE users SET qr_code_sent_date = now() WHERE id = $1`,
		user_id); err != nil {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_send_qrcode_email update: %v", err))
	}
	EmitEvent(conn, "User.update", user_id)
	return nil
}

