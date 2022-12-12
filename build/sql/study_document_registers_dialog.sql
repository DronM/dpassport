-- VIEW: public.study_document_registers_dialog

--DROP VIEW public.study_document_registers_dialog;

CREATE OR REPLACE VIEW public.study_document_registers_dialog AS
	SELECT
		t.id
		,t.name
		,t.issue_date
		,t.company_id
		,clients_ref(companies_ref_t) AS companies_ref
		,clients_ref_t.id AS client_id
		,clients_ref(clients_ref_t) AS clients_ref
		,t.create_type
		,t.digital_sig
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_document_registers' AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachments
		
		,t.create_user_id
		,t.study_form
		
	FROM public.study_document_registers AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	;
	
ALTER VIEW public.study_document_registers_dialog OWNER TO ;
