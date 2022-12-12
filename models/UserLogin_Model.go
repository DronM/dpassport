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

type UserLogin struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Name fields.ValText `json:"name"`
	Name_full fields.ValText `json:"name_full"`
	Snils fields.ValText `json:"snils"`
	Post fields.ValText `json:"post"`
	Sex fields.ValText `json:"sex"`
	Role_id fields.ValText `json:"role_id"`
	Create_dt fields.ValDateTimeTZ `json:"create_dt"`
	Banned fields.ValBool `json:"banned"`
	Time_zone_locales_ref fields.ValJSON `json:"time_zone_locales_ref"`
	Phone_cel fields.ValText `json:"phone_cel"`
	Tel_ext fields.ValText `json:"tel_ext"`
	Locale_id fields.ValText `json:"locale_id"`
	Email_confirmed fields.ValBool `json:"email_confirmed"`
	Pwd fields.ValText `json:"pwd"`
	Ban_hash fields.ValText `json:"ban_hash"`
	Person_url fields.ValText `json:"person_url"`
	Client_id fields.ValInt `json:"client_id"`
	Company_id fields.ValInt `json:"company_id"`
	Company_descr fields.ValText `json:"company_descr"`
	Client_banned fields.ValBool `json:"client_banned"`
	Descr fields.ValText `json:"descr"`
}

func (o *UserLogin) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
	o.Name_full.SetNull()
	o.Snils.SetNull()
	o.Post.SetNull()
	o.Sex.SetNull()
	o.Role_id.SetNull()
	o.Create_dt.SetNull()
	o.Banned.SetNull()
	o.Time_zone_locales_ref.SetNull()
	o.Phone_cel.SetNull()
	o.Tel_ext.SetNull()
	o.Locale_id.SetNull()
	o.Email_confirmed.SetNull()
	o.Pwd.SetNull()
	o.Ban_hash.SetNull()
	o.Person_url.SetNull()
	o.Client_id.SetNull()
	o.Company_id.SetNull()
	o.Company_descr.SetNull()
	o.Client_banned.SetNull()
	o.Descr.SetNull()
}

func NewModelMD_UserLogin() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserLogin{})),
		ID: "UserLogin_Model",
		Relation: "users_login",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
