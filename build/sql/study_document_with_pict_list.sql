-- VIEW: public.study_document_with_pict_list

--DROP VIEW public.study_document_with_pict_list;

CREATE OR REPLACE VIEW public.study_document_with_pict_list AS
	SELECT
		t.id
		,t.company_id
		,clients_ref(companies_ref_t) AS companies_ref
		,clients_ref_t.id AS client_id
		,clients_ref(clients_ref_t) AS clients_ref
		,t.study_document_register_id
		,study_document_registers_ref(study_document_registers_ref_t) AS study_document_registers_ref
		,t.user_id
		,users_ref(users_ref_t) AS users_ref
		,t.snils
		,t.issue_date
		,t.end_date
		,t.post
		,t.work_place
		,t.organization
		,t.study_type
		,t.series
		,t.number
		,t.study_prog_name
		,t.profession
		,t.reg_number
		,t.study_period
		,t.name_first
		,t.name_second
		,t.name_middle
		,t.qualification_name		
		,t.create_type
		,t.digital_sig		
		--custom field
		,study_documents_ref(t)->>'descr' AS self_descr
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_documents' AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachments
		
		,t.name_full
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_with_pict_list OWNER TO ;
