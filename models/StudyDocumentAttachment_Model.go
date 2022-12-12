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

type StudyDocumentAttachment struct {
	Id fields.ValInt `json:"id" primaryKey:"true" autoInc:"true"`
	Date_time fields.ValDateTimeTZ `json:"date_time"`
	Study_documents_ref fields.ValJSON `json:"study_documents_ref"`
	Content_info fields.ValJSON `json:"content_info"`
	Content_data fields.ValBytea `json:"content_data"`
	Content_preview fields.ValBytea `json:"content_preview"`
}

func NewModelMD_StudyDocumentAttachment() *model.ModelMD{
	return &model.ModelMD{Fields: fields.GenModelMD(reflect.ValueOf(StudyDocumentAttachment{})),
		ID: "StudyDocumentAttachment_Model",
		Relation: "study_document_attachments",
		AggFunctions: []*model.AggFunction{
			&model.AggFunction{Alias: "totalCount", Expr: "count(*)"},
		},
		LimitConstant: "doc_per_page_count",
	}
}
//for insert
type StudyDocumentAttachment_argv struct {
	Argv *StudyDocumentAttachment `json:"argv"`	
}

//Keys for delete/get object
type StudyDocumentAttachment_keys struct {
	Id fields.ValInt `json:"id"`
}
type StudyDocumentAttachment_keys_argv struct {
	Argv *StudyDocumentAttachment_keys `json:"argv"`	
}

//old keys for update
type StudyDocumentAttachment_old_keys struct {
	Old_id fields.ValInt `json:"old_id"`
	Id fields.ValInt `json:"id"`
	Date_time fields.ValDateTimeTZ `json:"date_time"`
	Study_documents_ref fields.ValJSON `json:"study_documents_ref"`
	Content_info fields.ValJSON `json:"content_info"`
	Content_data fields.ValBytea `json:"content_data"`
	Content_preview fields.ValBytea `json:"content_preview"`
}

type StudyDocumentAttachment_old_keys_argv struct {
	Argv *StudyDocumentAttachment_old_keys `json:"argv"`	
}

