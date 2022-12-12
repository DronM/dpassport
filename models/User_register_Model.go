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

type User_register struct {
	Name fields.ValText `json:"name" required:"true"`
	Name_full fields.ValText `json:"name_full"`
	Snils fields.ValText `json:"snils" required:"true"`
	Post fields.ValText `json:"post"`
	Sex fields.ValText `json:"sex"`
	Inn fields.ValText `json:"inn" required:"true"`
	Captcha_key fields.ValText `json:"captcha_key" required:"true"`
}
type User_register_argv struct {
	Argv *User_register `json:"argv"`	
}

