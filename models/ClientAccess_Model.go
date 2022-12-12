package models

/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

import (
	"reflect"	
		
	"osbe/fields"
	"osbe/model"
)

type ClientAccess struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Client_id fields.ValInt `json:"client_id"`
	Date_from fields.ValDateTimeTZ `json:"date_from"`
	Date_to fields.ValDateTimeTZ `json:"date_to"`
	Doc_1c_ref fields.ValJSON `json:"doc_1c_ref"`
}

func NewModelMD_ClientAccess() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(ClientAccess{})),
		ID: "ClientAccess_Model",
		Relation: "client_accesses",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type ClientAccess_argv struct {
	Argv *ClientAccess `json:"argv"`	
}

//Keys for delete/get object
type ClientAccess_keys struct {
	Id fields.ValInt `json:"id"`
}
type ClientAccess_keys_argv struct {
	Argv *ClientAccess_keys `json:"argv"`	
}

//old keys for update
type ClientAccess_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Client_id fields.ValInt `json:"client_id"`
	Date_from fields.ValDateTimeTZ `json:"date_from"`
	Date_to fields.ValDateTimeTZ `json:"date_to"`
	Doc_1c_ref fields.ValJSON `json:"doc_1c_ref"`
}

type ClientAccess_old_keys_argv struct {
	Argv *ClientAccess_old_keys `json:"argv"`	
}

