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

type VariantStorage struct {
	Id fields.ValInt `json:"id" required:"true" primaryKey:"true" autoInc:"true"`
	User_id fields.ValInt `json:"user_id"`
	Storage_name fields.ValText `json:"storage_name" required:"true"`
	Variant_name fields.ValText `json:"variant_name" required:"true"`
	Default_variant fields.ValBool `json:"default_variant"`
	Filter_data fields.ValJSON `json:"filter_data"`
	Col_visib_data fields.ValText `json:"col_visib_data"`
	Col_order_data fields.ValText `json:"col_order_data"`
}

func NewModelMD_VariantStorage() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(VariantStorage{})),
		ID: "VariantStorage_Model",
		Relation: "variant_storages",
	}
}
//for insert
type VariantStorage_argv struct {
	Argv *VariantStorage `json:"argv"`	
}

//Keys for delete/get object
type VariantStorage_keys struct {
	Id fields.ValInt `json:"id"`
}
type VariantStorage_keys_argv struct {
	Argv *VariantStorage_keys `json:"argv"`	
}

//old keys for update
type VariantStorage_old_keys struct {
	Old_id fields.ValInt `json:"old_id" required:"true"`
	Id fields.ValInt `json:"id"`
	User_id fields.ValInt `json:"user_id"`
	Storage_name fields.ValText `json:"storage_name"`
	Variant_name fields.ValText `json:"variant_name"`
	Default_variant fields.ValBool `json:"default_variant"`
	Filter_data fields.ValJSON `json:"filter_data"`
	Col_visib_data fields.ValText `json:"col_visib_data"`
	Col_order_data fields.ValText `json:"col_order_data"`
}

type VariantStorage_old_keys_argv struct {
	Argv *VariantStorage_old_keys `json:"argv"`	
}

