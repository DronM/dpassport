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

type User_send_qrcode_email struct {
	User_id fields.ValInt `json:"user_id" required:"true"`
}
type User_send_qrcode_email_argv struct {
	Argv *User_send_qrcode_email `json:"argv"`	
}

