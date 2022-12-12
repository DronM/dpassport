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

type MailMessage struct {
	Id fields.ValInt `json:"id" required:"true" primaryKey:"true" autoInc:"true"`
	Date_time fields.ValDateTime `json:"date_time" defOrder:"DESC"`
	From_addr fields.ValText `json:"from_addr"`
	From_name fields.ValText `json:"from_name"`
	To_addr fields.ValText `json:"to_addr"`
	To_name fields.ValText `json:"to_name"`
	Reply_addr fields.ValText `json:"reply_addr"`
	Reply_name fields.ValText `json:"reply_name"`
	Body fields.ValText `json:"body"`
	Sender_addr fields.ValText `json:"sender_addr"`
	Subject fields.ValText `json:"subject"`
	Sent fields.ValBool `json:"sent"`
	Sent_date_time fields.ValDateTime `json:"sent_date_time"`
	Mail_type enums.ValEnum_mail_types `json:"mail_type"`
	Error_str fields.ValText `json:"error_str"`
}

func NewModelMD_MailMessage() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(MailMessage{})),
		ID: "MailMessage_Model",
		Relation: "mail_messages",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type MailMessage_argv struct {
	Argv *MailMessage `json:"argv"`	
}

//Keys for delete/get object
type MailMessage_keys struct {
	Id fields.ValInt `json:"id"`
}
type MailMessage_keys_argv struct {
	Argv *MailMessage_keys `json:"argv"`	
}

//old keys for update
type MailMessage_old_keys struct {
	Old_id fields.ValInt `json:"old_id" required:"true"`
	Id fields.ValInt `json:"id"`
	Date_time fields.ValDateTime `json:"date_time"`
	From_addr fields.ValText `json:"from_addr"`
	From_name fields.ValText `json:"from_name"`
	To_addr fields.ValText `json:"to_addr"`
	To_name fields.ValText `json:"to_name"`
	Reply_addr fields.ValText `json:"reply_addr"`
	Reply_name fields.ValText `json:"reply_name"`
	Body fields.ValText `json:"body"`
	Sender_addr fields.ValText `json:"sender_addr"`
	Subject fields.ValText `json:"subject"`
	Sent fields.ValBool `json:"sent"`
	Sent_date_time fields.ValDateTime `json:"sent_date_time"`
	Mail_type enums.ValEnum_mail_types `json:"mail_type"`
	Error_str fields.ValText `json:"error_str"`
}

type MailMessage_old_keys_argv struct {
	Argv *MailMessage_old_keys `json:"argv"`	
}

