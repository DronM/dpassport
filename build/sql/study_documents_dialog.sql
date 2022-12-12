-- VIEW: public.study_documents_dialog

--DROP VIEW public.study_documents_dialog;

CREATE OR REPLACE VIEW public.study_documents_dialog AS
	SELECT
		t.id
		,clients_ref(companies_ref_t) AS companies_ref
		,clients_ref(clients_ref_t) AS clients_ref
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
		,t.study_form
		,t.create_type
		,t.digital_sig		
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_documents' AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachments
		
		,t.create_user_id
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	
	;
	
ALTER VIEW public.study_documents_dialog OWNER TO ;
