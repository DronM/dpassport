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

type ValEnum_vehicle_type struct {
	fields.ValText
}

func (e *ValEnum_vehicle_type) GetValues() []string {
	return []string{ "owned", "hired" }
}

//func (e *ValEnum_vehicle_type) GetDescriptions() map[string]map[string]string {
//	return make(map[string]{ "owned", "hired" }
//}

