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

type StudyDocumentRegister struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Name fields.ValText `json:"name"`
	Issue_date fields.ValDate `json:"issue_date"`
	Company_id fields.ValInt `json:"company_id"`
	Create_type enums.ValEnum_doc_create_types `json:"create_type"`
	Digital_sig fields.ValJSON `json:"digital_sig"`
	Create_user_id fields.ValInt `json:"create_user_id"`
	Study_form fields.ValText `json:"study_form"`
}

func (o *StudyDocumentRegister) SetNull() {
	o.Id.SetNull()
	o.Name.SetNull()
	o.Issue_date.SetNull()
	o.Company_id.SetNull()
	o.Create_type.SetNull()
	o.Digital_sig.SetNull()
	o.Create_user_id.SetNull()
	o.Study_form.SetNull()
}

func NewModelMD_StudyDocumentRegister() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentRegister{})),
		ID: "StudyDocumentRegister_Model",
		Relation: "study_document_registers",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type StudyDocumentRegister_argv struct {
	Argv *StudyDocumentRegister `json:"argv"`	
}

//Keys for delete/get object
type StudyDocumentRegister_keys struct {
	Id fields.ValInt `json:"id"`
}
type StudyDocumentRegister_keys_argv struct {
	Argv *StudyDocumentRegister_keys `json:"argv"`	
}

//old keys for update
type StudyDocumentRegister_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Name fields.ValText `json:"name"`
	Issue_date fields.ValDate `json:"issue_date"`
	Company_id fields.ValInt `json:"company_id"`
	Create_type enums.ValEnum_doc_create_types `json:"create_type"`
	Digital_sig fields.ValJSON `json:"digital_sig"`
	Create_user_id fields.ValInt `json:"create_user_id"`
	Study_form fields.ValText `json:"study_form"`
}

type StudyDocumentRegister_old_keys_argv struct {
	Argv *StudyDocumentRegister_old_keys `json:"argv"`	
}

