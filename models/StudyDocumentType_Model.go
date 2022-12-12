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

type StudyDocumentType struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Name fields.ValText `json:"name" defOrder:"ASC"`
}

func NewModelMD_StudyDocumentType() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentType{})),
		ID: "StudyDocumentType_Model",
		Relation: "study_document_types",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type StudyDocumentType_argv struct {
	Argv *StudyDocumentType `json:"argv"`	
}

//Keys for delete/get object
type StudyDocumentType_keys struct {
	Id fields.ValInt `json:"id"`
}
type StudyDocumentType_keys_argv struct {
	Argv *StudyDocumentType_keys `json:"argv"`	
}

//old keys for update
type StudyDocumentType_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Name fields.ValText `json:"name"`
}

type StudyDocumentType_old_keys_argv struct {
	Argv *StudyDocumentType_old_keys `json:"argv"`	
}

