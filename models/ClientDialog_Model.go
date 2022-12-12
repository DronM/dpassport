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

type ClientDialog struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
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
	Parents_ref fields.ValJSON `json:"parents_ref"`
	Parent_id fields.ValInt `json:"parent_id"`
	Viewed fields.ValBool `json:"viewed"`
	Create_user_id fields.ValInt `json:"create_user_id"`
}

func (o *ClientDialog) SetNull() {
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
	o.Parents_ref.SetNull()
	o.Parent_id.SetNull()
	o.Viewed.SetNull()
	o.Create_user_id.SetNull()
}

func NewModelMD_ClientDialog() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(ClientDialog{})),
		ID: "ClientDialog_Model",
		Relation: "clients_dialog",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
