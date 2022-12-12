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

type StudyDocumentRegister_upload_excel struct {
	Analyze_count fields.ValInt `json:"analyze_count" required:"true"`
	Field_order map[string]ExcelUploadFieldDescr `json:"field_order" required:"true"`
	Content_data fields.ValText `json:"content_data"`
	Company_id fields.ValInt `json:"company_id" required:"true"`
}
type StudyDocumentRegister_upload_excel_argv struct {
	Argv *StudyDocumentRegister_upload_excel `json:"argv"`	
}

