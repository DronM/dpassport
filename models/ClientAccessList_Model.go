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

type ClientAccessList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Clients_ref fields.ValJSON `json:"clients_ref"`
	Client_id fields.ValInt `json:"client_id"`
	Date_from fields.ValDateTimeTZ `json:"date_from"`
	Date_to fields.ValDateTimeTZ `json:"date_to" defOrder:"DESC"`
	Doc_1c_ref fields.ValJSON `json:"doc_1c_ref"`
}

func NewModelMD_ClientAccessList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(ClientAccessList{})),
		ID: "ClientAccessList_Model",
		Relation: "client_accesses_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
