-- Function: mail_client_expiration_add(in_interval interval)

-- DROP FUNCTION mail_client_expiration_add(in_interval interval);

CREATE OR REPLACE FUNCTION mail_client_expiration_add(in_interval interval)
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
			expir.to_addr,
			expir.to_name,
			(SELECT reply_addr FROM srv_mail),
			(SELECT reply_name FROM srv_mail),
			expir.body,
			(SELECT sender_addr FROM srv_mail),
			expir.subject,
			expir.mail_type
		FROM mail_client_expiration((
			SELECT
				array_agg(acc.client_id)
			FROM client_accesses AS acc
			WHERE (acc.date_to::date - in_interval) = now()::date
		)) AS expir;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_expiration_add(in_interval interval) OWNER TO ;		
