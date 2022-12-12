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

const MainMenuConstructorDialog_DATA_TABLE = "main_menus_dialog"

//
type MainMenuConstructorDialog struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Role_id fields.ValText `json:"role_id"`
	User_id fields.ValText `json:"user_id"`
	User_descr fields.ValText `json:"user_descr"`
	Content fields.ValText `json:"content"`
}

func NewModelMD_MainMenuConstructorDialog() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(MainMenuConstructorDialog{})),
		ID: "MainMenuConstructorDialog_Model",
		Relation: MainMenuConstructorDialog_DATA_TABLE,
	}
}

