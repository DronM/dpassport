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

type Constant_server_1c_value struct {
	Host string `json:"host"`
	Key string `json:"key"`
	Log_level int `json:"log_level"`
}

type Constant_server_1c struct {
	osbe.ConstantJSON
}

func New_Constant_server_1c() *Constant_server_1c {
	return &Constant_server_1c{ osbe.ConstantJSON{ID: "server_1c", Autoload: false }}
}

