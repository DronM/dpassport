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

type Profession struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Name fields.ValText `json:"name"`
}

func (o *Profession) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
}

func NewModelMD_Profession() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(Profession{})),
		ID: "Profession_Model",
		Relation: "professions",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type Profession_argv struct {
	Argv *Profession `json:"argv"`	
}

//Keys for delete/get object
type Profession_keys struct {
	Id fields.ValInt `json:"id"`
}
type Profession_keys_argv struct {
	Argv *Profession_keys `json:"argv"`	
}

//old keys for update
type Profession_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Name fields.ValText `json:"name"`
}

type Profession_old_keys_argv struct {
	Argv *Profession_old_keys `json:"argv"`	
}

