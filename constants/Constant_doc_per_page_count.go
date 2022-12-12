package constants

/**
 * Andrey Mikhalevich 20/12/21
 * This file is part of the OSBE framework
 * 
 * This file is generated from the template build/templates/.go.tmpl
 * All direct modification will be lost with the next build.
 * Edit template instead.
*/

import (
	"osbe"
)

type Constant_doc_per_page_count struct {
	osbe.ConstantInt
}

func New_Constant_doc_per_page_count() *Constant_doc_per_page_count {
	return &Constant_doc_per_page_count{osbe.ConstantInt{ID: "doc_per_page_count", Autoload: true}}
}
