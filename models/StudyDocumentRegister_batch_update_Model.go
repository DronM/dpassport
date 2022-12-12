package models


//Controller method model

type StudyDocumentRegister_batch_update struct {
	Objects []StudyDocumentRegister_old_keys `json:"objects"`
}
type StudyDocumentRegister_batch_update_argv struct {
	Argv *StudyDocumentRegister_batch_update `json:"argv"`	
}

