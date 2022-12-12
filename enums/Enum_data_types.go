package enums

/**
 * Andrey Mikhalevich 16/12/21
 * This file is part of the OSBE framework
 * 
 * This file is generated from the template build/templates/enum.go.tmpl
 * All direct modification will be lost with the next build.
 * Edit template instead.
*/

import (
	"osbe/fields"
)

type ValEnum_data_types struct {
	fields.ValText
}

func (e *ValEnum_data_types) GetValues() []string {
	return []string{ "users", "study_document_types", "client_accesses", "clients", "study_document_registers", "study_documents", "study_document_attachments" }
}

//func (e *ValEnum_data_types) GetDescriptions() map[string]map[string]string {
//	return make(map[string]{ "users", "study_document_types", "client_accesses", "clients", "study_document_registers", "study_documents", "study_document_attachments" }
//}

