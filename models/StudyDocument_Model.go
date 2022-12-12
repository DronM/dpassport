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

type StudyDocument struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Company_id fields.ValInt `json:"company_id"`
	Study_document_register_id fields.ValInt `json:"study_document_register_id"`
	User_id fields.ValInt `json:"user_id"`
	Snils fields.ValText `json:"snils" required:"true"`
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
	Create_type enums.ValEnum_doc_create_types `json:"create_type"`
	Digital_sig fields.ValJSON `json:"digital_sig"`
	Name_full fields.ValText `json:"name_full"`
	Create_user_id fields.ValInt `json:"create_user_id"`
	Study_form fields.ValText `json:"study_form"`
}

func (o *StudyDocument) SetNull() {
	o.Id.SetNull()
	o.Company_id.SetNull()
	o.Study_document_register_id.SetNull()
	o.User_id.SetNull()
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
	o.Create_type.SetNull()
	o.Digital_sig.SetNull()
	o.Name_full.SetNull()
	o.Create_user_id.SetNull()
	o.Study_form.SetNull()
}

func NewModelMD_StudyDocument() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocument{})),
		ID: "StudyDocument_Model",
		Relation: "study_documents",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type StudyDocument_argv struct {
	Argv *StudyDocument `json:"argv"`	
}

//Keys for delete/get object
type StudyDocument_keys struct {
	Id fields.ValInt `json:"id"`
}
type StudyDocument_keys_argv struct {
	Argv *StudyDocument_keys `json:"argv"`	
}

//old keys for update
type StudyDocument_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Company_id fields.ValInt `json:"company_id"`
	Study_document_register_id fields.ValInt `json:"study_document_register_id"`
	User_id fields.ValInt `json:"user_id"`
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
	Create_type enums.ValEnum_doc_create_types `json:"create_type"`
	Digital_sig fields.ValJSON `json:"digital_sig"`
	Name_full fields.ValText `json:"name_full"`
	Create_user_id fields.ValInt `json:"create_user_id"`
	Study_form fields.ValText `json:"study_form"`
}

type StudyDocument_old_keys_argv struct {
	Argv *StudyDocument_old_keys `json:"argv"`	
}

