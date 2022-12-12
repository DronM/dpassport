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
type User_login_refresh struct {
	Refresh_token fields.ValText `json:"refresh_token"`
}
type User_login_refresh_argv struct {
	Argv *User_login_refresh `json:"argv"`	
}

