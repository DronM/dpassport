package models

//Controller method model

type StudyDocument_batch_update struct {
	Objects []StudyDocument_old_keys `json:"objects"`
}
type StudyDocument_batch_update_argv struct {
	Argv *StudyDocument_batch_update `json:"argv"`	
}

