-- Function: mail_client_expiration(in_client_ar int[])

-- DROP FUNCTION mail_client_expiration(in_client_ar int[]);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиентов


CREATE OR REPLACE FUNCTION mail_client_expiration(in_client_ar int[])
  RETURNS TABLE(
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
  )  AS
$BODY$
	WITH 
		templ AS (
			SELECT
				t.template AS v,
				t.mes_subject AS s
			FROM mail_templates t
			WHERE t.mail_type = 'client_expiration'::mail_types
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, ''),
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value,
				ROW('date_from', p_last.date_from)::template_value,
				ROW('date_to', p_last.date_to)::template_value,
				ROW('days_left', extract(day from p_last.date_to - now()))::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_expiration'::mail_types
		
	FROM users AS u	
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	LEFT JOIN (
		SELECT
			t.client_id,
			max(t.date_to) AS date_to
		FROM client_accesses AS t
		GROUP BY t.client_id
	) AS acc_m ON acc_m.client_id = u.client_id
	LEFT JOIN client_accesses p_last ON p_last.client_id = u.client_id AND p_last.date_to = acc_m.date_to	
	WHERE u.client_id =ANY(in_client_ar) AND u.role_id = 'client_admin1'
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_expiration(in_client_ar int[]) OWNER TO ;
