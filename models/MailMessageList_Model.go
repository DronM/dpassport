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

type MailMessageList struct {
	Id fields.ValInt `json:"id" required:"true" primaryKey:"true" autoInc:"true"`
	Date_time fields.ValDateTime `json:"date_time" defOrder:"DESC"`
	From_addr fields.ValText `json:"from_addr"`
	From_name fields.ValText `json:"from_name"`
	To_addr fields.ValText `json:"to_addr"`
	To_name fields.ValText `json:"to_name"`
	Reply_addr fields.ValText `json:"reply_addr"`
	Reply_name fields.ValText `json:"reply_name"`
	Body_begin fields.ValText `json:"body_begin"`
	Sender_addr fields.ValText `json:"sender_addr"`
	Subject fields.ValText `json:"subject"`
	Sent fields.ValBool `json:"sent"`
	Sent_date_time fields.ValDateTime `json:"sent_date_time"`
	Mail_type enums.ValEnum_mail_types `json:"mail_type"`
	Error_str fields.ValText `json:"error_str"`
	Attachment_count fields.ValInt `json:"attachment_count"`
}

func (o *MailMessageList) SetNull() {
	o.Id.SetNull()
	o.Date_time.SetNull()
	o.From_addr.SetNull()
	o.From_name.SetNull()
	o.To_addr.SetNull()
	o.To_name.SetNull()
	o.Reply_addr.SetNull()
	o.Reply_name.SetNull()
	o.Body_begin.SetNull()
	o.Sender_addr.SetNull()
	o.Subject.SetNull()
	o.Sent.SetNull()
	o.Sent_date_time.SetNull()
	o.Mail_type.SetNull()
	o.Error_str.SetNull()
	o.Attachment_count.SetNull()
}

func NewModelMD_MailMessageList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(MailMessageList{})),
		ID: "MailMessageList_Model",
		Relation: "mail_messages_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
