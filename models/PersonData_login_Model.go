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
		
	//"osbe/fields"
)
type PersonData_login map[string]string
/*
type PersonData_login struct {
	Url fields.ValText `json:"url" required:"true"`
	Width_type fields.ValText `json:"width_type"`	
}
*/
type PersonData_login_argv struct {
	Argv *PersonData_login `json:"argv"`	
}

