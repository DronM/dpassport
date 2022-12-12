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

type Client_update_attrs struct {
	Name fields.ValText `json:"name"`
	Name_full fields.ValText `json:"name_full"`
	Legal_address fields.ValText `json:"legal_address"`
	Post_address fields.ValText `json:"post_address"`
	Kpp fields.ValText `json:"kpp"`
	Ogrn fields.ValText `json:"ogrn"`
	Okpo fields.ValText `json:"okpo"`
	Okved fields.ValText `json:"okved"`
}
type Client_update_attrs_argv struct {
	Argv *Client_update_attrs `json:"argv"`	
}

