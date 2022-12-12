-- VIEW: mail_messages_list

--DROP VIEW mail_messages_list;

CREATE OR REPLACE VIEW mail_messages_list AS
	SELECT
		id,
		date_time,
		from_addr,
		from_name,
		to_addr,
		to_name,
		reply_addr,
		reply_name,
		body AS body_begin,
		--SUBSTRING(body, 1, 100) AS body_begin,
		sender_addr,
		subject,
		sent,
		sent_date_time,
		mail_type,
		error_str,
		(SELECT count(*) FROM mail_message_attachments AS att WHERE att.mail_message_id = m.id) AS attachment_count
		
	FROM mail_messages AS m
	ORDER BY date_time desc
	;
	
ALTER VIEW mail_messages_list OWNER TO ;
