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

type LoginList struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Date_time_in fields.ValDateTimeTZ `json:"date_time_in" defOrder:"DESC"`
	Date_time_out fields.ValDateTimeTZ `json:"date_time_out"`
	Ip fields.ValText `json:"ip"`
	User_id fields.ValInt `json:"user_id"`
	Users_ref fields.ValJSON `json:"users_ref"`
	Pub_key fields.ValText `json:"pub_key"`
	Set_date_time fields.ValDateTimeTZ `json:"set_date_time"`
	User_agent_descr fields.ValText `json:"user_agent_descr"`
	User_agent fields.ValJSON `json:"user_agent"`
	Headers fields.ValJSON `json:"headers"`
}

func NewModelMD_LoginList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(LoginList{})),
		ID: "LoginList_Model",
		Relation: "logins_list",
		LimitConstant: "doc_per_page_count",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
	}
}
