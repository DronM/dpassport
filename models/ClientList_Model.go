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

type ClientList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`	
	Active fields.ValBool `json:"active" defOrder:"DESC" defOrderIndex:"1"`
	Name fields.ValText `json:"name" defOrder:"ASC" defOrderIndex:"2"`
	Inn fields.ValText `json:"inn"`
	Ogrn fields.ValText `json:"ogrn"`
	Parent_id fields.ValInt `json:"parent_id"`
	Parents_ref fields.ValJSON `json:"parents_ref"`
	Last_update fields.ValDateTimeTZ `json:"last_update"`
	Last_update_user fields.ValText `json:"last_update_user"`
	Viewed fields.ValBool `json:"viewed" defOrder:"ASC" defOrderIndex:"0"`
	Create_user_id fields.ValInt `json:"create_user_id"`
	No_parent fields.ValBool `json:"no_parent"`
}

func (o *ClientList) SetNull() {
	o.Id.SetNull()
	o.Viewed.SetNull()
	o.Active.SetNull()
	o.Name.SetNull()
	o.Inn.SetNull()
	o.Ogrn.SetNull()
	o.Parent_id.SetNull()
	o.Parents_ref.SetNull()
	o.Last_update.SetNull()
	o.Last_update_user.SetNull()
	o.No_parent.SetNull()
}

func NewModelMD_ClientList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(ClientList{})),
		ID: "ClientList_Model",
		Relation: "clients_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
