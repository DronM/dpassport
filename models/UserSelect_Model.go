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

type UserSelect struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Descr fields.ValText `json:"descr" defOrder:"ASC"`
	Company_id fields.ValText `json:"company_id"`
}

func NewModelMD_UserSelect() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserSelect{})),
		ID: "UserSelect_Model",
		Relation: "users_select_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
