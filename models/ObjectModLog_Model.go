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
	"dpassport/enums"	
	"osbe/fields"
	"osbe/model"
)

type ObjectModLog struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Object_type enums.ValEnum_data_types `json:"object_type" required:"true"`
	Object_id fields.ValInt `json:"object_id" required:"true"`
	Object_descr fields.ValText `json:"object_descr" required:"true"`
	User_descr fields.ValText `json:"user_descr"`
	Date_time fields.ValDateTimeTZ `json:"date_time" defOrder:"DESC"`
	Action enums.ValEnum_object_mod_actions `json:"action"`
	Details fields.ValText `json:"details"`
}

func NewModelMD_ObjectModLog() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(ObjectModLog{})),
		ID: "ObjectModLog_Model",
		Relation: "object_mod_log",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type ObjectModLog_argv struct {
	Argv *ObjectModLog `json:"argv"`	
}

//Keys for delete/get object
type ObjectModLog_keys struct {
	Id fields.ValInt `json:"id"`
}
type ObjectModLog_keys_argv struct {
	Argv *ObjectModLog_keys `json:"argv"`	
}

//old keys for update
type ObjectModLog_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Object_type enums.ValEnum_data_types `json:"object_type"`
	Object_id fields.ValInt `json:"object_id"`
	Object_descr fields.ValText `json:"object_descr"`
	User_descr fields.ValText `json:"user_descr"`
	Date_time fields.ValDateTimeTZ `json:"date_time"`
	Action enums.ValEnum_object_mod_actions `json:"action"`
	Details fields.ValText `json:"details"`
}

type ObjectModLog_old_keys_argv struct {
	Argv *ObjectModLog_old_keys `json:"argv"`	
}

