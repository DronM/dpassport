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
	
	"dpassport/models"
	
	"ds/pgds"
	
	"osbe"	
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	
	
	"github.com/jackc/pgx/v4/pgxpool"
	//"github.com/jackc/pgx/v4"
)

//Controller
type ClientSearch_Controller struct {
	osbe.Base_Controller
}

func NewController_ClientSearch() *ClientSearch_Controller{
	c := &ClientSearch_Controller{osbe.Base_Controller{ID: "ClientSearch", PublicMethods: make(osbe.PublicMethodCollection)}}	
	
	//************************** method search *************************************
	c.PublicMethods["search"] = &ClientSearch_Controller_search{
		osbe.Base_PublicMethod{
			ID: "search",
			Fields: fields.GenModelMD(reflect.ValueOf(models.ClientSearch_search{})),
		},
	}
	
	return c
}

//************************* get_file **********************************************
//Public method: get_file
type ClientSearch_Controller_search struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *ClientSearch_Controller_search) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.ClientSearch_search_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

type searchResultRow struct {
	Param  string `json:"param"`
	Val  string `json:"val"`		
}

//Method implemenation
func (pm *ClientSearch_Controller_search) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	args := rfltArgs.Interface().(*models.ClientSearch_search)
	
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	search_res, err := searchClientByINN(app, conn, args.Query.GetValue())
	if err != nil {
		return err
	}
	
	data := search_res.Suggestions[0].Data	
	ret_model := &model.Model{ID: model.ModelID("SearchResult_Model"), Rows: make([]model.ModelRow, 0)}

	if data.Name != nil && data.Name.Short != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "Наименование", Val: *data.Name.Short})	
		
	}else if data.Fio != nil {
		n := ""
		if data.Fio.Surname != nil && *data.Fio.Surname != "" {
			n = *data.Fio.Surname
		}
		if data.Fio.Name != nil && *data.Fio.Name != "" {
			if n != "" {
				n+= " "
			}
			n += *data.Fio.Name
		}
		if data.Fio.Patronymic != nil && *data.Fio.Patronymic != "" {
			if n != "" {
				n+= " "
			}
			n += *data.Fio.Patronymic
		}
		
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "Наименование", Val: n})	
	}
	
	if data.Name != nil && data.Name.Full_with_opf != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "Наименование полное", Val: *data.Name.Full_with_opf})	
	}
	
	if data.Management != nil && data.Management.Name != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "ФИО руководителя", Val: *data.Management.Name})	
	}
	if data.Management != nil && data.Management.Post != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "Должность руководителя", Val: *data.Management.Post})	
	}
	if data.Inn != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "ИНН", Val: *data.Inn})	
	}
	if data.Kpp != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "КПП", Val: *data.Kpp})	
	}
	if data.Ogrn != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "ОГРН", Val: *data.Ogrn})	
	}
	if data.Okpo != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "ОКПО", Val: *data.Okpo})	
	}
	if data.Okved != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "ОКВЭД", Val: *data.Okved})	
	}
	if data.Okato != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "ОКАТО", Val: *data.Okato})	
	}
	if data.Address != nil && data.Address.Unrestricted_value != nil {
		ret_model.Rows = append(ret_model.Rows, &searchResultRow{Param: "Адрес", Val: *data.Address.Unrestricted_value})	
	}
	
	resp.AddModel(ret_model)
	
	
	return nil
}




