-- Function: mail_user_activation(in_user_id int)

-- DROP FUNCTION mail_user_activation(in_user_id int);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_user_activation(in_user_id int)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'user_activation'::mail_types
		),
		qr_ini AS (
			SELECT
				coalesce((SELECT const_qr_code_val()->>'url'),'') AS url
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name)::template_value,
				ROW('client_name', to_char(cl_acc.date_to, 'DD.MM.YY'))::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'user_activation'::mail_types
		
	FROM users u
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	LEFT JOIN (
		SELECT
			client_id,
			max(date_to) AS date_to
		FROM client_accesses
		GROUP BY client_id
	) AS acc_last ON acc_last.client_id = cl.id
	LEFT JOIN client_accesses AS cl_acc ON cl_acc.client_id = cl.id AND cl_acc.date_to = acc_last.date_to
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_user_activation(in_user_id int) OWNER TO ;
