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

type ClientSearch_search struct {
	Query fields.ValText `json:"query" required:"true"`
}
type ClientSearch_search_argv struct {
	Argv *ClientSearch_search `json:"argv"`	
}

