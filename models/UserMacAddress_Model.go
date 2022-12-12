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

type UserMacAddress struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	User_id fields.ValInt `json:"user_id"`
	Mac_address fields.ValText `json:"mac_address" required:"true"`
	Mac_address_hash fields.ValText `json:"mac_address_hash"`
}

func NewModelMD_UserMacAddress() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserMacAddress{})),
		ID: "UserMacAddress_Model",
		Relation: "user_mac_addresses",
	}
}
//for insert
type UserMacAddress_argv struct {
	Argv *UserMacAddress `json:"argv"`	
}

//Keys for delete/get object
type UserMacAddress_keys struct {
	Id fields.ValInt `json:"id"`
}
type UserMacAddress_keys_argv struct {
	Argv *UserMacAddress_keys `json:"argv"`	
}

//old keys for update
type UserMacAddress_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	User_id fields.ValInt `json:"user_id"`
	Mac_address fields.ValText `json:"mac_address"`
	Mac_address_hash fields.ValText `json:"mac_address_hash"`
}

type UserMacAddress_old_keys_argv struct {
	Argv *UserMacAddress_old_keys `json:"argv"`	
}

