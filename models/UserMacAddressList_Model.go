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

type UserMacAddressList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	User_id fields.ValInt `json:"user_id"`
	User_descr fields.ValText `json:"user_descr"`
	Mac_address fields.ValText `json:"mac_address" required:"true"`
	User_company_id fields.ValInt `json:"user_company_id"`
}

func NewModelMD_UserMacAddressList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserMacAddressList{})),
		ID: "UserMacAddressList_Model",
		Relation: "user_mac_addresses_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
