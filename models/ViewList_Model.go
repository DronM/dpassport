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

type ViewList struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	C fields.ValText `json:"c"`
	F fields.ValText `json:"f"`
	T fields.ValText `json:"t"`
	Href fields.ValText `json:"href"`
	User_descr fields.ValText `json:"user_descr" defOrder:"ASC"`
	Section fields.ValText `json:"section"`
}

func NewModelMD_ViewList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(ViewList{})),
		ID: "ViewList_Model",
		Relation: "views_list",
		LimitConstant: "doc_per_page_count",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
	}
}
