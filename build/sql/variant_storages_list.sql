-- VIEW: public.variant_storages_list

--DROP VIEW public.variant_storages_list;

CREATE OR REPLACE VIEW public.variant_storages_list AS
	SELECT
		t.id
		,t.user_id
		,t.storage_name
		,t.default_variant
		,t.variant_name
	FROM public.variant_storages AS t
	
	ORDER BY 
	;
	
ALTER VIEW public.variant_storages_list OWNER TO ;
