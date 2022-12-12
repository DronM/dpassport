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

type TimeZoneLocale struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Descr fields.ValText `json:"descr" required:"true"`
	Name fields.ValText `json:"name" required:"true"`
	Hour_dif fields.ValFloat `json:"hour_dif" required:"true"`
}

func NewModelMD_TimeZoneLocale() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(TimeZoneLocale{})),
		ID: "TimeZoneLocale_Model",
		Relation: "time_zone_locales",
	}
}
//for insert
type TimeZoneLocale_argv struct {
	Argv *TimeZoneLocale `json:"argv"`	
}

//Keys for delete/get object
type TimeZoneLocale_keys struct {
	Id fields.ValInt `json:"id"`
}
type TimeZoneLocale_keys_argv struct {
	Argv *TimeZoneLocale_keys `json:"argv"`	
}

//old keys for update
type TimeZoneLocale_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Descr fields.ValText `json:"descr"`
	Name fields.ValText `json:"name"`
	Hour_dif fields.ValFloat `json:"hour_dif"`
}

type TimeZoneLocale_old_keys_argv struct {
	Argv *TimeZoneLocale_old_keys `json:"argv"`	
}

