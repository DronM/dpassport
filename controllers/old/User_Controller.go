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
	
	SESS_VAR_TEL = "USER_TEL"
	SESS_VAR_NAME = "USER_NAME"
	SESS_VAR_ID = "USER_ID"
	SESS_VAR_WIDTH_TYPE = "WIDTH_TYPE"
	SESS_VAR_LOGIN_ID = "USER_LOGIN_ID"
	SESS_VAR_LOGGED = "LOGGED"
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
			ID: "get_list",
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
	
	//1) begin transaction
	_, err = conn.Exec(context.Background(), "BEGIN")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_insert BEGIN: %v",err))
	}
	
	//2) custom
	pwd := DEF_PASSWORD//genUniqID(PWD_LEN)
	hash := GetMd5(pwd)
	args.Pwd.SetValue(hash)
	
	field_ids, field_args, field_values := osbe.ArgsToInsertParams(rfltArgs, "")		
	q := fmt.Sprintf("INSERT INTO users (%s) VALUES (%s) RETURNING id", field_ids, field_args)
	row := &models.User_keys{}
	if err := conn.QueryRow(context.Background(), q, field_values...).Scan(&row.Id); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("pgx.Conn.QueryRow.Scan(&row.Id): %v",err))
	}
	resp.AddModel(model.New_InsertedKey_Model(row))
	
	if err := sendEmailNewPwd(conn, row.Id.GetValue(), pwd); err != nil {
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
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["UserList"], &models.UserList{}, sock.GetPresetFilter("UserList"))
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
	
	//photo upload
	http_sock, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "User_Controller_update: not HTTPSocket type")
	}	

	//uploaded file
	data, _, err := http_sock.GetUploadedFileData("photo[]")
	if err == nil {
		args := rfltArgs.Interface().(*models.User_old_keys)
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
	argv := &models.User_keys_argv{}
	
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
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn	
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
		
	_, err = conn.Prepare(context.Background(), "users_reset_pwd", "UPDATE users SET pwd = $1 WHERE id = $2")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("pgx.Conn.Prepare(): %v",err))
	}
	
	//custom
	pwd := genUniqID(PWD_LEN)
	hash := GetMd5(pwd)
	if hash == "" {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "Ошибка генерации пароля")
	}	
	args := rfltArgs.Interface().(*models.User_keys)
	_, err = conn.Exec(context.Background(), "users_reset_pwd", hash, args.Id)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("pgx.Conn.Query(): %v",err))
	}
	
	if err := sendEmailResetPwd(conn, args.Id.GetValue(), pwd); err != nil {
		return osbe.NewPublicMethodError(RESP_ER_EMAIL, fmt.Sprintf("sendEmailResetPwd(): %v",err))
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
	_, err = conn.Prepare(context.Background(), "users_login_q", fmt.Sprintf("SELECT %s FROM users_login WHERE name = $1 AND pwd = md5($2)", user_ids) )
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login pgx.Conn.Prepare(): %v",err))
	}

	args := rfltArgs.Interface().(*models.User_login)
	err = conn.QueryRow(context.Background(), "users_login_q", args.Name.GetValue(), args.Pwd.GetValue()).Scan(user_fields...)	
	if err == pgx.ErrNoRows {
		return osbe.NewPublicMethodError(RESP_ER_AUTH_CODE, RESP_ER_AUTH_DESCR)	
		
	}else if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login_q conn.QueryRow(): %v",err))	
	}
	if user_row.Banned.GetValue() {
		return osbe.NewPublicMethodError(RESP_ER_BANNED_CODE, RESP_ER_BANNED_DESCR)
	}	
	
	_, err = conn.Prepare(context.Background(), "users_login_pub_key",
		`SELECT pub_key, id
		FROM logins
		WHERE session_id=$1 AND user_id=$2 AND date_time_out IS NULL`)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login_pub_key pgx.Conn.Prepare(): %v",err))
	}
	
	sess := sock.GetSession()
	sess_id := sess.SessionID()
		
	//user agent
	user_ip := ""
	user_headers := []byte("{}") 
	user_a_s := []byte("{}")
	if sock_http, ok := sock.(*httpSrv.HTTPSocket); ok {
		user_ip = sock_http.Request.RemoteAddr
		user_ip_port_p := strings.Index(user_ip, ":")
		if user_ip_port_p >= 0 {
			user_ip = user_ip[:user_ip_port_p]
		}
		user_headers, err = json.Marshal(sock_http.Request.Header)
		if err != nil {
			//just log
			app.GetLogger().Errorf("User_Controller_login json.Marshal(sock_http.Request.Header): %v", err)			
		}
		ua_s := sock_http.Request.Header.Get("User-Agent")
		if ua_s != "" {
			user_a_s, err = getUserAgentFieldValue(ua_s)
			if err != nil {
				//just log
				app.GetLogger().Errorf("User_Controller_login getUserAgentFieldValue(): %v", err)			
			}
			
			if user_row.Role_id.GetValue() != "admin" {
				device_hash := ""
				err := conn.QueryRow(context.Background(),
					`SELECT md5(login_devices_uniq($1::jsonb)) AS hash`,
					string(user_a_s)).Scan(&device_hash)
				if err != nil {
					//just log
					app.GetLogger().Errorf("User_Controller_login login_devices_uniq(): %v", err)			
				}else{
					//check for banned device
					if !user_row.Ban_hash.GetIsNull() && strings.Index(user_row.Ban_hash.GetValue(), device_hash) >= 0 {
						//device is in banned list
						return osbe.NewPublicMethodError(RESP_ER_BANNED_DEV_CODE, RESP_ER_BANNED_DEV_DESCR)
					}
					//No banned. New device? было ло ли в logins такое устройство?
					var date_time_in fields.ValDateTimeTZ
					err := conn.QueryRow(context.Background(),
						`SELECT
							date_time_in
						FROM login_devices_list
						WHERE user_id = $1 AND ban_hash = $2`,
						user_row.Id.GetValue(), device_hash).Scan(&date_time_in)
						
					if err != nil && err != pgx.ErrNoRows {
						return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login first SELECT FROM login_devices_list: %v",err))	
							
					}
						
					if err == pgx.ErrNoRows || date_time_in.GetIsNull() {
						//first login - ban!
						if _, err := conn.Exec(context.Background(),
							`INSERT INTO login_device_bans
								(user_id, hash) VALUES ($1, $2) ON CONFLICT (user_id, hash) DO NOTHING`,
							user_row.Id.GetValue(), device_hash); err != nil {
								return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login first login ban pgx.Conn.Exec(): %v",err))	
						}
						if _, err := conn.Exec(context.Background(),
							`INSERT INTO logins
								(date_time_in, date_time_out, ip, session_id, pub_key, user_id, headers, user_agent)
								VALUES(now(), now(), $1, $2, NULL, $3, $4::json, $5::jsonb)`,
							user_ip, sess_id, 
							user_row.Id.GetValue(), string(user_headers), string(user_a_s)); err != nil {
								return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login first login ban pgx.Conn.Exec(): %v",err))									
						}
						return osbe.NewPublicMethodError(RESP_ER_BANNED_DEV_CODE, RESP_ER_BANNED_DEV_DESCR)						
					}
				}
			}
		}
	}
	
	pub_key := ""
	login_id := 0
	
	err = conn.QueryRow(context.Background(),
		"users_login_pub_key", sess_id, user_row.Id.GetValue()).Scan(&pub_key, &login_id)
		
	if err == pgx.ErrNoRows {
		//no user login
		pub_key = genUniqID(15);
		
		_, err := conn.Prepare(context.Background(), "users_login_update",
			`UPDATE logins
			SET
				user_id = $1,
				pub_key = $2,
				date_time_in = now(),
				set_date_time = now(),
				user_agent = $3::jsonb,
				ip = $4,
				headers = $5::json
				FROM (
					SELECT
						l.id AS id
					FROM logins l
					WHERE l.session_id=$6 AND l.user_id IS NULL
					ORDER BY l.date_time_in DESC
					LIMIT 1										
				) AS s
				WHERE s.id = logins.id
			RETURNING logins.id`)
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login_update pgx.Conn.Prepare(): %v",err))
		}		
		err = conn.QueryRow(context.Background(), "users_login_update",
				user_row.Id.GetValue(),
				pub_key,
				string(user_a_s), user_ip, string(user_headers),
				sess_id).Scan(&login_id)
				
		if err == pgx.ErrNoRows {
			//no user			
			_, err := conn.Prepare(context.Background(), "users_login_insert",
				`INSERT INTO logins
				(date_time_in, ip, session_id, pub_key, user_id, user_agent, headers)
				VALUES (now(), $1, $2, $3, $4, $5, $6)				
				RETURNING id`)
			if err != nil {
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login_insert pgx.Conn.Prepare(): %v",err))
			}
					
			//fmt.Println("IP=",sock.GetIP(), "sess_id=",sess_id, "pub_key=", pub_key, "ID=", row.Id.GetValue())
			if err = conn.QueryRow(context.Background(),
				"users_login_insert",
					sock.GetIP(),
					sess_id,
					pub_key,
					user_row.Id.GetValue(),
					string(user_a_s),
					string(user_headers)).Scan(&login_id); err != nil {
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login_insert pgx.Rows.Scan(): %v",err))	
			}		
			
			
		} else if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login_update pgx.Rows.Scan(): %v",err))	
			
		}				
		
	}else if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login_pub_key pgx.Rows.Scan(): %v",err))	
	}
	
	//Session data
	sess.Set(osbe.SESS_ROLE, user_row.Role_id.GetValue())
	sess.Set(osbe.SESS_LOCALE, user_row.Locale_id.GetValue())
	
	user_descr := ""
	if !user_row.Name_full.GetIsNull() {
		user_descr = user_row.Name_full.GetValue()
	}else{
		user_descr = user_row.Name.GetValue()
	}
	sess.Set(SESS_VAR_NAME, user_descr)
	
	sess.Set(SESS_VAR_ID, user_row.Id.GetValue())	
	//sess.Set("time_zone_locales_ref", user_row.Time_zone_locales_ref.GetValue())
	//sess.Set("USER_PHONE_CEL", user_row.Phone_cel.GetValue())
	sess.Set(SESS_VAR_TEL, user_row.Phone_cel.GetValue())	
	sess.Set(SESS_VAR_WIDTH_TYPE, args.Width_type.GetValue())
	
	//
	sess.Set(SESS_VAR_LOGIN_ID, login_id)
	sess.Set(SESS_VAR_LOGGED, true)
	if err := sess.Flush(); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login sess.Flush(): %v",err))	
	}
//fmt.Println("setting logged! Name=",user_row.Name.GetValue(),"ID=",user_row.Id.GetValue())
//fmt.Println("logged=",sess.GetBool("LOGGED"),sess.Get("LOGGED"),"sess_id=",sess_id)		
	
	//return auth
	/*token := fmt.Sprintf("%s:%s", pub_key, GetMd5(pub_key + sess_id))
	token_r:= fmt.Sprintf("%s:%s", pub_key, GetMd5(pub_key + user_row.Pwd + strconv.FormatInt(user_row.Id.GetValue(), 10))) 
	resp.AddModel(models.NewAuth_Model(token, token_r, sock.GetTokenExpires()))
	*/
	addAuthModel(resp, pub_key, sess_id, user_row.Pwd.GetValue(), user_row.Id.GetValue(), sock.GetTokenExpires())
	
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

	_, err = conn.Prepare(context.Background(), "users_login_close",
		`UPDATE logins
		SET date_time_out = now()
		WHERE id=$1`)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("users_login_close pgx.Conn.Prepare(): %v",err))
	}
			
	if _, err = conn.Exec(context.Background(), "users_login_close", login_id); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("users_login_close pgx.Exec(): %v",err))	
	}		
	return nil
}

func sendEmailNewPwd(conn *pgx.Conn, id int64, pwd string) error {
	//_, err := conn.Exec(context.Background(), "SELECT email_user_new_account($1, $2)", id, pwd)
	//return err
	return nil
}

func sendEmailResetPwd(conn *pgx.Conn, id int64, pwd string) error {
	//_, err := conn.Exec(context.Background(), "SELECT email_user_reset_pwd($1, $2)", id, pwd)
	//return err
	return nil
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

	_, err = conn.Prepare(context.Background(), "users_login_token",
			`SELECT
				trim(l.session_id) AS session_id,
				u.pwd,
				u.user_id,
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
			WHERE l.date_time_out IS NULL AND l.pub_key=$1`)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("users_login_token pgx.Conn.Prepare(): %v",err))
	}
	
	session_id := ""
	pwd_hash := ""
	user_id := 0
	user_row := &models.UserDialog{}
	err = conn.QueryRow(context.Background(), "users_login_token",pub_key).Scan(&session_id,
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
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("users_login_token pgx.Rows.Scan(): %v",err))	
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
