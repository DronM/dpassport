-- VIEW: public.companies_list

--DROP VIEW public.companies_list;

CREATE OR REPLACE VIEW public.companies_list AS
	SELECT
		t.id
		,t.name
		,t.inn
		,t.client_id
		,clients_ref(clients_ref_t) AS clients_ref
	FROM public.companies AS t
	
	
	
	
	
	
	
	
	
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = t.client_id
	
	ORDER BY name ASC
	;
	
ALTER VIEW public.companies_list OWNER TO ;
