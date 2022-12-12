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

type UserOperation struct {
	User_id fields.ValInt `json:"user_id" required:"true" primaryKey:"true"`
	Operation_id fields.ValText `json:"operation_id" required:"true" primaryKey:"true"`
	Operation fields.ValText `json:"operation"`
	Status fields.ValText `json:"status"`
	Date_time fields.ValDateTimeTZ `json:"date_time"`
	Error_text fields.ValText `json:"error_text"`
	Comment_text fields.ValText `json:"comment_text"`
	Date_time_end fields.ValDateTimeTZ `json:"date_time_end"`
	File_content fields.ValBytea `json:"file_content"`
}

func NewModelMD_UserOperation() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserOperation{})),
		ID: "UserOperation_Model",
		Relation: "user_operations",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type UserOperation_argv struct {
	Argv *UserOperation `json:"argv"`	
}

//Keys for delete/get object
type UserOperation_keys struct {
	User_id fields.ValInt `json:"user_id"`
	Operation_id fields.ValText `json:"operation_id"`
}
type UserOperation_keys_argv struct {
	Argv *UserOperation_keys `json:"argv"`	
}

//old keys for update
type UserOperation_old_keys struct {
	Old_user_id fields.ValInt `json:"old_user_id" required:"true"`
	User_id fields.ValInt `json:"user_id"`
	Old_operation_id fields.ValText `json:"old_operation_id" required:"true"`
	Operation_id fields.ValText `json:"operation_id"`
	Operation fields.ValText `json:"operation"`
	Status fields.ValText `json:"status"`
	Date_time fields.ValDateTimeTZ `json:"date_time"`
	Error_text fields.ValText `json:"error_text"`
	Comment_text fields.ValText `json:"comment_text"`
	Date_time_end fields.ValDateTimeTZ `json:"date_time_end"`
	File_content fields.ValBytea `json:"file_content"`
}

type UserOperation_old_keys_argv struct {
	Argv *UserOperation_old_keys `json:"argv"`	
}

