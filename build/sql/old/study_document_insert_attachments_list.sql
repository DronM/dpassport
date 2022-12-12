-- VIEW: public.study_document_insert_attachments_list

DROP VIEW public.study_document_insert_attachments_list;

CREATE OR REPLACE VIEW public.study_document_insert_attachments_list AS
	SELECT
		t.id
		,h.user_id
		,t.study_document_insert_head_id
		,t.study_document_insert_id
		,t.name_full
		,study_document_inserts_ref(l) AS study_document_inserts_ref
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_document_insert_attachments'
			AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachment
		
		
	FROM public.study_document_insert_attachments AS t
	
	LEFT JOIN study_document_insert_heads AS h ON h.id = t.study_document_insert_head_id
	LEFT JOIN study_document_inserts AS l ON l.id = t.study_document_insert_id
	ORDER BY name_full
	;
	
ALTER VIEW public.study_document_insert_attachments_list OWNER TO ;
