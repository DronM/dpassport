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

type StudyDocument_get_preview struct {
	Study_document_id fields.ValInt `json:"study_document_id" required:"true"`
}
type StudyDocument_get_preview_argv struct {
	Argv *StudyDocument_get_preview `json:"argv"`	
}

