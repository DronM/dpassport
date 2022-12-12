package models

type ExcelUploadFieldDescr struct {
	Ind int `json:"ind"`
	Name string `json:"name"` //database Field id in struct, Issue_date, End_date
	Descr string `json:"descr"`
	DataType string `json:"dataType"`
	MaxLength int `json:"maxLength"`
	Required bool `json:"required"`
}


