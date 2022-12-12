-- VIEW: public.study_document_insert_selects_list

--DROP VIEW public.study_document_insert_selects_list;

CREATE OR REPLACE VIEW public.study_document_insert_selects_list AS
	SELECT
		t.id
		,t.study_document_insert_head_id
		,h.user_id
		,name_full(t.name_first, t.name_second, t.name_middle) AS name_full
		,study_document_inserts_ref(t) AS ref
		
	FROM public.study_document_inserts AS t
	LEFT JOIN study_document_insert_heads AS h ON h.id = t.study_document_insert_head_id
	WHERE t.id NOT IN (SELECT att.study_document_insert_id FROM study_document_insert_attachments AS att WHERE att.study_document_insert_head_id = t.study_document_insert_head_id)
	ORDER BY name_full
	;
	
ALTER VIEW public.study_document_insert_selects_list OWNER TO ;
