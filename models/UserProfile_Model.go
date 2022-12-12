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

type UserProfile struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Name fields.ValText `json:"name"`
	Name_full fields.ValText `json:"name_full"`
	Snils fields.ValText `json:"snils"`
	Post fields.ValText `json:"post"`
	Sex fields.ValText `json:"sex"`
	Phone_cel fields.ValText `json:"phone_cel"`
	Locale_id fields.ValText `json:"locale_id"`
	Time_zone_locales_ref fields.ValJSON `json:"time_zone_locales_ref"`
	Person_url fields.ValText `json:"person_url"`
	Companies_ref fields.ValJSON `json:"companies_ref"`
	Qr_code fields.ValText `json:"qr_code"`
}

func (o *UserProfile) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
	o.Name_full.SetNull()
	o.Snils.SetNull()
	o.Post.SetNull()
	o.Sex.SetNull()
	o.Phone_cel.SetNull()
	o.Locale_id.SetNull()
	o.Time_zone_locales_ref.SetNull()
	o.Person_url.SetNull()
	o.Companies_ref.SetNull()
	o.Qr_code.SetNull()
}

func NewModelMD_UserProfile() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserProfile{})),
		ID: "UserProfile_Model",
		Relation: "users_profile",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
