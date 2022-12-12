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
	"time"
	"strings"
	
	"dpassport/models"
	
	"osbe"
	"ds/pgds"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	"osbe/srv/httpSrv"
	
	//"github.com/jackc/pgx/v4"
)

//Controller
type ClientAccess_Controller struct {
	osbe.Base_Controller
}

func NewController_ClientAccess() *ClientAccess_Controller{
	c := &ClientAccess_Controller{osbe.Base_Controller{ID: "ClientAccess", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.ClientAccess_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &ClientAccess_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.ClientAccess{})),
			EventList: osbe.PublicMethodEventList{"ClientAccess.insert"},
		},
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &ClientAccess_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"ClientAccess.delete"},
		},
	}
	
	//************************** method update *************************************
	c.PublicMethods["update"] = &ClientAccess_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.ClientAccess_old_keys{})),
			EventList: osbe.PublicMethodEventList{"ClientAccess.update"},
		},
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &ClientAccess_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &ClientAccess_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
	//************************** method make_order *************************************
	c.PublicMethods["make_order"] = &ClientAccess_Controller_make_order{
		osbe.Base_PublicMethod{
			ID: "make_order",
			Fields: fields.GenModelMD(reflect.ValueOf(models.ClientAccess_make_order{})),
		},
	}
			
	//************************** method get_order_print *************************************
	c.PublicMethods["get_order_print"] = &ClientAccess_Controller_get_order_print{
		osbe.Base_PublicMethod{
			ID: "get_order_print",
			Fields: fields.GenModelMD(reflect.ValueOf(models.ClientAccess_get_order_print{})),
		},
	}
	
	return c
}

type ClientAccess_Controller_keys_argv struct {
	Argv models.ClientAccess_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type ClientAccess_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *ClientAccess_Controller_insert) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.ClientAccess_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}
func (pm *ClientAccess_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//modified
	return InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["ClientAccess"], &models.ClientAccess_keys{}, sock.GetPresetFilter("ClientAccess"))	
}

//************************* DELETE **********************************************
type ClientAccess_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *ClientAccess_Controller_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.ClientAccess_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *ClientAccess_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//modified
	return DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["ClientAccess"], sock.GetPresetFilter("ClientAccess"))	
}

//************************* GET OBJECT **********************************************
type ClientAccess_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *ClientAccess_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.ClientAccess_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *ClientAccess_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["ClientAccessList"], &models.ClientAccessList{}, sock.GetPresetFilter("ClientAccessList"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type ClientAccess_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *ClientAccess_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *ClientAccess_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["ClientAccessList"], &models.ClientAccessList{}, sock.GetPresetFilter("ClientAccessList"))	
}

//************************* UPDATE **********************************************
//Public method: update
type ClientAccess_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *ClientAccess_Controller_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.ClientAccess_old_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *ClientAccess_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//modified
	return UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["ClientAccess"], sock.GetPresetFilter("ClientAccess"))	
}

//************************* make_order **********************************************
//Public method: make_order
type ClientAccess_Controller_make_order struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *ClientAccess_Controller_make_order) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.ClientAccess_make_order_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *ClientAccess_Controller_make_order) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetSecondary("")
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	args := rfltArgs.Interface().(*models.ClientAccess_make_order)	
	
	dog_date_from := fields.ValDate{}
	dog_date_to := fields.ValDate{}
	client_row := models.ClientDialog{}
	if err := conn.QueryRow(context.Background(),
		fmt.Sprintf(`SELECT
			cl.id,
			cl.name,
			cl.inn,
			cl.name_full,
			cl.legal_address,
			cl.post_address,
			cl.kpp,
			cl.ogrn,
			cl.okpo,
			cl.okved,
			cl.email,
			cl.tel,
			ac.date_from,
			ac.date_to			
		FROM clients_dialog AS cl
		LEFT JOIN client_accesses AS ac ON ac.client_id = cl.id
		WHERE ac.id = %d`, 
		args.Client_access_id.GetValue())).Scan(
				&client_row.Id,
				&client_row.Name,
				&client_row.Inn,
				&client_row.Name_full,
				&client_row.Legal_address,
				&client_row.Post_address,
				&client_row.Kpp,
				&client_row.Ogrn,
				&client_row.Okpo,
				&client_row.Okved,
				&client_row.Email,
				&client_row.Tel,
				&dog_date_from,
				&dog_date_to,
		); err != nil {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("ClientAccess_Controller_make_order conn.QueryRow().Scan(): %v",err))
	}
	
	srv_1c, err := NewServer1C(d_store, app.GetLogger())
	if err != nil {		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("ClientAccess_Controller_make_order NewServer1C(): %v",err))
	}	
	
	q_id := args.Q_id.GetValue()
	
	//async
	go (func(){		
		doc := DocSchet{Date: time.Now(),
			Client: SprClient{Name: client_row.Name.GetValue(),
				Name_full: client_row.Name_full.GetValue(),
				Inn: client_row.Inn.GetValue(),
				Kpp: client_row.Kpp.GetValue(),
				Ogrn: client_row.Ogrn.GetValue(),
				Dogovor: SprDogovor{Date_from: dog_date_from.GetValue(),
					Date_to: dog_date_to.GetValue(),
					Item_name: srv_1c.Item_name,
				},
			},
		}
		new_doc, err := srv_1c.ExecuteCommand(CMD_ADD_SCHET, &doc)
		if err != nil {
			notifyClientOn1cOrderError(d_store, q_id, err)
			return
		}
		doc_b, err := json.Marshal(&new_doc)
		if err != nil {
			notifyClientOn1cOrderError(d_store, q_id, err)
			return
		}
fmt.Println("doc_b=", string(doc_b))		
		//write connection
		pool_conn_m, conn_id_m, err_с_m := d_store.GetPrimary()
		if err_с_m != nil {
			return
		}
		defer d_store.Release(pool_conn_m, conn_id_m)
		conn_m := pool_conn_m.Conn()
		
		if _, err = conn_m.Exec(context.Background(),
			`UPDATE client_accesses
			SET
				doc_1c_ref = $1
			WHERE id = $2`,
			doc_b, args.Client_access_id); err!= nil {
		
			conn.Exec(context.Background(), fmt.Sprintf(`SELECT pg_notify('Server1C.makeOrder_%s', json_build_object('params', json_build_object('res', FALSE, 'descr', 'Ошибка формирования счета.'))::text)`, q_id))
			return
		}
		conn.Exec(context.Background(), fmt.Sprintf(`SELECT pg_notify('Server1C.makeOrder_%s', json_build_object('params', json_build_object('res', TRUE))::text)`, q_id))
	})()
		
	return nil
}

func notifyClientOn1cOrderError(dStore *pgds.PgProvider, qID string, err error) {
	pool_conn_m, conn_id_m, err_с_m := dStore.GetPrimary()
	if err_с_m != nil {
		return
	}
	defer dStore.Release(pool_conn_m, conn_id_m)
	conn_m := pool_conn_m.Conn()
	
	e_txt := strings.Replace(err.Error(), "'", "''", -1)
	q := fmt.Sprintf(`SELECT pg_notify('Server1C.makeOrder_%s', json_build_object('params', json_build_object('res', FALSE, 'descr', '%s'))::text)`, qID, e_txt)
	conn_m.Exec(context.Background(), q)			
}


//************************* get_order_print **********************************************
//Public method: get_order_print
type ClientAccess_Controller_get_order_print struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *ClientAccess_Controller_get_order_print) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.ClientAccess_get_order_print_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *ClientAccess_Controller_get_order_print) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//db connect
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetSecondary("")
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()

	args := rfltArgs.Interface().(*models.ClientAccess_get_order_print)	
	
	srv_1c, err := NewServer1C(d_store, app.GetLogger())
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("ClientAccess_Controller_make_order NewServer1C(): %v",err))
	}	
	ref_1c := ""
	if err := conn.QueryRow(context.Background(), 
		`SELECT
			coalesce(doc_1c_ref->>'ref', '') AS ref
		FROM client_accesses
		WHERE id = $1`, args.Client_access_id).Scan(&ref_1c); err != nil {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("ClientAccess_Controller_get_order_print conn.QueryRow(): %v",err))
	}

	order_b, err := srv_1c.GetSchetPrint(app, ref_1c)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("ClientAccess_Controller_get_order_print srv_1c.GetSchetPrint(): %v",err))
	}
	sock_http, ok := sock.(*httpSrv.HTTPSocket)
	if !ok {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, "ClientAccess_Controller_get_order_print sock must be *HTTPSocket")
	}	
	httpSrv.ServeContent(sock_http, &order_b, "СчетНаОплату.pdf", httpSrv.MIME_TYPE_pdf, time.Time{}, httpSrv.CONTENT_DISPOSITION_INLINE)		
	
	return nil
}


