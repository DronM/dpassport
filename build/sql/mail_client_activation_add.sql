-- Function: mail_client_activation_add(in_client_id int)

-- DROP FUNCTION mail_client_activation_add(in_client_id int);

CREATE OR REPLACE FUNCTION mail_client_activation_add(in_client_id int)
  RETURNS void AS
$BODY$
	INSERT INTO mail_messages
		(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
		body, sender_addr, subject, mail_type)
		WITH srv_mail AS (
			SELECT
				srv.val->>'user' AS from_addr,
				srv.val->>'name' AS from_name,
				coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
				coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
				srv.val->>'user' AS sender_addr
			FROM const_mail_server AS srv
			LIMIT 1
		)
		SELECT
			(SELECT from_addr FROM srv_mail),
			(SELECT from_name FROM srv_mail),
			act.to_addr,
			act.to_name,
			(SELECT reply_addr FROM srv_mail),
			(SELECT reply_name FROM srv_mail),
			act.body,
			(SELECT sender_addr FROM srv_mail),
			act.subject,
			act.mail_type
		FROM mail_client_activation(in_client_id) AS act;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_activation_add(in_client_id int) OWNER TO ;		
