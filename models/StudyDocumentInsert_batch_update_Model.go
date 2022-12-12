package models

//Controller method model

type StudyDocumentInsert_batch_update struct {
	Objects []StudyDocumentInsert_old_keys `json:"objects"`
}
type StudyDocumentInsert_batch_update_argv struct {
	Argv *StudyDocumentInsert_batch_update `json:"argv"`	
}

