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

type Constant_client_offer struct {
	osbe.ConstantJSON
}

func New_Constant_client_offer() *Constant_client_offer {
	return &Constant_client_offer{ osbe.ConstantJSON{ID: "client_offer", Autoload: false }}
}

