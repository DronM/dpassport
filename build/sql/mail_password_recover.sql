-- Function: mail_password_recover(in_user_id int, in_new_pwd text)

--DROP FUNCTION mail_password_recover(in_user_id int, in_new_pwd text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_password_recover(in_user_id int, in_new_pwd text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'password_recover'::mail_types
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text,'') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('new_pwd', in_new_pwd)::template_value
			],
			(SELECT v FROM templ)
		),'') AS body,				
		coalesce((SELECT s FROM templ),'') AS subject,
		'password_recover'::mail_types AS mail_type
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_password_recover(in_user_id int,in_new_pwd text) OWNER TO ;
