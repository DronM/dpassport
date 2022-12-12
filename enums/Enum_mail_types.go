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

type ValEnum_mail_types struct {
	fields.ValText
}

func (e *ValEnum_mail_types) GetValues() []string {
	return []string{ "person_register", "password_recover", "admin_1_register", "client_activation", "client_expiration" }
}

//func (e *ValEnum_mail_types) GetDescriptions() map[string]map[string]string {
//	return make(map[string]{ "person_register", "password_recover", "admin_1_register", "client_activation", "client_expiration" }
//}

