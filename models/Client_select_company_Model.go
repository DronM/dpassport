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

type Client_select_company struct {
	Parent_id fields.ValInt `json:"parent_id" required:"true"`
}
type Client_select_company_argv struct {
	Argv *Client_select_company `json:"argv"`	
}

