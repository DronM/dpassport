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

type Company struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Name fields.ValText `json:"name" required:"true"`
	Inn fields.ValText `json:"inn" required:"true"`
	Client_id fields.ValInt `json:"client_id"`
}

func NewModelMD_Company() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(Company{})),
		ID: "Company_Model",
		Relation: "companies",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type Company_argv struct {
	Argv *Company `json:"argv"`	
}

//Keys for delete/get object
type Company_keys struct {
	Id fields.ValInt `json:"id"`
}
type Company_keys_argv struct {
	Argv *Company_keys `json:"argv"`	
}

//old keys for update
type Company_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Name fields.ValText `json:"name"`
	Inn fields.ValText `json:"inn"`
	Client_id fields.ValInt `json:"client_id"`
}

type Company_old_keys_argv struct {
	Argv *Company_old_keys `json:"argv"`	
}

