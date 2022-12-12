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

type ValEnum_doc_create_types struct {
	fields.ValText
}

func (e *ValEnum_doc_create_types) GetValues() []string {
	return []string{ "manual", "upload", "api" }
}

//func (e *ValEnum_doc_create_types) GetDescriptions() map[string]map[string]string {
//	return make(map[string]{ "manual", "upload", "api" }
//}

