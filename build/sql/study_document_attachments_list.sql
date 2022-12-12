-- VIEW: public.study_document_attachments_list

--DROP VIEW public.study_document_attachments_list;

CREATE OR REPLACE VIEW public.study_document_attachments_list AS
	SELECT
		t.id
		,t.date_time
		,t.study_documents_ref
		,t.content_info
		,encode(t.content_preview, 'base64') AS content_preview
	FROM public.study_document_attachments AS t
	ORDER BY t.date_time DESC
	
	;
	
ALTER VIEW public.study_document_attachments_list OWNER TO ;
