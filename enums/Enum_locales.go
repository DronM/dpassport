package enums

/**
 * Andrey Mikhalevich 16/12/21
 * This file is part of the OSBE framework
 * 
 * This file is generated from the template build/templates/scripts.go.tmpl
 * All direct modification will be lost with the next build.
 * Edit template instead.
*/

import (
	"osbe/fields"
)

type ValEnum_locales struct {
	fields.ValText
}

func (e *ValEnum_locales) GetValues() []string {
	return []string{ "ru" }
}

