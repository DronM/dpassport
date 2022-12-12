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

type Constant_api_server struct {
	osbe.ConstantJSON
}

func New_Constant_api_server() *Constant_api_server {
	return &Constant_api_server{ osbe.ConstantJSON{ID: "api_server", Autoload: false }}
}

