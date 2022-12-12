-- Function: client_offer(in_client clients)

-- DROP FUNCTION client_offer(in_client clients);

/*
DROP TYPE client_offer;
CREATE TYPE client_offer_params AS (
    name_full text,
    name text,
    inn text,
    kpp text,
    ogrn text
);
*/

CREATE OR REPLACE FUNCTION client_offer(in_params client_offer_params)
  RETURNS text AS
$$
	WITH contr AS (SELECT const_client_offer_val()->>'contract' AS v)
	SELECT
		coalesce(
			templates_text(
				ARRAY[
					ROW('name_full', in_params.name_full::text)::template_value,
					ROW('name', in_params.name::text)::template_value,
					ROW('inn', in_params.inn::text)::template_value,
					ROW('kpp', in_params.kpp::text)::template_value,
					ROW('ogrn', in_params.ogrn::text)::template_value
				],
				(SELECT v FROM contr)
			),
		'');		
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION client_offer(in_params client_offer_params) OWNER TO ;

