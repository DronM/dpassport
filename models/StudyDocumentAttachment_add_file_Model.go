package models

/**
 * Andrey Mikhalevich 16/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 
 * !!!MODIFIED!!!
 
 */

//Controller method model
import (
	"osbe/fields"
)

//Structs described in attachments.go

type StudyDocumentAttachment_add_file struct {
	Study_documents_ref Study_documents_ref_Type `json:"study_documents_ref" required:"true"`
	Content_data fields.ValBytea `json:"content_data"`
	Content_info Content_info_Type `json:"content_info" required:"true"`
}
type StudyDocumentAttachment_add_file_argv struct {
	Argv *StudyDocumentAttachment_add_file `json:"argv"`	
}

