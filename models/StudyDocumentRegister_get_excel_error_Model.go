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

type StudyDocumentRegister_get_excel_error struct {
	Operation_id fields.ValText `json:"operation_id" required:"true"`
}
type StudyDocumentRegister_get_excel_error_argv struct {
	Argv *StudyDocumentRegister_get_excel_error `json:"argv"`	
}

