package controllers

//Процедуры обмена данными с сервером 1с
//Запрос уходит и приходит в UTF-8

import (
	"net/url"
	"net/http"
	"fmt"
	"strconv"
	"context"
	"encoding/json"
	"strings"
	"regexp"
	"io/ioutil"
	"errors"
	"time"
	"os"
	"unicode"
	
	"dpassport/models"
	
	"osbe"
	"osbe/logger"
	"ds/pgds"	
)

var quitServer1C chan bool

const SCRIPT = "API1C.php"
//5g4*7h4c46tr$%uk41jn65)bhv54vcwr54v

//All possible commands
//add_schet(doc json) doc json
//get_schet_print(ref string) binary data
//check_payment(docs []doc) docs []doc json
type CommandFor1c int
const (
	CMD_ADD_SCHET CommandFor1c = iota
	CMD_GET_SCHET_PRINT
	CMD_CHECK_PAYMENT
)
func (c CommandFor1c) String() string {
	return []string{"add_schet", "get_schet_print", "check_payment"}[c]
}

const (
	LOG_LEVEL_1C_ERROR = 0
	LOG_LEVEL_1C_WARN = 3
	LOG_LEVEL_1C_INFO = 5	
	LOG_LEVEL_1C_DEBUG = 9
)

//Response from 1c structure
type t_response struct {
	Status bool `json:"status"`
	Error string `json:"error"`
}

//Objects
type SprDogovor struct {
	Date_from time.Time `json:"date_from"`
	Date_to time.Time `json:"date_to"`
	Item_name string `json:"item_name"`
	Item_ref string `json:"item_ref"`		
	Ref string `json:"ref"`
}

type SprClient struct {
	Name string `json:"name"`
	Name_full string `json:"name_full"`
	Inn string `json:"inn"`
	Kpp string `json:"kpp"`
	Ogrn string `json:"ogrn"`
	Dogovor SprDogovor `json:"dogovor"`
	Ref string `json:"ref"`
}

type DocPayment struct {
	Num string `json:"num"`
	Date time.Time `json:"date"`
}

type DocSchet struct {
	Firm_inn string `json:"firm_inn"`
	Firm_ref string `json:"firm_ref"`
	Sklad_name string `json:"sklad_name"`
	Sklad_ref string `json:"sklad_ref"`
	Nds_val int `json:"nds_val"`
	Bank_account string `json:"bank_account"`
	Bank_account_ref string `json:"bank_account_ref"`
	Num string `json:"num"`
	Date time.Time `json:"date"`
	Descr string `json:"descr"`
	Client SprClient `json:"client"`
	Total float32 `json:"total"`
	Ref string `json:"ref"`
	Doc_payment DocPayment `json:"doc_payment"`
	Payed bool `json:"payed"`
}

type queryParams map[string]string

type schetResponse struct {
	t_response
	Doc *DocSchet `json:"doc"`
}

type schetCollectionResponse struct {
	t_response
	Docs []*DocSchet `json:"docs"`
}


type Server1C struct {
	DStore *pgds.PgProvider
	L logger.Logger
	Host string
	Key string
	LogLevel int
	Pay_check_interval int
	Item_name string
	Item_ref string
	Firm_inn string
	Firm_ref string
	Sklad_name string
	Sklad_ref string
	Nds_val int
	Bank_account string
	Bank_account_ref string
	Dogovor_dur_mon int
	Total float32
}

func (s *Server1C) sendQuery(cmd string, params queryParams) ([]byte, error) {
	v := url.Values{}
	v.Add("k", s.Key)
	v.Add("cmd", cmd)
	for p_n, p_v := range params {
		v.Add(p_n, p_v)	
	}	
	
	if s.LogLevel == LOG_LEVEL_1C_DEBUG {
		s.L.Debugf("Sending to 1c: %v", params)
	}

	url_1c := s.Host
	url_1c_l := len(url_1c)
	if url_1c[url_1c_l-1:url_1c_l] != "/" {
		url_1c += "/"
	}
	url_1c += SCRIPT
	u, err := url.ParseRequestURI(url_1c)
	if err != nil {
		return []byte{}, err
	}
	r, _ := http.NewRequest(http.MethodPost, u.String(), strings.NewReader(v.Encode())) // URL-encoded payload
	r.Header.Add("Content-Type", "application/x-www-form-urlencoded; charset=utf-8")//windows-1251
	r.Header.Add("Content-Length", strconv.Itoa(len(v.Encode())))

	client := &http.Client{}
	resp, err := client.Do(r)	
	if err != nil {	
		return []byte{}, err
	}
	
	b, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return []byte{}, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return []byte{}, fmt.Errorf("Server1C HTTP response status: %d, body:%s", resp.StatusCode,  string(b) )
	}
	
	return b, nil
}

//Возможны ошибки из 1с, с тегами и переносами строк, преобразуем!
func correct_1c_resp(resp []byte) ([]byte, error) {
	if len(resp) == 0 {
		return []byte{}, errors.New("Пустой ответ из 1с")
	}
	if string(resp[0]) != "{" {
		//string, script compilation error
		return []byte{}, errors.New(string(resp))
	}

	re := regexp.MustCompile(`\r?\n`)
	resp_t := re.ReplaceAllString(string(resp), " ")
	resp_t = strings.Replace(resp_t, "<b>", "", -1)
	resp_t = strings.Replace(resp_t, "</b>", "", -1)
	resp_t = strings.Replace(resp_t, "<br />", "", -1)
	resp_t = strings.Replace(resp_t, "<br/>", "", -1)		
	resp_t = strings.Map(func(r rune) rune {
	    if unicode.IsGraphic(r) {
		return r
	    }
	    return -1
	}, resp_t)
	return []byte(resp_t), nil;
}

//******** Commands
func (s *Server1C) ExecuteCommand(cmd CommandFor1c, doc *DocSchet) (*DocSchet, error) {
	//constants
	doc.Firm_inn = s.Firm_inn
	doc.Firm_ref = s.Firm_ref
	doc.Sklad_name = s.Sklad_name
	doc.Sklad_ref = s.Sklad_ref
	doc.Nds_val = s.Nds_val
	doc.Bank_account = s.Bank_account
	doc.Bank_account_ref = s.Bank_account_ref
	doc.Client.Dogovor.Item_ref = s.Item_ref
	doc.Total = s.Total
	
	doc_b, err := json.Marshal(doc)
	if err != nil {
		return nil, err
	}	
	resp_b, err := s.sendQuery(cmd.String(), map[string]string{"doc": string(doc_b)})
	if err != nil {		
		return nil, err
	}	
	resp_t, err := correct_1c_resp(resp_b)
	if err != nil {
		return nil, err
	}
	s.L.Debugf("Response from 1c: %s", string(resp_t))
	
	resp := schetResponse{}
	if err := json.Unmarshal(resp_t, &resp); err != nil {
		return nil, errors.New(fmt.Sprintf("Response unmarshal error: %v", err))
	}
	if !resp.Status {		
		return nil, errors.New(resp.Error)
	}
	
	if resp.Doc.Firm_ref == "" || resp.Doc.Sklad_ref == "" || resp.Doc.Bank_account_ref == ""|| resp.Doc.Client.Dogovor.Item_ref == "" {
		//update
		pool_conn, conn_id, err := s.DStore.GetPrimary()
		if err == nil {
			conn := pool_conn.Conn()
			defer s.DStore.Release(pool_conn, conn_id)
			
			conn.Exec(context.Background(),
				fmt.Sprintf(`UPDATE const_server_1c
				SET
					val = val || {"firm_ref": "%s", "sklad_ref": "%s", "bank_account_ref": "", "item_ref": "%s"}`,
				resp.Doc.Firm_ref, resp.Doc.Sklad_ref, resp.Doc.Bank_account_ref, resp.Doc.Client.Dogovor.Item_ref))
		}
	}
	
	/* TEST
	doc.Ref = "111-222-333-444-555"
	doc.Date = time.Now()
	doc.Num = "777"
	doc.Descr = "Счет №" + doc.Num + " от "+doc.Date.Format("01/02/2006")
	*/
	return resp.Doc, nil
}

//returns binary array
func (s *Server1C) GetSchetPrint(app osbe.Applicationer, ref string) ([]byte, error) {
	
	resp_b, err := s.sendQuery(CMD_GET_SCHET_PRINT.String(), map[string]string{"ref": ref})
	if err != nil {
		return []byte{}, err
	}
	
	//return os.ReadFile(app.GetBaseDir() + "/" + CACHE_PATH + "TestOrder.pdf")
	return resp_b, nil
}

func (s *Server1C) checkPayments() {
	//Query for getting out all unpayed orders	
	pool_conn, conn_id, err_с := s.DStore.GetSecondary("")
	if err_с != nil {
		s.L.Errorf("Server1C: checkPayments: %v", err_с)
		return
	}
	defer s.DStore.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	docs := make([]DocSchet, 0)
	rows, err := conn.Query(context.Background(),
		`SELECT
			doc_1c_ref->>'ref'
		FROM client_accesses
		WHERE doc_1c_ref IS NOT NULL AND coalesce(doc_1c_ref->>'ref','') <>'' AND coalesce(doc_1c_ref->>'payed','') <> 'true'`)
	if err != nil {
		s.L.Errorf("Server1C checkPayments: conn.Query(): %v", err)
		return
	}
	for rows.Next() {
		ref := ""		
		if err := rows.Scan(&ref); err != nil {
			s.L.Errorf("Server1C checkPayments:  conn.Scan(): %v", err)
			return
		}
		docs = append(docs, DocSchet{Ref: ref})
	}
	if err := rows.Err(); err != nil {
		s.L.Errorf("Server1C checkPayments: rows.Err(): %v", err)
		return
	}
	if len(docs) == 0 {
		s.L.Debug("Server1C checkPayments: no data")
		return
	}	
	docs_b, err := json.Marshal(&docs)
	if err != nil {
		s.L.Errorf("Server1C checkPayments: json.Marshal(&docs): %v", err)
		return
	}
	resp_b, err := s.sendQuery(CMD_CHECK_PAYMENT.String(), map[string]string{"docs": string(docs_b)})
	if err != nil {
		s.L.Errorf("Server1C checkPayments: sendQuery: %v", err)
		return
	}
	resp_t, err := correct_1c_resp(resp_b)
	if err != nil {
		s.L.Errorf("Server1C checkPayments: correct_1c_resp: %v", err)
		return
	}
	s.L.Debugf("Server1C checkPayments Response from 1c: %s", string(resp_t))
	
	resp := schetCollectionResponse{}
	if err := json.Unmarshal(resp_t, &resp); err != nil {
		s.L.Errorf("Server1C checkPayments: json.Unmarshal(): %v", err)
		return
	}	
	if !resp.Status {
		s.L.Errorf("Server1C checkPayments: Response status not ok")
		return
	}
	//Test
	//resp := schetCollectionResponse{}
	//resp.Docs = make([]*DocSchet, 1)
	//resp.Docs[0] = &DocSchet{Ref: "111-222-333-444-555", Doc_payment: DocPayment{Num: "222", Date: time.Now()}}
	
	upd_q := ""
	upd_cnt := 0
	for _, doc := range resp.Docs {
		//`payed`
		if doc.Payed {
			if upd_q != "" {
				upd_q += ","
			}
			upd_q += fmt.Sprintf(`('{"ref": "%s", "payed": true}'::jsonb)`, doc.Ref)
			upd_cnt++
		}
	}
	if upd_cnt > 0 {
		pool_conn_m, conn_id_m, err_с_m := s.DStore.GetPrimary()
		if err_с_m != nil {
			s.L.Errorf("Server1C: checkPayments: %v", err_с)
			return
		}
		defer s.DStore.Release(pool_conn_m, conn_id_m)
		conn_m := pool_conn_m.Conn()
		
		if _, err := conn_m.Exec(context.Background(),
			fmt.Sprintf(`UPDATE client_accesses AS t
				SET
				    doc_1c_ref = t.doc_1c_ref || upd.doc_1c_ref
				FROM (VALUES
				    %s
				) AS upd(doc_1c_ref) 
				WHERE upd.doc_1c_ref->>'ref' = t.doc_1c_ref->>'ref'`, upd_q)); err != nil {
			
			s.L.Errorf("Server1C: Response UPDATE conn_m.Exec(): %v", err)
		}
		
		s.L.Debugf("Server1C: checkPayments updated: %d", upd_cnt)
	}	
}

func NewServer1C(dStore *pgds.PgProvider, l logger.Logger) (*Server1C, error) {

	srv_1c := Server1C{DStore: dStore, L: l}
	
	pool_conn, conn_id, err := dStore.GetSecondary("")
	if err != nil {
		return nil, err
	}
	conn := pool_conn.Conn()
	defer dStore.Release(pool_conn, conn_id)
	
	if err := conn.QueryRow(context.Background(),
		`SELECT			
			coalesce(val->>'host', ''),
			coalesce(val->>'key', ''),
			coalesce(text_to_int_safe_cast(val->>'log_level'),0),
			coalesce(text_to_int_safe_cast(val->>'pay_check_interval'),0),
			coalesce(val->>'item_name', ''),
			coalesce(val->>'item_ref', ''),
			coalesce(text_to_int_safe_cast(val->>'dogovor_dur_mon'),0),
			coalesce(val->>'firm_inn', ''),
			coalesce(val->>'firm_ref', ''),
			coalesce(val->>'bank_account', ''),
			coalesce(val->>'bank_account_ref', ''),
			coalesce(val->>'sklad_name', ''),
			coalesce(val->>'sklad_ref', ''),
			coalesce(text_to_int_safe_cast(val->>'nds_val'),0),
			coalesce(text_to_float_safe_cast(val->>'total'),0)
		FROM const_server_1c LIMIT 1`,
		).Scan(&srv_1c.Host, &srv_1c.Key, &srv_1c.LogLevel, &srv_1c.Pay_check_interval,
			&srv_1c.Item_name, &srv_1c.Item_ref,
			&srv_1c.Dogovor_dur_mon,
			&srv_1c.Firm_inn, &srv_1c.Firm_ref,
			&srv_1c.Bank_account, &srv_1c.Bank_account_ref,
			&srv_1c.Sklad_name, &srv_1c.Sklad_ref,
			&srv_1c.Nds_val, &srv_1c.Total); err != nil {
		
		return nil, err
	}

	if srv_1c.Host =="" {
		return nil, errors.New("StartServer1C wrong parameter values")
	}

	return &srv_1c, nil
}

//Старт сервера чтения по API
func StartServer1C(dStore *pgds.PgProvider, l logger.Logger) {
	srv_1c, err := NewServer1C(dStore, l)
	if err!= nil {
		l.Errorf("StartServer1C NewServer1C(): %v", err)
		return
	}
	
	quitServer1C = make(chan bool)		
	go (func(srv_1c *Server1C) {			
		
		l.Debugf("Server1C: starting check loop, interval (sec): %d", srv_1c.Pay_check_interval)
		
		for {
			select {
			case <- quitServer1C:				
				l.Debug("Server1C: check loop is stopped")
				return
			default:		
				srv_1c.checkPayments()
				time.Sleep(time.Duration(srv_1c.Pay_check_interval) * time.Second)				
			}
		}						
	})(srv_1c)
}

//Вызывается из User_Controller->register
func createSchet(app osbe.Applicationer, clientRow models.ClientDialog) {
	srv_1c, err := NewServer1C(app.GetDataStorage().(*pgds.PgProvider), app.GetLogger())
	if err != nil {
		app.GetLogger().Errorf("createSchet NewServer1C: %v",err)
		return
	}
	date_from := time.Now()
	date_to := date_from.AddDate(0, srv_1c.Dogovor_dur_mon, 0)
	doc_1c := DocSchet{Date: date_from,
		Client: SprClient{Name: clientRow.Name.GetValue(),
			Name_full: clientRow.Name_full.GetValue(),
			Inn: clientRow.Inn.GetValue(),
			Kpp: clientRow.Kpp.GetValue(),
			Ogrn: clientRow.Ogrn.GetValue(),
			Dogovor: SprDogovor{Date_from: date_from,
				Date_to: date_to,
				Item_name: srv_1c.Item_name,
			},
		},
	}
	doc, err := srv_1c.ExecuteCommand(CMD_ADD_SCHET, &doc_1c)
	if err != nil {
		app.GetLogger().Errorf("Server1C createSchet ExecuteCommand(CMD_ADD_SCHET, &doc): %v",err)
		return
	}
	//put response value to db
	if doc.Ref == "" {
		app.GetLogger().Error("Server1C createSchet Ref is empty")
		return
	}
	
	d_store,_ := app.GetDataStorage().(*pgds.PgProvider)
	pool_conn, conn_id, err := d_store.GetPrimary()
	if err != nil {
		app.GetLogger().Errorf("Server1C createSchet GetPrimary(): %v", err)
		return
	}
	defer d_store.Release(pool_conn, conn_id)
	conn := pool_conn.Conn()
	
	doc_b, err := json.Marshal(&doc)
	if err != nil {
		app.GetLogger().Errorf("Server1C createSchet json.Marshal(&doc): %v", err)
		return
	}	
	q := fmt.Sprintf(`INSERT INTO client_accesses
		(client_id, date_from, date_to, doc_1c_ref)
		VALUES (%d, '%s', '%s', '%s'::jsonb)`,
		clientRow.Id.GetValue(), date_from.Format("2006-02-01"), date_to.Format("2006-02-01"), doc_b)
//fmt.Println("Server1C createSchet q=", q)		
	if _, err := conn.Exec(context.Background(), q); err != nil {
	
		app.GetLogger().Errorf("Server1C reateSchet conn.Exec(): %v", err)
		return
	}
	
	order_b, err := srv_1c.GetSchetPrint(app, doc.Ref)
	if err != nil {
		app.GetLogger().Errorf("Server1C createSchet srv_1c.GetSchetPrint(): %v", err)
		return
	}
	order_fn := GetMd5(doc.Ref)
	if err := os.WriteFile(app.GetBaseDir() + "/" + CACHE_PATH + order_fn, order_b, 0644); err != nil {
		app.GetLogger().Errorf("Server1C createSchet os.WriteFile(): %v", err)
		return
	}
	
	//mail to client with attachment, then delete
	if err := RegisterMailFromSQL(conn, "mail_client_order", []string{order_fn}, []interface{}{clientRow.Id.GetValue()}); err != nil {
		app.GetLogger().Errorf("Server1C createSchet RegisterMailFromSQL(): %v", err)
		return
	}
}

