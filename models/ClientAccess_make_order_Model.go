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

type ClientAccess_make_order struct {
	Client_access_id fields.ValInt `json:"client_access_id" required:"true"`
	Q_id fields.ValText `json:"q_id" required:"true"`
}
type ClientAccess_make_order_argv struct {
	Argv *ClientAccess_make_order `json:"argv"`	
}

