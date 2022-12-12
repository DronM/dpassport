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

type StudyDocumentRegister_analyze_excel struct {
	Analyze_count fields.ValInt `json:"analyze_count" required:"true"`
	Content_data fields.ValBytea `json:"content_data"`
}
type StudyDocumentRegister_analyze_excel_argv struct {
	Argv *StudyDocumentRegister_analyze_excel `json:"argv"`	
}

