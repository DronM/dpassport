package models

import(
	"errors"
	
	"osbe/fields"
)

type HttpInt int
func (v *HttpInt) UnmarshalJSON(data []byte) error {
	
	if fields.ExtValIsNull(data){
		*v = 0
		return nil
	}
	
	v_str := fields.ExtRemoveQuotes(data)
	temp, err := fields.StrToInt(v_str)
	if err != nil {
		return errors.New(fields.ER_UNMARSHAL_INT + err.Error())
	}
	*v = HttpInt(temp)
	
	return nil	
}

type StudyDocKey struct {
	Id HttpInt `json:"id"`
}

//Attachment reference
type Study_documents_ref_Type struct {
	Keys StudyDocKey `json:"keys"`
	DataType string `json:"dataType"`
}

//Attachment info
type Content_info_Type struct {
	Id string `json:"id"`
	Name string `json:"name"`
	Size int64 `json:"size"`
}

