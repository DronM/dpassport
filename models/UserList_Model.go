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

type UserList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Viewed fields.ValBool `json:"viewed" defOrder:"ASC"`
	Name fields.ValText `json:"name"`
	Name_full fields.ValText `json:"name_full" defOrder:"ASC"`
	Snils fields.ValText `json:"snils"`
	Post fields.ValText `json:"post"`
	Sex fields.ValText `json:"sex"`
	Role_id enums.ValEnum_role_types `json:"role_id"`
	Phone_cel fields.ValText `json:"phone_cel"`
	Tel_ext fields.ValText `json:"tel_ext"`
	Clients_ref fields.ValJSON `json:"clients_ref"`
	Client_id fields.ValInt `json:"client_id"`
	Companies_ref fields.ValJSON `json:"companies_ref"`
	Company_id fields.ValInt `json:"company_id"`
	Person_url fields.ValText `json:"person_url"`
	Descr fields.ValText `json:"descr"`
	Last_update fields.ValDateTimeTZ `json:"last_update"`
	Last_update_user fields.ValText `json:"last_update_user"`
	Qr_code_sent_date fields.ValDateTimeTZ `json:"qr_code_sent_date"`
	Banned fields.ValBool `json:"banned"`
}

func (o *UserList) SetNull() {
	o.Id.SetNull()
	o.Viewed.SetNull()
	o.Name.SetNull()
	o.Name_full.SetNull()
	o.Snils.SetNull()
	o.Post.SetNull()
	o.Sex.SetNull()
	o.Role_id.SetNull()
	o.Phone_cel.SetNull()
	o.Tel_ext.SetNull()
	o.Clients_ref.SetNull()
	o.Client_id.SetNull()
	o.Companies_ref.SetNull()
	o.Company_id.SetNull()
	o.Person_url.SetNull()
	o.Descr.SetNull()
	o.Last_update.SetNull()
	o.Last_update_user.SetNull()
	o.Qr_code_sent_date.SetNull()
	o.Banned.SetNull()
}

func NewModelMD_UserList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(UserList{})),
		ID: "UserList_Model",
		Relation: "users_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
