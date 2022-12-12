package constants

/**
 * Andrey Mikhalevich 20/12/21
 * This file is part of the OSBE framework
 * 
 * This file is generated from the template build/templates/constant.go.tmpl
 * All direct modification will be lost with the next build.
 * Edit template instead.
*/

import (
	"osbe"
)

type Constant_study_document_fields struct {
	osbe.ConstantJSON
}

func New_Constant_study_document_fields() *Constant_study_document_fields {
	return &Constant_study_document_fields{ osbe.ConstantJSON{ID: "study_document_fields", Autoload: false }}
}

