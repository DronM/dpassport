-- VIEW: public.client_accesses_list

--DROP VIEW public.client_accesses_list;

CREATE OR REPLACE VIEW public.client_accesses_list AS
	SELECT
		t.id
		,clients_ref(clients_ref_t) AS clients_ref
		,t.client_id
		,t.date_from
		,t.date_to
		,t.doc_1c_ref
	FROM public.client_accesses AS t
	
	
	
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = t.client_id
	
	
	
	
	
	
	
	
	
	ORDER BY date_to DESC
	;
	
ALTER VIEW public.client_accesses_list OWNER TO ;
