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

type StudyDocumentWithPictList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	Client_id fields.ValInt `json:"client_id"`
	Clients_ref fields.ValJSON `json:"clients_ref"`
	Company_id fields.ValInt `json:"company_id"`
	Companies_ref fields.ValJSON `json:"companies_ref"`
	Study_document_register_id fields.ValInt `json:"study_document_register_id"`
	Study_document_registers_ref fields.ValJSON `json:"study_document_registers_ref"`
	User_id fields.ValInt `json:"user_id"`
	Users_ref fields.ValJSON `json:"users_ref"`
	Snils fields.ValText `json:"snils"`
	Issue_date fields.ValDate `json:"issue_date" defOrder:"DESC"`
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
	Create_type fields.ValText `json:"create_type"`
	Self_descr fields.ValText `json:"self_descr"`
	Digital_sig fields.ValJSON `json:"digital_sig"`
	Attachments fields.ValJSON `json:"attachments"`
	Name_full fields.ValText `json:"name_full"`
}

func NewModelMD_StudyDocumentWithPictList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentWithPictList{})),
		ID: "StudyDocumentWithPictList_Model",
		Relation: "study_document_with_pict_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
