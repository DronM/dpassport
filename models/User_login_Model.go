package models

/**
 * Andrey Mikhalevich 16/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

//Controller method model
import (
	"osbe/fields"
)

//
type User_login struct {
	Name fields.ValText `json:"name" required:"true"`
	Name_fisrt fields.ValText `json:"name_first"`
	Name_second fields.ValText `json:"name_second"`
	Name_middle fields.ValText `json:"name_middle"`
	Post fields.ValText `json:"post"`
	Pwd fields.ValText `json:"pwd" required:"true"`
	Width_type fields.ValText `json:"width_type"`
}
type User_login_argv struct {
	Argv *User_login `json:"argv"`	
}

