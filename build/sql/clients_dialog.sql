-- VIEW: public.clients_dialog

--DROP VIEW public.clients_dialog;

CREATE OR REPLACE VIEW public.clients_dialog AS
	SELECT
		t.id
		,t.name
		,t.inn
		,t.create_info
		,t.name_full
		,t.legal_address
		,t.post_address
		,t.kpp
		,t.ogrn
		,t.okpo
		,t.okved
		,clients_ref(cl_p) AS parents_ref
		,t.parent_id
		,t.email
		,t.tel
		,t.viewed
		,t.create_user_id
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	;
	
ALTER VIEW public.clients_dialog OWNER TO ;
