package controllers

import (
	"time"
	"fmt"
	"context"
	"errors"
	"strings"
	
	"osbe/logger"
	"ds/pgds"
	
	"github.com/stvoidit/gosmtp"
	"github.com/jackc/pgx/v4"
	"github.com/jackc/pgx/v4/pgxpool"
)

const MAIL_SERVER_SELECT_Q = "mail_server_select"

var quitMailReader chan bool

type mailMessage struct {
	To_addr string `json:"to_addr"`
	To_name string `json:"to_name"`
	Body string `json:"body"`
	Subject string `json:"subject"`
	Mail_type string `json:"mail_type"`
}

//sql function call
func RegisterMailFromSQL(conn *pgx.Conn, sqlFunc string, attachments []string, sqlParamValues []interface{}) error {

	sql_param_str := ""
	for i := 0; i < len(sqlParamValues); i++ {
		if sql_param_str != "" {
			sql_param_str+= ","
		}
		sql_param_str+=fmt.Sprintf("$%d", i+1)
	}
	msg := mailMessage{}
	if err := conn.QueryRow(context.Background(),
		fmt.Sprintf(`SELECT
			to_addr,
			to_name,
			body,
			subject,
			mail_type
		FROM %s(%s)`, sqlFunc, sql_param_str),
		sqlParamValues...).Scan(&msg.To_addr,
					&msg.To_name,
					&msg.Body,
					&msg.Subject,
					&msg.Mail_type,
			); err != nil && err != pgx.ErrNoRows {
	
		return err	
		
	}else if err == pgx.ErrNoRows {
		return errors.New("Не найден шаблон отправки")
	} 
	
	if msg.To_addr == "" {
		return errors.New("Не задан адрес электронной почты")
	}
	if msg.Body == "" {
		return errors.New("Не задано тело письма по шаблону")
	}
	if msg.Subject == "" {
		return errors.New("Не задана тема письма по шаблону")
	}
	if msg.Mail_type == "" {
		return errors.New("Не задан тип письма по шаблону")
	}
	
	return RegisterMail(conn, &msg, attachments)
}

//Manual registration
func RegisterMail(conn *pgx.Conn, msg *mailMessage, attachments []string) error {
//fmt.Println("RegisterMail")
	attachments_exist := (attachments != nil && len(attachments) > 0)
	
	if attachments_exist {
		if _, err := conn.Exec(context.Background(),`BEGIN`); err != nil {
			return err
		}
	}
		
	var msg_id int64
	if err := conn.QueryRow(context.Background(),
		`INSERT INTO mail_messages
		(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
		body, sender_addr, subject, mail_type)
		SELECT
			srv.val->>'user',
			srv.val->>'name',
			$1,
			$2,
			coalesce(srv.val->>'reply_mail', srv.val->>'user'),
			coalesce(srv.val->>'reply_name', srv.val->>'name'),
			$3,
			srv.val->>'user',
			$4,
			$5
		FROM const_mail_server AS srv
		LIMIT 1
		RETURNING id`,
		msg.To_addr,
		msg.To_name,
		msg.Body,
		msg.Subject,
		msg.Mail_type,
		).Scan(&msg_id); err != nil {
	
		if attachments_exist {
			conn.Exec(context.Background(),`ROLLBACK`)
		}
	
		return err	
	}			
		
	if attachments_exist {
		att_q := ""
		att_params := make([]interface{}, len(attachments))
		att_param_ind := 0
		for _, att := range attachments {
			if att_q != "" {
				att_q+= ", "
			}
			att_q+=  fmt.Sprintf("(%d, $%d)", msg_id, att_param_ind+1)
			att_params[att_param_ind] = att
			att_param_ind++
		}
//fmt.Println(`RegisterMail Attachment INSERT INTO mail_message_attachments (mail_message_id, file_name) VALUES `+att_q, "params:", att_params)		
		if _, err := conn.Exec(context.Background(),
			`INSERT INTO mail_message_attachments (mail_message_id, file_name) VALUES `+att_q,
			att_params...); err != nil {
			
			conn.Exec(context.Background(),`ROLLBACK`)
			
			return err
		}
		
		if _, err := conn.Exec(context.Background(),`COMMIT`); err != nil {
			return err
		}
		
	}
	return nil
}

func sendMail(dStore *pgds.PgProvider, l logger.Logger, attachPath string) {
	l.Debug("MailServer: sending mail")			
	
	//slave
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := dStore.GetSecondary("")
	if err != nil {
		l.Debugf("MailServer: dStore.GetPrimary(): %v", err)
		return
	}
	defer dStore.Release(pool_conn, conn_id)
	conn_sec := pool_conn.Conn()

	//master
	var conn_id_m pgds.ServerID
	var pool_conn_m *pgxpool.Conn
	pool_conn_m, conn_id_m, err_m := dStore.GetPrimary()
	if err_m != nil {
		l.Debugf("MailServer: dStore.GetPrimary(): %v", err_m)
		return
	}
	defer dStore.Release(pool_conn_m, conn_id_m)
	conn_m := pool_conn_m.Conn()
	
	if _, err := conn_sec.Prepare(context.Background(),
			MAIL_SERVER_SELECT_Q,
			`WITH m_sender AS (
				SELECT
					coalesce(srv.val->>'smtp_host', '') AS host,
					coalesce(srv.val->>'user', '') AS u_name,
					coalesce(srv.val->>'pwd', '') AS pwd
				FROM const_mail_server AS srv
			)
			SELECT
				m.id,
				(SELECT host FROM m_sender),
				(SELECT u_name FROM m_sender),
				(SELECT pwd FROM m_sender),
				coalesce(m.from_addr, '') AS from_addr,
				coalesce(m.from_name, '') AS from_name,
				coalesce(m.to_addr, '') AS to_addr,
				coalesce(m.to_name, '') AS to_name,
				coalesce(m.reply_name, '') AS reply_name,
				coalesce(m.body, '') AS body,
				coalesce(m.sender_addr, '') AS sender_addr,
				coalesce(m.subject, '') AS subject,
				(SELECT
					ARRAY_AGG(att.file_name)
				FROM mail_message_attachments AS att
				WHERE att.mail_message_id = m.id
				) AS attachments
			FROM mail_messages AS m
			WHERE coalesce(m.sent, FALSE)=FALSE`); err != nil {
		
		l.Debugf("MailServer: conn_sec.Prepare(): %v", err)
		return
	}

	rows, err := conn_sec.Query(context.Background(), MAIL_SERVER_SELECT_Q)
	if err != nil {
		l.Debugf("MailServer MAIL_SERVER_SELECT_Q pgx.conn_sec.Query(): %v",err)
		return
	}	

	if rows.Next() {		
		msg := struct {
			id int
			smtp_host string
			smtp_user string
			smtp_pwd string
			from_addr string
			from_name string
			to_addr string
			to_name string
			reply_name string
			body string
			sender_addr string
			subject string
			attachments []string
		}{}
		
	
		if err := rows.Scan(&msg.id,
				&msg.smtp_host,
				&msg.smtp_user,
				&msg.smtp_pwd,
				&msg.from_addr,
				&msg.from_name,
				&msg.to_addr,
				&msg.to_name,
				&msg.reply_name,
				&msg.body,
				&msg.sender_addr,
				&msg.subject,
				&msg.attachments); err != nil {
			
			l.Debugf("MailServer pgx.Rows.Scan(): %v",err)	
			return
		}
		email_client := gosmtp.NewSender(
			msg.smtp_user,
			msg.smtp_pwd,
			msg.from_addr,
			msg.smtp_host)
			
		var recipients = [][]string{
			{msg.to_addr},
		}
		var files []string
		if msg.attachments != nil && len(msg.attachments)>0 {
			files = make([]string, 0)
			for _, a := range msg.attachments {
				files = append(files, attachPath + a)			
			}
		}
		
		for _, recs := range recipients {
			var email_msg = gosmtp.NewMessage().
				SetTO(recs...).
				SetSubject(msg.subject)
			if strings.Contains(msg.body, "</") && strings.Contains(msg.body, ">"){
				email_msg.SetHTML(msg.body)
			}else{
				email_msg.SetText(msg.body)
			}
			if files != nil && len(files) >0 {
				email_msg.AddAttaches(files...)
			}
			if err := email_client.SendMessage(email_msg); err != nil {
				l.Errorf("MailServer SendMessage(): %v",err)	
				
				if _, err := conn_m.Exec(context.Background(),
					fmt.Sprintf(`UPDATE mail_messages
						SET
							error_str = $1,
							sent = TRUE,
							sent_date_time = now()
						WHERE id = %d`, msg.id), err.Error()); err != nil {
						
					l.Debugf("MailServer UPDATE conn_m.Exec(): %v",err)	
				}		
				
			}else{
				if _, err := conn_m.Exec(context.Background(),
					fmt.Sprintf(`UPDATE mail_messages
						SET
							sent = TRUE,
							sent_date_time = now(),
							error_str = null
						WHERE id = %d`, msg.id)); err != nil {
						
					l.Debugf("MailServer conn_m.Exec(): %v",err)	
				}		
			}
		}
		
	}
}

func StartMailSender(dStore *pgds.PgProvider, l logger.Logger, baseDir string) {
	var conn_id pgds.ServerID
	var pool_conn *pgxpool.Conn
	pool_conn, conn_id, err := dStore.GetSecondary("")
	if err != nil {
		l.Errorf("StartMailSender GetSecondary(): %v", err)
		return
	}
	conn := pool_conn.Conn()

	var check_interval_ms int
	if err := conn.QueryRow(context.Background(),
		`SELECT text_to_int_safe_cast(val->>'check_interval_ms') FROM const_mail_server LIMIT 1`,
		).Scan(&check_interval_ms); err != nil {
		
		dStore.Release(pool_conn, conn_id)
		l.Errorf("StartMailSender conn.QueryRow(): %v", err)
		return
	}
	
	dStore.Release(pool_conn, conn_id)
	quitMailReader = make(chan bool)
		
	go (func(dStore *pgds.PgProvider, l logger.Logger, checkIntervalMS int) {		
	
		l.Debugf("MailServer: starting send mail message loop, interval (ms): %d", checkIntervalMS)
		for {
			select {
			case <- quitMailReader:				
				l.Debug("MailServer: mail message loop is stopped")
				return
			default:		
				sendMail(dStore, l, baseDir + "/" + CACHE_PATH + "/")
				time.Sleep(time.Duration(checkIntervalMS) * time.Millisecond)				
			}
		}						
	})(dStore, l, check_interval_ms)	
}

