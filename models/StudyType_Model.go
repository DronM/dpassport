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

type StudyType struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Name fields.ValText `json:"name"`
}

func (o *StudyType) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
}

func NewModelMD_StudyType() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyType{})),
		ID: "StudyType_Model",
		Relation: "study_types",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type StudyType_argv struct {
	Argv *StudyType `json:"argv"`	
}

//Keys for delete/get object
type StudyType_keys struct {
	Id fields.ValInt `json:"id"`
}
type StudyType_keys_argv struct {
	Argv *StudyType_keys `json:"argv"`	
}

//old keys for update
type StudyType_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Name fields.ValText `json:"name"`
}

type StudyType_old_keys_argv struct {
	Argv *StudyType_old_keys `json:"argv"`	
}

