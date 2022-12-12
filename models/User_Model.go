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

type User struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Name fields.ValText `json:"name" defOrder:"ASC"`
	Name_full fields.ValText `json:"name_full"`
	Post fields.ValText `json:"post"`
	Sex enums.ValEnum_sexes `json:"sex"`
	Birthdate fields.ValDate `json:"birthdate"`
	Snils fields.ValText `json:"snils"`
	Photo fields.ValBytea `json:"photo"`
	Role_id enums.ValEnum_role_types `json:"role_id" required:"true"`
	Pwd fields.ValText `json:"pwd"`
	Create_dt fields.ValDateTimeTZ `json:"create_dt"`
	Banned fields.ValBool `json:"banned"`
	Time_zone_locale_id fields.ValInt `json:"time_zone_locale_id"`
	Phone_cel fields.ValText `json:"phone_cel"`
	Locale_id enums.ValEnum_locales `json:"locale_id"`
	Email_confirmed fields.ValBool `json:"email_confirmed"`
	Client_id fields.ValInt `json:"client_id"`
	Company_id fields.ValInt `json:"company_id"`
	Person_url fields.ValText `json:"person_url"`
	Descr fields.ValText `json:"descr"`
	Viewed fields.ValBool `json:"viewed"`
	Qr_code fields.ValBytea `json:"qr_code"`
	Qr_code_sent_date fields.ValDateTimeTZ `json:"qr_code_sent_date"`
}

func (o *User) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
	o.Name_full.SetNull()
	o.Post.SetNull()
	o.Sex.SetNull()
	o.Birthdate.SetNull()
	o.Snils.SetNull()
	o.Photo.SetNull()
	o.Role_id.SetNull()
	o.Pwd.SetNull()
	o.Create_dt.SetNull()
	o.Banned.SetNull()
	o.Time_zone_locale_id.SetNull()
	o.Phone_cel.SetNull()
	o.Locale_id.SetNull()
	o.Email_confirmed.SetNull()
	o.Client_id.SetNull()
	o.Company_id.SetNull()
	o.Person_url.SetNull()
	o.Descr.SetNull()
	o.Viewed.SetNull()
	o.Qr_code.SetNull()
	o.Qr_code_sent_date.SetNull()
}

func NewModelMD_User() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(User{})),
		ID: "User_Model",
		Relation: "users",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type User_argv struct {
	Argv *User `json:"argv"`	
}

//Keys for delete/get object
type User_keys struct {
	Id fields.ValInt `json:"id"`
}
type User_keys_argv struct {
	Argv *User_keys `json:"argv"`	
}

//old keys for update
type User_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Name fields.ValText `json:"name"`
	Name_full fields.ValText `json:"name_full"`
	Post fields.ValText `json:"post"`
	Sex enums.ValEnum_sexes `json:"sex"`
	Birthdate fields.ValDate `json:"birthdate"`
	Snils fields.ValText `json:"snils"`
	Photo fields.ValBytea `json:"photo"`
	Role_id enums.ValEnum_role_types `json:"role_id"`
	Pwd fields.ValText `json:"pwd"`
	Create_dt fields.ValDateTimeTZ `json:"create_dt"`
	Banned fields.ValBool `json:"banned"`
	Time_zone_locale_id fields.ValInt `json:"time_zone_locale_id"`
	Phone_cel fields.ValText `json:"phone_cel"`
	Locale_id enums.ValEnum_locales `json:"locale_id"`
	Email_confirmed fields.ValBool `json:"email_confirmed"`
	Client_id fields.ValInt `json:"client_id"`
	Company_id fields.ValInt `json:"company_id"`
	Person_url fields.ValText `json:"person_url"`
	Descr fields.ValText `json:"descr"`
	Viewed fields.ValBool `json:"viewed"`
	Qr_code fields.ValBytea `json:"qr_code"`
	Qr_code_sent_date fields.ValDateTimeTZ `json:"qr_code_sent_date"`
}

type User_old_keys_argv struct {
	Argv *User_old_keys `json:"argv"`	
}

