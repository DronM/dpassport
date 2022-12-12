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

type Client_check_for_register struct {
	Inn fields.ValText `json:"inn" required:"true"`
	Captcha_key fields.ValText `json:"captcha_key" required:"true"`
}
type Client_check_for_register_argv struct {
	Argv *Client_check_for_register `json:"argv"`	
}

