-- Function: client_accesses_allowed(in_company_id int)

-- DROP FUNCTION client_accesses_allowed(in_company_id int);

CREATE OR REPLACE FUNCTION client_accesses_allowed(in_company_id int)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT
			(acc.date_to >= now()::date)
			AND (
				acc.doc_1c_ref IS NOT NULL
				AND coalesce(acc.doc_1c_ref->>'ref','') <>''
				AND coalesce(acc.doc_1c_ref->>'payed','') = 'true'
			) AS access_payed
		FROM client_accesses AS acc
		WHERE acc.client_id = in_company_id
		ORDER BY acc.date_to DESC
		LIMIT 1),
		FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION client_accesses_allowed(in_company_id int) OWNER TO ;
