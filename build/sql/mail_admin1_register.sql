-- Function: mail_admin_1_register(in_user_id int)

-- DROP FUNCTION mail_admin_1_register(in_user_id int);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_admin_1_register(in_user_id int)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'admin_1_register'::mail_types
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, ''),
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'admin_1_register'::mail_types
		
	FROM users u
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_admin_1_register(in_user_id int) OWNER TO ;
