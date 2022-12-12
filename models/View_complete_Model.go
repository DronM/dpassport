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
	"osbe/model"
	"osbe/fields"
)

type View_complete_argv struct {
	Argv *View_complete `json:"argv"`	
}

//
type View_complete struct {
	model.Complete_Model
	User_descr fields.ValText `json:"user_descr" matchField:"true" required:"true"`
}
