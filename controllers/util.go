package controllers

import(
	"math/rand"
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"context"
	"reflect"
	"strconv"
	"time"
	"strings"
	"encoding/json"
	"os/exec"
	
	"ds/pgds"
	"osbe"
	"osbe/response"
	"osbe/socket"
	"osbe/model"
	"osbe/sql"
	"osbe/fields"
	
	"github.com/jackc/pgx/v4/pgxpool"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgconn"
)

const (
	RESP_ER_PREDEFINED_DEL = 1100
	RESP_ER_PREDEFINED_DESCR_DEL = "Удалять предопределенный элемент запрещено."
	
	RESP_ER_PREDEFINED_UPD = 1101
	RESP_ER_PREDEFINED_DESCR_UPD = "Редактировать предопределенный элемент запрещено."
	
	MOD_HEAD_Q = `INSERT INTO object_mod_log
		(user_descr, object_type, object_id, object_descr, date_time, action)
		VALUES `
	
)


func GetMd5(data string) string {
	hasher := md5.New()
	hasher.Write([]byte(data))
	return hex.EncodeToString(hasher.Sum(nil))
}

func genUniqID(maxLen int) string{
	var letterRunes = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890")
	b := make([]rune, maxLen)
	for i := range b {
		rand.Seed(time.Now().UnixNano())
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)	
}

func GetUUID() (string, error) {
	out, err := exec.Command("uuidgen").Output()
	if err != nil {
		return "", err
	}
	return string(out), nil
}

func checkPredefined(app osbe.Applicationer, itemID int64, table string) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	defer d_store.Release(pool_conn, conn_id)
	pool_conn, conn_id, err := d_store.GetSecondary("")
	if err != nil {
		return err
	}
	conn := pool_conn.Conn()
	
	predefined := false
	if err := conn.QueryRow(context.Background(), fmt.Sprintf("SELECT predefined FROM %s WHERE id=$1",table), itemID).Scan(&predefined);err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("SELECT predefined Scan(): %v",err))
	}
	if predefined {
		return osbe.NewPublicMethodError(RESP_ER_PREDEFINED_UPD, RESP_ER_PREDEFINED_DESCR_UPD)
	}
	return nil
}
	
func currentUserID(sock socket.ClientSocketer) int64{
	sess := sock.GetSession()	
	user_id := sess.GetInt("USER_ID")
	if user_id == 0 {
		user_id = 1
	}
	
	return user_id
}

//***
func UpdateOnArgs(app osbe.Applicationer, pm osbe.PublicMethod, resp *response.Response, sock socket.ClientSocketer, rfltArgs reflect.Value, modelMD *model.ModelMD, presetConds sql.FilterCondCollection) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	//1) begin transaction
	_, err = conn.Exec(context.Background(), "BEGIN")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("UpdateOnArgs BEGIN: %v",err))
	}
	
	//2) override default update
	f_query, w_query, f_values, keys := osbe.ArgsToUpdateParams(rfltArgs, presetConds)		
	if f_query == "" || w_query == "" {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, osbe.ER_UPDATE_EMPTY)
	}
	q := fmt.Sprintf("UPDATE %s SET %s WHERE %s", modelMD.Relation, f_query, w_query)
	par, err := conn.Exec(context.Background(), q, f_values...)
	if err != nil {
		if pgerr, ok := err.(*pgconn.PgError); ok && pgerr.Code == "23514" {
			//custom error
			return osbe.NewPublicMethodError(osbe.RESP_ER_WRITE_CONSTR_VIOL, osbe.ER_WRITE_CONSTR_VIOL)
		}else{
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("UpdateOnArgsWithConn pgx.Conn.Exec(): %v",err))
		}
	}	
	lsn := osbe.GetDbLsn(conn)	
	resp.AddModel(model.New_MethodResult_Model(par.RowsAffected(), lsn))	
	
	//events
	PublishEventsWithKeys(sock, keys, app, pm, lsn, modelMD.ID)
	
	//3) action
	if err := addAction(conn, sock, modelMD, "update", keys); err != nil {
		return err
	}
	
	//4) commit
	_, err = conn.Exec(context.Background(), "COMMIT")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("UpdateOnArgs COMMIT: %v",err))
	}
	return nil	
}

func DeleteOnArgKeys(app osbe.Applicationer, pm osbe.PublicMethod, resp *response.Response, sock socket.ClientSocketer, rfltArgs reflect.Value, modelMD *model.ModelMD, presetConds sql.FilterCondCollection) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	//1) begin transaction
	_, err = conn.Exec(context.Background(), "BEGIN")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("DeleteOnArgKeys BEGIN: %v",err))
	}

	//2) action
	//fields with key values
	keys := make(map[string]interface{})
	rfltArgs_o := reflect.Indirect(rfltArgs)
	arg_tp := rfltArgs_o.Type()		
	for i := 0; i < rfltArgs_o.NumField(); i++ {						
		if fld_v, ok := rfltArgs_o.Field(i).Interface().(fields.ValExt); ok && fld_v.GetIsSet() {
			if field_id, ok := arg_tp.Field(i).Tag.Lookup("json"); ok {
				keys[field_id] = fld_v
			}
		}
	}
	if err := addAction(conn, sock, modelMD, "delete", keys); err != nil {
		return err
	}

	//3
	if err := DeleteOnArgKeysWithConn(conn, app, pm, resp, sock, rfltArgs, modelMD, presetConds); err != nil{
		return err
	}

	//4) commit
	_, err = conn.Exec(context.Background(), "COMMIT")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("DeleteOnArgKeys COMMIT: %v",err))
	}

	return nil
}

func InsertOnArgs(app osbe.Applicationer, pm osbe.PublicMethod, resp *response.Response, sock socket.ClientSocketer, rfltArgs reflect.Value, modelMD *model.ModelMD, retModel interface{}, presetConds sql.FilterCondCollection) error {
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		return err
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	//1) begin transaction
	_, err = conn.Exec(context.Background(), "BEGIN")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf(" BEGIN: %v",err))		
	}

	//2)
	keys, err := InsertOnArgsWithConn(conn, app, pm, resp, sock, rfltArgs, modelMD, retModel, presetConds)
	if err != nil {
		return err
	}

	//3) action
	if err := addAction(conn, sock, modelMD, "insert", keys); err != nil {
		return err
	}

	//4) commit
	_, err = conn.Exec(context.Background(), "COMMIT")
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("InsertOnArgs COMMIT: %v",err))
	}

	return nil

}

//Implements controller insert method
func InsertOnArgsWithConn(conn *pgx.Conn, app osbe.Applicationer, pm osbe.PublicMethod, resp *response.Response, sock socket.ClientSocketer, rfltArgs reflect.Value, modelMD *model.ModelMD, retModel interface{}, presetConds sql.FilterCondCollection) (map[string]interface{}, error) {
	field_ids, field_args, f_values := osbe.ArgsToInsertParams(rfltArgs, presetConds, app.GetEncryptKey())		
	
	ret_field_ids:= "" //return all key fields
	keys := make(map[string]interface{})
	row_val := reflect.ValueOf(retModel).Elem()		
	row_fields := make([]interface{}, 0) //row_val.NumField()
	row_t := row_val.Type()
	for i := 0; i < row_val.NumField(); i++ {
		if field_id, ok := row_t.Field(i).Tag.Lookup("json"); ok {
			if ret_field_ids != "" {
				ret_field_ids += ", "
			}
			ret_field_ids += field_id
			keys[field_id] = nil
			value_field := row_val.Field(i)
			row_fields = append(row_fields, value_field.Addr().Interface())
		}else{
			return nil, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("Field: %s, no json tag!", row_t.Field(i).Name))
		}
	}
	q := ""
	if field_ids == "" {
		q += fmt.Sprintf("INSERT INTO %s DEFAULT VALUES RETURNING %s", modelMD.Relation, ret_field_ids)
	}else{
		q += fmt.Sprintf("INSERT INTO %s (%s) VALUES (%s) RETURNING %s", modelMD.Relation, field_ids, field_args, ret_field_ids)
	}
	
	if err := conn.QueryRow(context.Background(), q, f_values...).Scan(row_fields...); err != nil {
		if pgerr, ok := err.(*pgconn.PgError); ok && pgerr.Code == "23514" {
			//custom error
			return  nil, osbe.NewPublicMethodError(osbe.RESP_ER_WRITE_CONSTR_VIOL, osbe.ER_WRITE_CONSTR_VIOL)
		}else{
			return  nil, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("InsertOnArgsWithConn pgx.Conn.Exec(): %v",err))
		}				
	}
	m := model.New_InsertedKey_Model(retModel)
	resp.AddModel(m)
	
	/*
	rows, err := conn.Query(context.Background(), q, f_values...)
	if err != nil {
		return nil, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("pgx.Conn.Query(): %v",err))
	}	

	if rows.Next() {		
		if err := rows.Scan(row_fields...); err != nil {		
			return nil, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("pgx.Rows.Scan(): %v",err))	
		}
		m := model.New_InsertedKey_Model(retModel)
		resp.AddModel(m)
	}
	if err := rows.Err(); err != nil {
		return nil, osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, err.Error())
	}
	*/
	
	//events
	i:= 0
	for key,_ := range keys {
		keys[key] = row_fields[i]
		i++
	}
	lsn := osbe.GetDbLsn(conn)
	resp.AddModel(model.New_MethodResult_Model(1, lsn))
	PublishEventsWithKeys(sock, keys, app, pm, lsn, modelMD.ID)
	
	return keys, nil
}

func DeleteOnArgKeysWithConn(conn *pgx.Conn, app osbe.Applicationer, pm osbe.PublicMethod, resp *response.Response, sock socket.ClientSocketer, rfltArgs reflect.Value, modelMD *model.ModelMD, presetConds sql.FilterCondCollection) error {
	
	rfltArgs_o := reflect.Indirect(rfltArgs)
	arg_tp := rfltArgs_o.Type()
	
	f_values := make([]interface{}, 0) //arg_tp.NumField()
	keys := make(map[string]interface{})
	
	ids_key := ""
	where_sql := ""
	field_ind := 0
	
	//add all preset values to delete condition
	var added_fields map[string]bool
	if presetConds != nil {
		added_fields := make(map[string]bool, len(presetConds))
		for _, pr_f := range presetConds {
			if where_sql != "" {
				where_sql += " AND "
			}
			if pr_f.FieldID != "" {
				where_sql += pr_f.FieldID + " = $"+strconv.Itoa(field_ind+1)		
				f_values = append(f_values, pr_f.Value)
				field_ind++
			}else if  pr_f.Expression !="" {
				//expression
				where_sql += pr_f.Expression
			}
			added_fields[pr_f.FieldID] = true			
		}
	}
	
	for i := 0; i < rfltArgs_o.NumField(); i++ {						
		if fld_v, ok := rfltArgs_o.Field(i).Interface().(fields.ValExt); ok && fld_v.GetIsSet() {
			if field_id, ok := arg_tp.Field(i).Tag.Lookup("json"); ok {
				if _, ok := added_fields[field_id]; ok {
					//added already
					continue
				}
				if where_sql != "" {
					where_sql += " AND "
				}
				where_sql += field_id + " = $"+strconv.Itoa(field_ind+1)
				ids_key += "_"+field_id
			
				f_values = append(f_values,fld_v)
				keys[field_id],_ = fld_v.Value()				
				field_ind++			
			}
		}
	}
	if where_sql == "" {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, osbe.ER_NO_KEYS)
	}
	
	q := fmt.Sprintf(`DELETE FROM %s WHERE %s`, modelMD.Relation, where_sql)
//fmt.Println("DeleteOnArgKeys q=", q, "f_values=", f_values)			
	_, err := conn.Prepare(context.Background(), modelMD.Relation+ids_key+"_delete", q)
	if err != nil {
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("pgx.Conn.Prepare(): %v",err))
	}
	
	par, err := conn.Exec(context.Background(), modelMD.Relation+ids_key+"_delete", f_values...)
	if err != nil {
		if pgerr, ok := err.(*pgconn.PgError); ok && pgerr.Code == "23503" {
			//custom error
			return osbe.NewPublicMethodError(osbe.RESP_ER_DELETE_CONSTR_VIOL, osbe.ER_DELETE_CONSTR_VIOL)
		}else{
			return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("pgx.Conn.Exec(): %v",err))
		}
	}
	
	lsn := osbe.GetDbLsn(conn)
	resp.AddModel(model.New_MethodResult_Model(par.RowsAffected(), lsn))
	
	//events
	PublishEventsWithKeys(sock, keys, app, pm, lsn, modelMD.ID)
		
	return nil
}

func PublishEventsWithKeys(sock socket.ClientSocketer, keys map[string]interface{}, app osbe.Applicationer, pm osbe.PublicMethod, lsn string, modelMDID string) {
	sockID := sock.GetToken()
	var companyID int64
	var createUserID int64
	sess := sock.GetSession()
	role_id := sess.GetString(osbe.SESS_ROLE)
	if role_id == "client_admin1" || role_id == "client_admin2" {
		companyID = sess.GetInt(SESS_VAR_COMPANY_ID)		
	}
	if role_id == "client_admin2" &&
		(modelMDID == "StudyDocument" ||
		modelMDID == "StudyDocumentRegister" ||
		modelMDID == "StudyDocumentInsertHead") {
		
		createUserID = sess.GetInt(SESS_VAR_ID)		
	}
		
	
	//events
	params := make(map[string]interface{})
	params["emitterId"] = sockID
	params["keys"] = keys
	if lsn != "" {
		params[osbe.LSN_FIELD] = lsn
	}
	
	on_ev := app.GetOnPublishEvent()
	if on_ev != nil {
		l := pm.GetEventList()
		if l != nil {
			params_s := "null"
			if params != nil && len(params) > 0 {				
				if par, err := json.Marshal(params); err == nil {
					params_s = string(par)
				}
			}
			for _, ev_id := range l {				
				if ev_id != "" {
					//common event for admin
					on_ev(ev_id, `"params":`+params_s)
					
					//company event for adm1
					if companyID > 0 {
						on_ev(fmt.Sprintf("%s_comp_%d", ev_id, companyID), `"params":`+params_s)
						
					}
					//create user event for adm2
					if createUserID > 0 {
						on_ev(fmt.Sprintf("%s_usr_%d", ev_id, createUserID), `"params":`+params_s)
					}
				}
			}
		}
	}	
}

//
func addAction(conn *pgx.Conn, sock socket.ClientSocketer, modelMD *model.ModelMD, action string, keys map[string]interface{}) error {
	//object ref
	w_query := ""
	field_ind := 0
	key_values := make([]interface{}, 0)
	for key_id, key_val := range keys {
		if w_query != "" {
			w_query+= ", "
		}
		w_query+= "t."+key_id + " = $"+strconv.Itoa(field_ind + 1)
		key_values = append(key_values, key_val)
		field_ind++
	}
	var ref fields.Ref
	if err := conn.QueryRow(context.Background(),
		fmt.Sprintf(`SELECT %s_ref(t) FROM %s AS t WHERE %s`, modelMD.Relation, modelMD.Relation, w_query),
		key_values...).Scan(&ref); err != nil {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("addAction SELECT ref pgx.Conn.QueryRow(): %v",err))
	}

	sess := sock.GetSession()	
	params := []interface{}{sess.GetString(SESS_VAR_NAME),
			ref.DataType,
			ref.Keys["id"],
			ref.Descr,			
			action,
	}
	var id int64
	if err := conn.QueryRow(context.Background(),
		MOD_HEAD_Q + `($1, $2, $3, $4, now(), $5) RETURNING id`, params...).Scan(&id); err != nil {
		
		return osbe.NewPublicMethodError(response.RESP_ER_INTERNAL, fmt.Sprintf("addAction INSERT into log: %v",err))
	}

	//Add event
	EmitEvent(conn, "ObjectModLog.update", id)
	
	return nil
}

func UnformatSnils(formattedSnils string) string {
	snils := strings.ReplaceAll(formattedSnils, " ", "")
	return strings.ReplaceAll(snils, "-", "")
}

//emits event
func EmitEvent(conn *pgx.Conn, evntID string, objID int64) {
	conn.Exec(context.Background(), fmt.Sprintf(`SELECT pg_notify('%s', json_build_object('params', json_build_object('keys', json_build_object('id', %d)))::text)`, evntID, objID))
}


