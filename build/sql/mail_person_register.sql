-- Function: mail_person_register(in_user_id int, in_url text)

-- DROP FUNCTION mail_person_register(in_user_id int, in_url text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_person_register(in_user_id int, in_url text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'person_register'::mail_types
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
				ROW('url', (SELECT url FROM qr_ini)||coalesce(u.person_url,''))::template_value,
				--image with base64 QR
				ROW('qr', users_qr_as_img_tag(u.qr_code))::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'person_register'::mail_types
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_person_register(in_user_id int,in_url text) OWNER TO ;
