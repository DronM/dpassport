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

type StudyForm struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Name fields.ValText `json:"name"`
}

func (o *StudyForm) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
}

func NewModelMD_StudyForm() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyForm{})),
		ID: "StudyForm_Model",
		Relation: "study_forms",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type StudyForm_argv struct {
	Argv *StudyForm `json:"argv"`	
}

//Keys for delete/get object
type StudyForm_keys struct {
	Id fields.ValInt `json:"id"`
}
type StudyForm_keys_argv struct {
	Argv *StudyForm_keys `json:"argv"`	
}

//old keys for update
type StudyForm_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Name fields.ValText `json:"name"`
}

type StudyForm_old_keys_argv struct {
	Argv *StudyForm_old_keys `json:"argv"`	
}

