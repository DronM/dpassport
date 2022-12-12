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

type StudyDocumentInsert struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Study_document_insert_head_id fields.ValInt `json:"study_document_insert_head_id"`
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
}

func (o *StudyDocumentInsert) SetNull() {
	o.Id.SetNull()
	o.Study_document_insert_head_id.SetNull()
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
}

func NewModelMD_StudyDocumentInsert() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentInsert{})),
		ID: "StudyDocumentInsert_Model",
		Relation: "study_document_inserts",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type StudyDocumentInsert_argv struct {
	Argv *StudyDocumentInsert `json:"argv"`	
}

//Keys for delete/get object
type StudyDocumentInsert_keys struct {
	Id fields.ValInt `json:"id"`
}
type StudyDocumentInsert_keys_argv struct {
	Argv *StudyDocumentInsert_keys `json:"argv"`	
}

//old keys for update
type StudyDocumentInsert_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Study_document_insert_head_id fields.ValInt `json:"study_document_insert_head_id"`
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
}

type StudyDocumentInsert_old_keys_argv struct {
	Argv *StudyDocumentInsert_old_keys `json:"argv"`	
}

