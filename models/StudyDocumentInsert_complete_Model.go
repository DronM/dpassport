package models

/**
 * Andrey Mikhalevich 16/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

//Controller method model
import (
	"reflect"
	
	"osbe/model"
	"osbe/fields"
)

type StudyDocumentInsert_complete_argv struct {
	Argv *StudyDocumentInsert_complete `json:"argv"`	
}

//Exported model metadata
var StudyDocumentInsert_complete_md fields.FieldCollection

func StudyDocumentInsert_complete_Model_init() {	
	StudyDocumentInsert_complete_md = fields.GenModelMD(reflect.ValueOf(StudyDocumentInsert_complete{}))
}

//
type StudyDocumentInsert_complete struct {
	/*Count fields.ValInt `json:"count" default:10`	
	Ic fields.ValInt `json:"ic" default:1 minValue:0 maxValue:1`
	Mid fields.ValInt `json:"mid" default:1 minValue:0 maxValue:1`
	Ord_directs fields.ValText `json:"ord_directs" length:500`
	Field_sep fields.ValText `json:"field_sep" length:2`
	*/
	model.Complete_Model
	Name_full fields.ValText `json:"name_full" matchField:"true" required:"true"`
}
