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

type StudyDocumentRegisterDialog struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Name fields.ValText `json:"name"`
	Issue_date fields.ValDate `json:"issue_date"`
	Companies_ref fields.ValJSON `json:"companies_ref"`
	Clients_ref fields.ValJSON `json:"clients_ref"`
	Create_type fields.ValText `json:"create_type"`
	Digital_sig fields.ValJSON `json:"digital_sig"`
	Attachments fields.ValJSON `json:"attachments"`
	Create_user_id fields.ValInt `json:"create_user_id"`
	Study_form fields.ValText `json:"study_form"`
}

func (o *StudyDocumentRegisterDialog) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
	o.Issue_date.SetNull()
	o.Companies_ref.SetNull()
	o.Clients_ref.SetNull()
	o.Create_type.SetNull()
	o.Digital_sig.SetNull()
	o.Attachments.SetNull()
	o.Create_user_id.SetNull()
	o.Study_form.SetNull()
}

func NewModelMD_StudyDocumentRegisterDialog() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentRegisterDialog{})),
		ID: "StudyDocumentRegisterDialog_Model",
		Relation: "study_document_registers_dialog",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
