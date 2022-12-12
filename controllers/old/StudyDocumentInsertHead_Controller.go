package controllers

/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

import (
	"reflect"	
	"encoding/json"
	"context"
	"fmt"
	
	"dpassport/models"
	
	"ds/pgds"
	"osbe"
	"osbe/fields"
	"osbe/srv"
	"osbe/socket"
	"osbe/response"	
	"osbe/model"
	
	"github.com/jackc/pgx/v4"
)

const (
	ER_NO_USER_CODE = 1000
	ER_NO_USER_DESCR = "Найдены сертификаты с пустыми ФИО"
)

//Controller
type StudyDocumentInsertHead_Controller struct {
	osbe.Base_Controller
}

func NewController_StudyDocumentInsertHead() *StudyDocumentInsertHead_Controller{
	c := &StudyDocumentInsertHead_Controller{osbe.Base_Controller{ID: "StudyDocumentInsertHead", PublicMethods: make(osbe.PublicMethodCollection)}}	
	keys_fields := fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsertHead_keys{}))
	
	//************************** method insert **********************************
	c.PublicMethods["insert"] = &StudyDocumentInsertHead_Controller_insert{
		osbe.Base_PublicMethod{
			ID: "insert",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsertHead{})),
			EventList: osbe.PublicMethodEventList{"StudyDocumentInsertHead.insert"},
		},
	}
	
	//************************** method delete *************************************
	c.PublicMethods["delete"] = &StudyDocumentInsertHead_Controller_delete{
		osbe.Base_PublicMethod{
			ID: "delete",
			Fields: keys_fields,
			EventList: osbe.PublicMethodEventList{"StudyDocumentInsertHead.delete"},
		},
	}
	
	//************************** method update *************************************
	c.PublicMethods["update"] = &StudyDocumentInsertHead_Controller_update{
		osbe.Base_PublicMethod{
			ID: "update",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsertHead_old_keys{})),
			EventList: osbe.PublicMethodEventList{"StudyDocumentInsertHead.update"},
		},
	}
	
	//************************** method get_object *************************************
	c.PublicMethods["get_object"] = &StudyDocumentInsertHead_Controller_get_object{
		osbe.Base_PublicMethod{
			ID: "get_object",
			Fields: keys_fields,
		},
	}
	
	//************************** method get_list *************************************
	c.PublicMethods["get_list"] = &StudyDocumentInsertHead_Controller_get_list{
		osbe.Base_PublicMethod{
			ID: "get_list",
			Fields: model.Cond_Model_fields,
		},
	}
	
	//************************** method close *************************************
	c.PublicMethods["close"] = &StudyDocumentInsertHead_Controller_close{
		osbe.Base_PublicMethod{
			ID: "close",
			Fields: fields.GenModelMD(reflect.ValueOf(models.StudyDocumentInsertHead_close{})),
		},
	}
	
	return c
}

type StudyDocumentInsertHead_Controller_keys_argv struct {
	Argv models.StudyDocumentInsertHead_keys `json:"argv"`	
}

//************************* INSERT **********************************************
//Public method: insert
type StudyDocumentInsertHead_Controller_insert struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentInsertHead_Controller_insert) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsertHead_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}
func (pm *StudyDocumentInsertHead_Controller_insert) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.InsertOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentInsertHead"], &models.StudyDocumentInsertHead_keys{}, sock.GetPresetFilter("StudyDocumentInsertHead"))	
}

//************************* DELETE **********************************************
type StudyDocumentInsertHead_Controller_delete struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentInsertHead_Controller_delete) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsertHead_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsertHead_Controller_delete) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.DeleteOnArgKeys(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentInsertHead"], sock.GetPresetFilter("StudyDocumentInsertHead"))	
}

//************************* GET OBJECT **********************************************
type StudyDocumentInsertHead_Controller_get_object struct {
	osbe.Base_PublicMethod
}

//Public method Unmarshal to structure
func (pm *StudyDocumentInsertHead_Controller_get_object) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsertHead_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsertHead_Controller_get_object) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetObjectOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentInsertHeadList"], &models.StudyDocumentInsertHeadList{}, sock.GetPresetFilter("StudyDocumentInsertHeadList"))	
}

//************************* GET LIST **********************************************
//Public method: get_list
type StudyDocumentInsertHead_Controller_get_list struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsertHead_Controller_get_list) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &model.Controller_get_list_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsertHead_Controller_get_list) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.GetListOnArgs(app, resp, rfltArgs, app.GetMD().Models["StudyDocumentInsertHeadList"], &models.StudyDocumentInsertHeadList{}, sock.GetPresetFilter("StudyDocumentInsertHeadList"))	
}

//************************* UPDATE **********************************************
//Public method: update
type StudyDocumentInsertHead_Controller_update struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsertHead_Controller_update) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsertHead_old_keys_argv{}
		
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

//Method implemenation
func (pm *StudyDocumentInsertHead_Controller_update) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	return osbe.UpdateOnArgs(app, pm, resp, sock, rfltArgs, app.GetMD().Models["StudyDocumentInsertHead"], sock.GetPresetFilter("StudyDocumentInsertHead"))	
}

//************************* close **********************************************

//Public method: close
type StudyDocumentInsertHead_Controller_close struct {
	osbe.Base_PublicMethod
}
//Public method Unmarshal to structure
func (pm *StudyDocumentInsertHead_Controller_close) Unmarshal(payload []byte) (reflect.Value, error) {
	var res reflect.Value
	argv := &models.StudyDocumentInsertHead_close_argv{}
	if err := json.Unmarshal(payload, argv); err != nil {
		return res, err
	}	
	res = reflect.ValueOf(&argv.Argv).Elem()	
	return res, nil
}

type ref_type struct {
	models.Study_documents_ref_Type
	Descr string `json:"descr"`
	DocID fields.ValInt
	CompanyID fields.ValInt
}
//Method implemenation
func (pm *StudyDocumentInsertHead_Controller_close) Run(app osbe.Applicationer, serv srv.Server, sock socket.ClientSocketer, resp *response.Response, rfltArgs reflect.Value) error {
	//All in one transaction: 
	//	1) Create Protocol with action mark
	//	2) Create certs with action mark
	//	3) Update attachments, set new object
	//	4) Delete temp data insert_heads (inserts in trigger)
	
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err_с := d_store.GetPrimary()
	if err_с != nil {
		return err_с
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	if _, err := conn.Exec(context.Background(),"BEGIN"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close BEGIN: %v",err))	
	}

	args := rfltArgs.Interface().(*models.StudyDocumentInsertHead_close)
	
	//Проверки: контроль пустых сканов
	empty_att_cnt := 0
	if err := conn.QueryRow(context.Background(),
		`SELECT coalesce(count(*), 0)
		FROM study_document_insert_attachments
		WHERE study_document_insert_head_id = $1 AND study_document_insert_id IS NULL`,
		args.Study_document_insert_head_id).Scan(&empty_att_cnt); err != nil {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close SELECT scan_cnt: %v",err))	
	}
	if empty_att_cnt > 0 {
		return osbe.NewPublicMethodError(ER_NO_USER_CODE, ER_NO_USER_DESCR)	
	}
	
	sess := sock.GetSession()	
	user_descr := sess.GetString(SESS_VAR_NAME)
	
	log_query := ""
	log_query_param_ind := 1
	log_query_params := make([]interface{}, 0)
	
	//1) Protocol не всегда
	study_document_registers_ref := ref_type{DocID: fields.NewValInt(0, true),
		CompanyID: fields.NewValInt(0, true),
	}
	att_exists := false
	if err := conn.QueryRow(context.Background(),
		`INSERT INTO study_document_registers
		(name, issue_date, company_id, create_type)
		SELECT
			h.register_name,
			h.register_date,
			h.company_id,
			'manual'::doc_create_types
		FROM study_document_insert_heads AS h
		WHERE h.id = $1
			AND COALESCE(h.register_name, '') <>''
			AND h.register_date IS NOT NULL
		RETURNING
			study_document_registers_ref(study_document_registers),
			company_id,
			coalesce(
				(SELECT
					TRUE
				FROM study_document_attachments AS att
				WHERE att.study_documents_ref->>'dataType' = 'study_document_insert_heads'
					AND (att.study_documents_ref->'keys'->>'id')::int = $1),
			FALSE) AS att`,
		args.Study_document_insert_head_id).Scan(&study_document_registers_ref, &study_document_registers_ref.CompanyID, &att_exists); err != nil && err != pgx.ErrNoRows {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close INSERT study_document_registers: %v",err))	
	}	
	if int(study_document_registers_ref.Keys.Id) > 0 {
		//Вложение Протокол
		if att_exists {
			if _, err := conn.Exec(context.Background(),
				fmt.Sprintf(`UPDATE study_document_attachments
				SET
					study_documents_ref = '{"dataType": "study_document_registers", "keys": {"id": %d}}'::jsonb
				WHERE study_documents_ref->>'dataType' = 'study_document_insert_heads'
					AND (study_documents_ref->'keys'->>'id')::int = $1`, int(study_document_registers_ref.Keys.Id)),				
				args.Study_document_insert_head_id); err != nil {		
					
				return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close UPDATE protocol study_document_attachments: %v",err))	
			}	
		}
	
		if log_query != "" {
			log_query+= ", "
		}
		log_query+= fmt.Sprintf("($%d, $%d, $%d, $%d, 'insert')", log_query_param_ind, log_query_param_ind+1, log_query_param_ind+2, log_query_param_ind+3)
		log_query_param_ind+= 4
		log_query_params = append(log_query_params, user_descr)
		log_query_params = append(log_query_params, study_document_registers_ref.DataType)
		log_query_params = append(log_query_params, int(study_document_registers_ref.Keys.Id))
		log_query_params = append(log_query_params, study_document_registers_ref.Descr)
		study_document_registers_ref.DocID.SetValue(int64(study_document_registers_ref.Keys.Id))
	}
	
	//2) Certs
	att_query := "" //Вложения сертификаты
	rows, err := conn.Query(context.Background(),
		`WITH sel AS (
			SELECT
				row_number() over (ORDER BY l.id) AS n,
				att.id AS att_id,
				l.snils, l.issue_date, l.end_date,
				l.post, l.work_place, l.organization, l.study_type, l.series, l.number, l.study_prog_name,
				l.profession, l.reg_number, l.study_period, l.name_first, l.name_second, l.name_middle, l.qualification_name				
			FROM study_document_inserts AS l
			LEFT JOIN study_document_insert_attachments AS att ON att.study_document_insert_id = l.id
			WHERE l.study_document_insert_head_id = $1
			ORDER BY l.id
		),
		ins AS (
			INSERT INTO study_documents
			(company_id, study_document_register_id,
			snils, issue_date, end_date,
			post, work_place, organization, study_type, series, number, study_prog_name, 
			profession, reg_number, study_period, name_first, name_second, name_middle, qualification_name,
			create_type)
			SELECT
				$2, $3,
				sel.snils, sel.issue_date, sel.end_date,
				sel.post, sel.work_place, sel.organization, sel.study_type, sel.series, sel.number, sel.study_prog_name,
				sel.profession, sel.reg_number, sel.study_period, sel.name_first, sel.name_second, sel.name_middle, sel.qualification_name,
				'manual'::doc_create_types
			FROM sel
			RETURNING id, study_documents_ref(study_documents) AS ref
		),
		ins_sel AS (
			SELECT
				ins.ref,
				row_number() over (ORDER BY ins.id) AS n
			FROM ins
			ORDER BY ins.id
		)
		SELECT
			ins_sel.ref,
			coalesce(sel.att_id, 0)
		FROM ins_sel
		LEFT JOIN sel ON sel.n = ins_sel.n`,
		args.Study_document_insert_head_id,
		study_document_registers_ref.CompanyID,
		study_document_registers_ref.DocID,
		)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close INSERT study_documents: %v",err))
	}	
	for rows.Next() {
		att_id := 0 //old temp document
		study_documents_ref:= ref_type{} //new document
		if err := rows.Scan(&study_documents_ref, &att_id); err != nil {		
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close INSERT INTO study_documents Scan(): %v",err))
		}
		if int(study_documents_ref.Keys.Id) > 0 {
			if log_query != "" {
				log_query+= ", "
			}
			log_query+= fmt.Sprintf("($%d, $%d, $%d, $%d, 'insert')",
				log_query_param_ind, log_query_param_ind+1, log_query_param_ind+2, log_query_param_ind+3)
			log_query_param_ind+= 4
			log_query_params = append(log_query_params, user_descr)
			log_query_params = append(log_query_params, study_documents_ref.DataType)
			log_query_params = append(log_query_params, int(study_documents_ref.Keys.Id))
			log_query_params = append(log_query_params, study_documents_ref.Descr)
		}
		
		//Attachments
		if att_id > 0 {
			if att_query != "" {
				att_query+= ", "
			}
			att_query+= fmt.Sprintf(`('{"dataType": "study_documents", "keys": {"id": %d}}'::jsonb, %d)`, int(study_documents_ref.Keys.Id), att_id)
		}
	}
	if err := rows.Err(); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close INSERT INTO study_documents Scan(): %v",err))
	}
	rows.Close()	
	if len(log_query_params) > 0 {
		if _, err := conn.Exec(context.Background(),
			`INSERT INTO object_mod_log (user_descr, object_type, object_id, object_descr, action) VALUES ` + log_query,
			log_query_params...); err != nil {		
			
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close INSERT cert log: %v",err))	
		}
	}
	
	//3)
	if att_query != "" {
		if _, err := conn.Exec(context.Background(),
			fmt.Sprintf(`UPDATE study_document_attachments AS u
			SET
				study_documents_ref = v.study_documents_ref_new
			FROM (values
				%s
			) AS v(study_documents_ref_new, old_key_id) 
			WHERE u.study_documents_ref->>'dataType' = 'study_document_insert_attachments'
				AND (u.study_documents_ref->'keys'->>'id')::int = v.old_key_id`, att_query)); err != nil {		
				
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close UPDATE study_document_attachments: %v",err))	
		}	
	}
	
	//4) event returned in GUI (as though grid gets updated)
	if _, err := conn.Exec(context.Background(),
		`DELETE FROM study_document_insert_heads WHERE id = $1`, args.Study_document_insert_head_id); err != nil {		
			
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close UPDATE study_document_attachments: %v",err))	
	}	
	
	//+events
	conn.Exec(context.Background(), fmt.Sprintf(`SELECT pg_notify('StudyDocument.insert', json_build_object('params', json_build_object('id',0))::text)`, docType))
	//+ special events
	user_role := sess.GetString(osbe.SESS_ROLE)
	if user_role == "client_admin1" || user_role == "client_admin2" {
		conn.Exec(context.Background(), fmt.Sprintf(`SELECT pg_notify('StudyDocument.insert_comp_%d', json_build_object('params', json_build_object('id',0))::text)`, companyID))
	}	
	if userRoleID == "client_admin2" {
		conn.Exec(context.Background(), fmt.Sprintf(`SELECT pg_notify('StudyDocument.insert_usr_%d', json_build_object('params', json_build_object('id',0))::text)`, docType, userID))
	}	
	if int(study_document_registers_ref.Keys.Id) > 0 {
		//Protocol event
		
	}
	
	
	if _, err := conn.Exec(context.Background(),"COMMIT"); err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("StudyDocumentInsertHead_Controller_close COMMIT: %v",err))	
	}
	
	return nil
}

