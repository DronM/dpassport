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

type Client struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Name fields.ValText `json:"name" required:"true"`
	Inn fields.ValText `json:"inn" required:"true"`
	Name_full fields.ValText `json:"name_full"`
	Legal_address fields.ValText `json:"legal_address"`
	Post_address fields.ValText `json:"post_address"`
	Kpp fields.ValText `json:"kpp"`
	Ogrn fields.ValText `json:"ogrn"`
	Okpo fields.ValText `json:"okpo"`
	Okved fields.ValText `json:"okved"`
	Email fields.ValText `json:"email"`
	Tel fields.ValText `json:"tel"`
	Parent_id fields.ValInt `json:"parent_id"`
	Viewed fields.ValBool `json:"viewed"`
	Create_user_id fields.ValInt `json:"create_user_id"`
}

func (o *Client) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
	o.Inn.SetNull()
	o.Name_full.SetNull()
	o.Legal_address.SetNull()
	o.Post_address.SetNull()
	o.Kpp.SetNull()
	o.Ogrn.SetNull()
	o.Okpo.SetNull()
	o.Okved.SetNull()
	o.Email.SetNull()
	o.Tel.SetNull()
	o.Parent_id.SetNull()
	o.Viewed.SetNull()
	o.Create_user_id.SetNull()
}

func NewModelMD_Client() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(Client{})),
		ID: "Client_Model",
		Relation: "clients",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type Client_argv struct {
	Argv *Client `json:"argv"`	
}

//Keys for delete/get object
type Client_keys struct {
	Id fields.ValInt `json:"id"`
}
type Client_keys_argv struct {
	Argv *Client_keys `json:"argv"`	
}

//old keys for update
type Client_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Name fields.ValText `json:"name"`
	Inn fields.ValText `json:"inn"`
	Name_full fields.ValText `json:"name_full"`
	Legal_address fields.ValText `json:"legal_address"`
	Post_address fields.ValText `json:"post_address"`
	Kpp fields.ValText `json:"kpp"`
	Ogrn fields.ValText `json:"ogrn"`
	Okpo fields.ValText `json:"okpo"`
	Okved fields.ValText `json:"okved"`
	Email fields.ValText `json:"email"`
	Tel fields.ValText `json:"tel"`
	Parent_id fields.ValInt `json:"parent_id"`
	Viewed fields.ValBool `json:"viewed"`
	Create_user_id fields.ValInt `json:"create_user_id"`
}

type Client_old_keys_argv struct {
	Argv *Client_old_keys `json:"argv"`	
}

