-- Function: mail_client_order(in_client_id int)

-- DROP FUNCTION mail_client_order(in_client_id int);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиента


CREATE OR REPLACE FUNCTION mail_client_order(in_client_id int)
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
			WHERE t.mail_type = 'client_order'::mail_types
		),
		last_payment AS (
			SELECT
				t.date_from,
				t.date_to
			FROM client_accesses AS t
			WHERE t.client_id = in_client_id
			ORDER BY t.date_to DESC
			LIMIT 1		
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', coalesce(u.name_full::text, cl.name::text))::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_order'::mail_types
		
	FROM users AS u
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.company_id = in_client_id AND u.role_id = 'client_admin1'
	LIMIT 1;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_order(in_client_id int) OWNER TO ;
