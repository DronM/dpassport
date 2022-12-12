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

type StudyDocumentInsertHeadList struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	User_id fields.ValInt `json:"user_id"`
	Company_id fields.ValInt `json:"company_id"`
	Companies_ref fields.ValJSON `json:"companies_ref"`
	Register_date fields.ValDate `json:"register_date" defOrder:"DESC"`
	Register_name fields.ValText `json:"register_name"`
	Register_attachment fields.ValJSON `json:"register_attachment"`
	Study_document_count fields.ValInt `json:"study_document_count"`
	Common_issue_date fields.ValDate `json:"common_issue_date"`
	Common_end_date fields.ValDate `json:"common_end_date"`
	Common_post fields.ValText `json:"common_post"`
	Common_work_place fields.ValText `json:"common_work_place"`
	Common_organization fields.ValText `json:"common_organization"`
	Common_study_type fields.ValText `json:"common_study_type"`
	Common_series fields.ValText `json:"common_series"`
	Common_study_prog_name fields.ValText `json:"common_study_prog_name"`
	Common_profession fields.ValText `json:"common_profession"`
	Common_study_period fields.ValText `json:"common_study_period"`
	Common_qualification_name fields.ValText `json:"common_qualification_name"`
	Common_study_form fields.ValText `json:"common_study_form"`
}

func (o *StudyDocumentInsertHeadList) SetNull() {
	o.Id.SetNull()
	o.User_id.SetNull()
	o.Company_id.SetNull()
	o.Companies_ref.SetNull()
	o.Register_date.SetNull()
	o.Register_name.SetNull()
	o.Register_attachment.SetNull()
	o.Study_document_count.SetNull()
	o.Common_issue_date.SetNull()
	o.Common_end_date.SetNull()
	o.Common_post.SetNull()
	o.Common_work_place.SetNull()
	o.Common_organization.SetNull()
	o.Common_study_type.SetNull()
	o.Common_series.SetNull()
	o.Common_study_prog_name.SetNull()
	o.Common_profession.SetNull()
	o.Common_study_period.SetNull()
	o.Common_qualification_name.SetNull()
	o.Common_study_form.SetNull()
}

func NewModelMD_StudyDocumentInsertHeadList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentInsertHeadList{})),
		ID: "StudyDocumentInsertHeadList_Model",
		Relation: "study_document_insert_heads_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
