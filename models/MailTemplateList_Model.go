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

type MailTemplateList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Mail_type fields.ValText `json:"mail_type"`
	Template fields.ValText `json:"template"`
}

func NewModelMD_MailTemplateList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(MailTemplateList{})),
		ID: "MailTemplateList_Model",
		Relation: "mail_templates_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
