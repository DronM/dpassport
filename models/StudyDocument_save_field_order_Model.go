package models

/**
 * Andrey Mikhalevich 16/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

//Controller method model
import (
		
	"osbe/fields"
)

type StudyDocument_save_field_order struct {
	Analyze_count fields.ValInt `json:"analyze_count" required:"true"`
	Field_order map[string]ExcelUploadFieldDescr `json:"field_order" required:"true"`
}
type StudyDocument_save_field_order_argv struct {
	Argv *StudyDocument_save_field_order `json:"argv"`	
}

