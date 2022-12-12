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

type UserOperationDialog struct {
	User_id fields.ValInt `json:"user_id" required:"true" primaryKey:"true"`
	Operation_id fields.ValText `json:"operation_id" required:"true" primaryKey:"true"`
	Operation fields.ValText `json:"operation"`
	Status fields.ValText `json:"status"`
	Date_time fields.ValDateTimeTZ `json:"date_time"`
	Error_text fields.ValText `json:"error_text"`
	Comment_text fields.ValText `json:"comment_text"`
	Date_time_end fields.ValDateTimeTZ `json:"date_time_end"`
	File_content_exists fields.ValBool `json:"file_content_exists"`
}

func NewModelMD_UserOperationDialog() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserOperationDialog{})),
		ID: "UserOperationDialog_Model",
		Relation: "user_operations_dialog",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
