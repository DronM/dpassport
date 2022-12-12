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

type VariantStorageList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	User_id fields.ValInt `json:"user_id"`
	Storage_name fields.ValText `json:"storage_name"`
	Default_variant fields.ValBool `json:"default_variant"`
	Variant_name fields.ValText `json:"variant_name"`
}

func NewModelMD_VariantStorageList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(VariantStorageList{})),
		ID: "VariantStorageList_Model",
		Relation: "variant_storages_list",
	}
}
