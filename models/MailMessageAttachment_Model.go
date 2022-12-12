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

type MailMessageAttachment struct {
	Id fields.ValInt `json:"id" required:"true" primaryKey:"true" autoInc:"true"`
	Mail_message_id fields.ValInt `json:"mail_message_id"`
	File_name fields.ValText `json:"file_name"`
}

func NewModelMD_MailMessageAttachment() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(MailMessageAttachment{})),
		ID: "MailMessageAttachment_Model",
		Relation: "mail_message_attachments",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type MailMessageAttachment_argv struct {
	Argv *MailMessageAttachment `json:"argv"`	
}

//Keys for delete/get object
type MailMessageAttachment_keys struct {
	Id fields.ValInt `json:"id"`
}
type MailMessageAttachment_keys_argv struct {
	Argv *MailMessageAttachment_keys `json:"argv"`	
}

//old keys for update
type MailMessageAttachment_old_keys struct {
	Old_id fields.ValInt `json:"old_id" required:"true"`
	Id fields.ValInt `json:"id"`
	Mail_message_id fields.ValInt `json:"mail_message_id"`
	File_name fields.ValText `json:"file_name"`
}

type MailMessageAttachment_old_keys_argv struct {
	Argv *MailMessageAttachment_old_keys `json:"argv"`	
}

