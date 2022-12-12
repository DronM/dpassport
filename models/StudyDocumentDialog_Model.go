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

type StudyDocumentDialog struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Clients_ref fields.ValJSON `json:"clients_ref"`
	Companies_ref fields.ValJSON `json:"companies_ref"`
	Study_document_registers_ref fields.ValJSON `json:"study_document_registers_ref"`
	User_id fields.ValInt `json:"user_id"`
	Users_ref fields.ValJSON `json:"users_ref"`
	Snils fields.ValText `json:"snils"`
	Issue_date fields.ValDate `json:"issue_date"`
	End_date fields.ValDate `json:"end_date"`
	Post fields.ValText `json:"post"`
	Work_place fields.ValText `json:"work_place"`
	Organization fields.ValText `json:"organization"`
	Study_type fields.ValText `json:"study_type"`
	Series fields.ValText `json:"series"`
	Number fields.ValText `json:"number"`
	Study_prog_name fields.ValText `json:"study_prog_name"`
	Profession fields.ValText `json:"profession"`
	Reg_number fields.ValText `json:"reg_number"`
	Study_period fields.ValText `json:"study_period"`
	Name_first fields.ValText `json:"name_first"`
	Name_second fields.ValText `json:"name_second"`
	Name_middle fields.ValText `json:"name_middle"`
	Qualification_name fields.ValText `json:"qualification_name"`
	Study_form fields.ValText `json:"study_form"`
	Create_type fields.ValText `json:"create_type"`
	Digital_sig fields.ValJSON `json:"digital_sig"`
	Attachments fields.ValJSON `json:"attachments"`
	Create_user_id fields.ValInt `json:"create_user_id"`
}

func (o *StudyDocumentDialog) SetNull() {
	o.Id.SetNull()
	o.Clients_ref.SetNull()
	o.Companies_ref.SetNull()
	o.Study_document_registers_ref.SetNull()
	o.User_id.SetNull()
	o.Users_ref.SetNull()
	o.Snils.SetNull()
	o.Issue_date.SetNull()
	o.End_date.SetNull()
	o.Post.SetNull()
	o.Work_place.SetNull()
	o.Organization.SetNull()
	o.Study_type.SetNull()
	o.Series.SetNull()
	o.Number.SetNull()
	o.Study_prog_name.SetNull()
	o.Profession.SetNull()
	o.Reg_number.SetNull()
	o.Study_period.SetNull()
	o.Name_first.SetNull()
	o.Name_second.SetNull()
	o.Name_middle.SetNull()
	o.Qualification_name.SetNull()
	o.Study_form.SetNull()
	o.Create_type.SetNull()
	o.Digital_sig.SetNull()
	o.Attachments.SetNull()
	o.Create_user_id.SetNull()
}

func NewModelMD_StudyDocumentDialog() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentDialog{})),
		ID: "StudyDocumentDialog_Model",
		Relation: "study_documents_dialog",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
