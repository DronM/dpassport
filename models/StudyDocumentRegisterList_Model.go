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

type StudyDocumentRegisterList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Name fields.ValText `json:"name"`
	Issue_date fields.ValDate `json:"issue_date" defOrder:"DESC"`
	Company_id fields.ValInt `json:"company_id"`
	Companies_ref fields.ValJSON `json:"companies_ref"`
	Client_id fields.ValInt `json:"client_id"`
	Clients_ref fields.ValJSON `json:"clients_ref"`
	Create_type fields.ValText `json:"create_type"`
	Digital_sig fields.ValJSON `json:"digital_sig"`
	Self_descr fields.ValText `json:"self_descr"`
	Last_update fields.ValDateTimeTZ `json:"last_update"`
	Last_update_user fields.ValText `json:"last_update_user"`
	Create_user_id fields.ValInt `json:"create_user_id"`
	Study_document_count fields.ValInt `json:"study_document_count"`
	Organization fields.ValText `json:"organization"`
	Study_form fields.ValText `json:"study_form"`
}

func (o *StudyDocumentRegisterList) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
	o.Issue_date.SetNull()
	o.Company_id.SetNull()
	o.Companies_ref.SetNull()
	o.Client_id.SetNull()
	o.Clients_ref.SetNull()
	o.Create_type.SetNull()
	o.Digital_sig.SetNull()
	o.Self_descr.SetNull()
	o.Last_update.SetNull()
	o.Last_update_user.SetNull()
	o.Create_user_id.SetNull()
	o.Study_document_count.SetNull()
	o.Organization.SetNull()
	o.Study_form.SetNull()
}

func NewModelMD_StudyDocumentRegisterList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentRegisterList{})),
		ID: "StudyDocumentRegisterList_Model",
		Relation: "study_document_registers_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
