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

type User_set_viewed struct {
	User_id fields.ValInt `json:"user_id" required:"true"`
}
type User_set_viewed_argv struct {
	Argv *User_set_viewed `json:"argv"`	
}

