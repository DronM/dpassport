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

type User_password_recover struct {
	Email fields.ValText `json:"email" required:"true"`
	Captcha_key fields.ValText `json:"captcha_key" required:"true"`
}
type User_password_recover_argv struct {
	Argv *User_password_recover `json:"argv"`	
}

