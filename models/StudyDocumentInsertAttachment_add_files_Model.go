package models

//Controller method model
import (
		
	"osbe/fields"
)

type StudyDocumentInsertAttachment_add_files struct {
	Content_info fields.ValJSON `json:"content_info" required:"true"`
	Content_data fields.ValBytea `json:"content_data"`
	Study_document_insert_head_id fields.ValInt `json:"study_document_insert_head_id"`
}
type StudyDocumentInsertAttachment_add_files_argv struct {
	Argv *StudyDocumentInsertAttachment_add_files `json:"argv"`	
}

