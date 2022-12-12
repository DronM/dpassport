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
	"transport/enums"	
	"osbe/fields"
	"osbe/model"
)

type MainMenuConstructor struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Role_id enums.ValEnum_role_types `json:"role_id" required:"true" defOrder:"ASC"`
	User_id fields.ValInt `json:"user_id"`
	Content fields.ValText `json:"content" required:"true"`
	Model_content fields.ValText `json:"model_content"`
}

func NewModelMD_MainMenuConstructor() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(MainMenuConstructor{})),
		ID: "MainMenuConstructor_Model",
		Relation: "main_menus",
	}
}
//for insert
type MainMenuConstructor_argv struct {
	Argv *MainMenuConstructor `json:"argv"`	
}

//Keys for delete/get object
type MainMenuConstructor_keys struct {
	Id fields.ValInt `json:"id"`
}
type MainMenuConstructor_keys_argv struct {
	Argv *MainMenuConstructor_keys `json:"argv"`	
}

//old keys for update
type MainMenuConstructor_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Role_id enums.ValEnum_role_types `json:"role_id"`
	User_id fields.ValInt `json:"user_id"`
	Content fields.ValText `json:"content"`
	Model_content fields.ValText `json:"model_content"`
}

type MainMenuConstructor_old_keys_argv struct {
	Argv *MainMenuConstructor_old_keys `json:"argv"`	
}

