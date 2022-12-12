package controllers

/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

import (
	"encoding/json"
	"reflect"
	"strings"
	"fmt"
	"context"
	"encoding/xml"
	
	"transport/models"
	
	"ds/pgds"
	"osbe"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

//Controller
type MainMenuConstructor_Controller struct {
	osbe.Base_Controller	
}

func NewController_MainMenuConstructor() *MainMenuConstructor_Controller{

	c := &MainMenuConstructor_Controller{osbe.Base_Controller{ID: "MainMenuConstructor", PublicMethods: make(osbe.PublicMethodCollection)}}
	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.Client_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &MainMenuConstructor_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.MainMenuConstructor{})),
			EventList: osbe.PublicMethodEventList{"MainMenuConstructor.insert"},
		},				
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &MainMenuConstructor_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"MainMenuConstructor.delete"},
		},				
	}

	//************************** method update *************************************
	c.PublicMethods["update"] = &MainMenuConstructor_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.MainMenuConstructor_old_keys{})),
			EventList: osbe.PublicMethodEventList{"MainMenuConstructor.update"},
		},				
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &MainMenuConstructor_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},		
	}

	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &MainMenuConstructor_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},		
	}

	return c	
}

//************************* INSERT **********************************************
//Public method: insert

type MainMenuConstructor_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *MainMenuConstructor_Controller_insert) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.MainMenuConstructor_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}

	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}
func (pm *MainMenuConstructor_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	args := rfltArgs.Interface().(*models.MainMenuConstructor)
	new_cont, err := gen_user_menu(conn, args.Content.GetValue())
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("MainMenuConstructor_Controller_insert gen_user_menu(): %v",err))
	}
	args.Model_content.SetValue(new_cont)

	return osbe.InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["MainMenuConstructor"], &models.MainMenuConstructor_keys{}, nil)
}

//************************* DELETE **********************************************
type MainMenuConstructor_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *MainMenuConstructor_Controller_delete) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.MainMenuConstructor_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *MainMenuConstructor_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["MainMenuConstructor"], nil)
}

//************************* GET OBJECT **********************************************
type MainMenuConstructor_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *MainMenuConstructor_Controller_get_object) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.MainMenuConstructor_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *MainMenuConstructor_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["MainMenuConstructorDialog"], &models.MainMenuConstructorDialog{}, nil)
}

//************************* GET LIST **********************************************
//Public method: get_list
type MainMenuConstructor_Controller_get_list struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *MainMenuConstructor_Controller_get_list) Unmarshal(payload []byte) (res reflect.Value, err error) {

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
func (pm *MainMenuConstructor_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["MainMenuConstructorList"], &models.MainMenuConstructorList{}, nil)
}

//************************* UPDATE **********************************************
//Public method: update
type MainMenuConstructor_Controller_update struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *MainMenuConstructor_Controller_update) Unmarshal(payload []byte) (res reflect.Value, err error) {

	//argument structrure
	argv := &models.MainMenuConstructor_old_keys_argv{}
	
	err = json.Unmarshal(payload, argv)
	if err != nil {
		return 
	}
	
	res = reflect.ValueOf(&argv.Argv).Elem()
	
	return
}

//Method implemenation
func (pm *MainMenuConstructor_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	args := rfltArgs.Interface().(*models.MainMenuConstructor_old_keys)
	if !args.Content.GetIsSet() {
		if err := conn.QueryRow(context.Background(),
			`SELECT content FROM main_menus WHERE id = $1`,
			args.Old_id.GetValue()).Scan(&args.Content); err != nil {
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("MainMenuConstructor_Controller_update pgx.Conn.QueryRow(): %v",err))
		}		
	}
	new_cont, err := gen_user_menu(conn, args.Content.GetValue())
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("MainMenuConstructor_Controller_update gen_user_menu(): %v",err))
	}
	args.Model_content.SetValue(new_cont)
	
	return osbe.UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["MainMenuConstructor"], nil)
}

//*************************
type MenuItem struct {
	XMLName xml.Name `xml:"menuitem"`
	ViewID    string   `xml:"viewid,attr"`
	MenuItems   []MenuItem   `xml:"menuitem"`
}
type Menu struct {
    XMLName xml.Name `xml:"menu"`
    MenuItems   []MenuItem   `xml:"menuitem"`
}

func add_item(sql *string, items []MenuItem, view_ids *[]string) {
	for _,it := range items {
		if it.ViewID == "" {
			if it.MenuItems!= nil && len(it.MenuItems) > 0 {
				add_item(sql, it.MenuItems, view_ids)
			}
			continue
		}
		if *sql != "" {
			*sql += " UNION ALL "
		}
		*sql += fmt.Sprintf(
			`SELECT
				CASE WHEN v.c IS NOT NULL THEN 'c="' || v.c|| '"' ELSE '' END
				||CASE WHEN v.f IS NOT NULL THEN CASE WHEN v.c IS NULL THEN '' ELSE ' ' END|| 'f="' || v.f || '"' ELSE '' END
				||CASE WHEN v.t IS NOT NULL THEN CASE WHEN v.c IS NULL AND v.f IS NULL THEN '' ELSE ' ' END|| 't="' || v.t || '"' ELSE '' END
				||CASE WHEN v.limited IS NOT NULL AND v.limited THEN CASE WHEN v.c IS NULL AND v.f IS NULL AND v.t IS NULL THEN '' ELSE ' ' END|| 'limit="TRUE"' ELSE '' END
			FROM views v WHERE v.id=%s`,
			it.ViewID)		
		*view_ids = append(*view_ids, it.ViewID)
	}
}

func gen_user_menu(conn *pgx.Conn, content string) (string,error) {
	content = strings.ReplaceAll(content, `xmlns="http://www.w3.org/1999/xhtml"`, "")
	content = strings.ReplaceAll(content, `xmlns="http://www.katren.org/crm/doc/mainmenu"`, "")
//fmt.Println(content)
	
	var menu Menu
	if err := xml.Unmarshal([]byte(content), &menu); err != nil {
		return "",err
	}
	if menu.MenuItems == nil || len(menu.MenuItems) == 0 {
		return "",nil
	}
//fmt.Println("content=", content)		
//fmt.Println("LEN=", len(menu.MenuItems))	
	sql := "";
	view_ids := []string{}
	add_item(&sql, menu.MenuItems, &view_ids)
//fmt.Printf(sql);	
	rows, err := conn.Query(context.Background(), sql)
	if err != nil {
		return "",err
	}
	
	view_ind := 0	
	for rows.Next() {
		cmd := ""
		if err := rows.Scan(&cmd); err != nil {		
			return "",err
		}
		content = strings.ReplaceAll(content, fmt.Sprintf(`viewid="%s"`, view_ids[view_ind]), cmd);
		content = strings.ReplaceAll(content, fmt.Sprintf(`viewid ="%s"`, view_ids[view_ind]), cmd);
		content = strings.ReplaceAll(content, fmt.Sprintf(`viewid= "%s"`, view_ids[view_ind]), cmd);
		content = strings.ReplaceAll(content, fmt.Sprintf(`viewid = "%s"`, view_ids[view_ind]), cmd);
		view_ind++
	}
	if err := rows.Err(); err != nil {
		return "",err
	}

	return content, nil
}


