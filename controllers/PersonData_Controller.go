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
	"osbe/model"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/sql"
	
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

const PERSON_LOGIN_Q = "person_login"

//Controller
type PersonData_Controller struct {
	osbe.Base_Controller
}

func NewController_PersonData() *PersonData_Controller{
	c := &PersonData_Controller{osbe.Base_Controller{ID: "PersonData", PublicMethods: make(osbe.PublicMethodCollection)}}	

	//************************** method login *************************************
	c.PublicMethods["login"] = &PersonData_Controller_login{
		osbe.Base_PublicMethod{
			ID: "login",
			Fields: fields.GenModelMD(reflect.ValueOf(models.PersonData_login{})),
		},
	}
	
	return c
}

//************************* login **********************************************
//Public method: login
type PersonData_Controller_login struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *PersonData_Controller_login) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.PersonData_login_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

func (pm *PersonData_Controller_login) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {

	args := rfltArgs.Interface().(*models.PersonData_login)		
	url := ""
	
	if len(*args) == 0 {
		//no argument
		sess := sock.GetSession()
		url = sess.GetString(SESS_VAR_PERSON_URL)
	}else{
		//lk?1111111
		for url, _ = range *args {
			break
		}
	}
	if url == "" {
		return osbe.NewPublicMethodError(RESP_ER_BANNED_CODE, RESP_ER_BANNED_DESCR)	
	}
	
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetSecondary("")
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	user_row := models.UserLogin{}
	user_fields, user_ids, err := osbe.MakeStructRowFields(&user_row)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("User_Controller_login users_login osbe.MakeStructRowFields(): %v",err))
	}
	
	if _, err := conn.Prepare(context.Background(),
			PERSON_LOGIN_Q,
			fmt.Sprintf("SELECT %s FROM users_login WHERE person_url = $1", user_ids) ); err != nil {
			
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("PERSON_LOGIN_Q pgx.Conn.Prepare(): %v",err))	
	}
	
	err = conn.QueryRow(context.Background(), PERSON_LOGIN_Q, url).Scan(user_fields...)
			
	if err == pgx.ErrNoRows {
		//get all person data
		api_srv, err := NewAPIServer(d_store, app.GetLogger(), app.GetBaseDir())
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("PERSON_LOGIN_Q NewAPIServer(): %v",err))	
		}

		user_id, err := api_srv.GetPersonData(url)

		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("PERSON_LOGIN_Q GetPersonData(): %v",err))	
		}
		err = conn.QueryRow(context.Background(),
			fmt.Sprintf("SELECT %s FROM users_login WHERE id = $1", user_ids),
			user_id).Scan(user_fields...)
		if err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("PERSON_LOGIN_Q GetPersonData(), pgx.QueryRow(): %v",err))	
		}
	
	}else if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("PERSON_LOGIN_Q pgx.Rows.Scan(): %v",err))	
	}
	
	//args.Width_type.GetValue()
	_, err = doLoginUser(app, sock, conn, &user_row, "")
	if err != nil {
		return err
	}
		
	user_id := user_row.Id.GetValue()
	
	//return user data
	m_p := &model.Model{ID: "User"}
	m_p.Rows = make([]model.ModelRow, 1)		
	m_p.Rows[0] = struct {
		Id int64 `json:"id"`
		Name_full string `json:"name_full"`
	}{Id: user_id, Name_full: user_row.Name_full.GetValue()}
	resp.AddModel(m_p)
	
	//PersonData_View.js
	//сразу отдаем все данные по юзеру
	m := app.GetMD().Models["StudyDocumentList"]
	osbe.AddQueryResult(resp,  m, &models.StudyDocumentList{},
		fmt.Sprintf("SELECT %s FROM study_documents_list WHERE user_id=$1",m.GetFieldList("")), "", []interface{}{user_id}, conn, false)
	
	//predefined filter	
	f := socket.NewPresetFilter()
	f.Add("StudyDocumentList", sql.FilterCondCollection{&sql.FilterCond{FieldID: "user_id", Value: user_id, Sign: sql.SGN_SQL_E}})
	f.Add("StudyDocumentDialog", sql.FilterCondCollection{&sql.FilterCond{FieldID: "user_id", Value: user_id, Sign: sql.SGN_SQL_E}})
	f.Add("UserDialog", sql.FilterCondCollection{&sql.FilterCond{FieldID: "id", Value: user_id, Sign: sql.SGN_SQL_E}})
	f.Add("UserProfile", sql.FilterCondCollection{&sql.FilterCond{FieldID: "id", Value: user_id, Sign: sql.SGN_SQL_E}})
	if err := sock.SetPresetFilter(f); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("PersonData_Controller_login sock.SetPresetFilter(): %v",err))	
	}
	return nil
}





