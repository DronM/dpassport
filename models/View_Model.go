package models

/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

import (
	"reflect"	
		
	"osbe/fields"
	"osbe/model"
)

type View struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	C fields.ValText `json:"c"`
	F fields.ValText `json:"f"`
	T fields.ValText `json:"t"`
	Section fields.ValText `json:"section" required:"true" defOrder:"ASC"`
	Descr fields.ValText `json:"descr" required:"true" defOrder:"ASC"`
	Limited fields.ValBool `json:"limited"`
}

func NewModelMD_View() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(View{})),
		ID: "View_Model",
		Relation: "views",
	}
}
//for insert
type View_argv struct {
	Argv *View `json:"argv"`	
}

//Keys for delete/get object
type View_keys struct {
	Id fields.ValInt `json:"id"`
}
type View_keys_argv struct {
	Argv *View_keys `json:"argv"`	
}

//old keys for update
type View_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	C fields.ValText `json:"c"`
	F fields.ValText `json:"f"`
	T fields.ValText `json:"t"`
	Section fields.ValText `json:"section"`
	Descr fields.ValText `json:"descr"`
	Limited fields.ValBool `json:"limited"`
}

type View_old_keys_argv struct {
	Argv *View_old_keys `json:"argv"`	
}

