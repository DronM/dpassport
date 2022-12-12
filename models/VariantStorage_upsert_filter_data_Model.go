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
	"reflect"
	
		
	"osbe/fields"
)

type VariantStorage_upsert_filter_data_argv struct {
	Argv *VariantStorage_upsert_filter_data `json:"argv"`	
}

//Exported model metadata
var VariantStorage_upsert_filter_data_md fields.FieldCollection

func VariantStorage_upsert_filter_data_Model_init() {	
	VariantStorage_upsert_filter_data_md = fields.GenModelMD(reflect.ValueOf(VariantStorage_upsert_filter_data{}))
}

//
type VariantStorage_upsert_filter_data struct {
	Storage_name fields.ValText `json:"storage_name" required:"true"`
	Variant_name fields.ValText `json:"variant_name" required:"true"`
	Filter_data fields.ValText `json:"filter_data" required:"true"`
	Default_variant fields.ValBool `json:"default_variant" required:"true"`
}
