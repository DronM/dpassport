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
	"dpassport/enums"	
	"osbe/fields"
	"osbe/model"
)

type MailTemplate struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Mail_type enums.ValEnum_mail_types `json:"mail_type" required:"true" defOrder:"ASC"`
	Template fields.ValText `json:"template" required:"true"`
	Comment_text fields.ValText `json:"comment_text" required:"true"`
	Mes_subject fields.ValText `json:"mes_subject" required:"true"`
	Fields fields.ValJSON `json:"fields" required:"true"`
}

func NewModelMD_MailTemplate() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(MailTemplate{})),
		ID: "MailTemplate_Model",
		Relation: "mail_templates",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type MailTemplate_argv struct {
	Argv *MailTemplate `json:"argv"`	
}

//Keys for delete/get object
type MailTemplate_keys struct {
	Id fields.ValInt `json:"id"`
}
type MailTemplate_keys_argv struct {
	Argv *MailTemplate_keys `json:"argv"`	
}

//old keys for update
type MailTemplate_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Mail_type enums.ValEnum_mail_types `json:"mail_type"`
	Template fields.ValText `json:"template"`
	Comment_text fields.ValText `json:"comment_text"`
	Mes_subject fields.ValText `json:"mes_subject"`
	Fields fields.ValJSON `json:"fields"`
}

type MailTemplate_old_keys_argv struct {
	Argv *MailTemplate_old_keys `json:"argv"`	
}

