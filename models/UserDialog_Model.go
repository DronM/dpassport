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

type UserDialog struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Name fields.ValText `json:"name"`
	Name_full fields.ValText `json:"name_full"`
	Snils fields.ValText `json:"snils"`
	Post fields.ValText `json:"post"`
	Sex fields.ValText `json:"sex"`
	Photo fields.ValJSON `json:"photo"`
	Role_id fields.ValText `json:"role_id"`
	Create_dt fields.ValDateTimeTZ `json:"create_dt"`
	Banned fields.ValBool `json:"banned"`
	Time_zone_locales_ref fields.ValJSON `json:"time_zone_locales_ref"`
	Phone_cel fields.ValText `json:"phone_cel"`
	Tel_ext fields.ValText `json:"tel_ext"`
	Locale_id fields.ValText `json:"locale_id"`
	Email_confirmed fields.ValBool `json:"email_confirmed"`
	Clients_ref fields.ValJSON `json:"clients_ref"`
	Companies_ref fields.ValJSON `json:"companies_ref"`
	Company_id fields.ValText `json:"company_id"`
	Viewed fields.ValBool `json:"viewed"`
	Qr_code fields.ValText `json:"qr_code"`
}

func (o *UserDialog) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
	o.Name_full.SetNull()
	o.Snils.SetNull()
	o.Post.SetNull()
	o.Sex.SetNull()
	o.Photo.SetNull()
	o.Role_id.SetNull()
	o.Create_dt.SetNull()
	o.Banned.SetNull()
	o.Time_zone_locales_ref.SetNull()
	o.Phone_cel.SetNull()
	o.Tel_ext.SetNull()
	o.Locale_id.SetNull()
	o.Email_confirmed.SetNull()
	o.Clients_ref.SetNull()
	o.Companies_ref.SetNull()
	o.Company_id.SetNull()
	o.Viewed.SetNull()
	o.Qr_code.SetNull()
}

func NewModelMD_UserDialog() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserDialog{})),
		ID: "UserDialog_Model",
		Relation: "users_dialog",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
