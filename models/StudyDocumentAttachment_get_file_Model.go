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

type StudyDocumentAttachment_get_file struct {
	Study_documents_ref Study_documents_ref_Type `json:"study_documents_ref" required:"true"`
	Content_id fields.ValText `json:"content_id" required:"true"`
	Inline fields.ValInt `json:"inline"`
}
type StudyDocumentAttachment_get_file_argv struct {
	Argv *StudyDocumentAttachment_get_file `json:"argv"`	
}

