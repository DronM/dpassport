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

type StudyDocumentInsertHead_close struct {
	Study_document_insert_head_id fields.ValInt `json:"study_document_insert_head_id" required:"true"`
}
type StudyDocumentInsertHead_close_argv struct {
	Argv *StudyDocumentInsertHead_close `json:"argv"`	
}

