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
type User_login_token struct {
	Token fields.ValText `json:"token"`
}
type User_login_token_argv struct {
	Argv *User_login_token `json:"argv"`	
}

