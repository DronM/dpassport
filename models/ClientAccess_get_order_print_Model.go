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

type ClientAccess_get_order_print struct {
	Client_access_id fields.ValInt `json:"client_access_id" required:"true"`
	Q_id fields.ValText `json:"q_id" required:"true"`
}
type ClientAccess_get_order_print_argv struct {
	Argv *ClientAccess_get_order_print `json:"argv"`	
}

