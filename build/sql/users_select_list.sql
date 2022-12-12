-- VIEW: public.users_select_list

--DROP VIEW public.users_select_list;

CREATE OR REPLACE VIEW public.users_select_list AS
	SELECT
		t.id
		,t.descr
		,t.company_id
	FROM public.users AS t
	
	ORDER BY descr ASC
	;
	
ALTER VIEW public.users_select_list OWNER TO ;
