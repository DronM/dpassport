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

type StudyDocumentInsertAttachmentList struct {
	Id fields.ValInt `json:"id" primaryKey:"true"`
	User_id fields.ValInt `json:"user_id"`
	Study_document_insert_head_id fields.ValInt `json:"study_document_insert_head_id"`
	Name_full fields.ValText `json:"name_full" defOrder:"ASC"`
	Attachment fields.ValJSON `json:"attachment"`
}

func NewModelMD_StudyDocumentInsertAttachmentList() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentInsertAttachmentList{})),
		ID: "StudyDocumentInsertAttachmentList_Model",
		Relation: "study_document_insert_attachments_list",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
