-- VIEW: public.study_document_registers_list

--DROP VIEW public.study_document_registers_list;

CREATE OR REPLACE VIEW public.study_document_registers_list AS
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
		--custom field
		,study_document_registers_ref(t)->>'descr' AS self_descr
		
		,(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_document_registers' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_document_registers' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		,t.create_user_id
		,(SELECT count(*) FROM study_documents AS certs WHERE certs.study_document_register_id = t.id) AS study_document_count
		,(SELECT certs.organization FROM study_documents AS certs WHERE certs.study_document_register_id = t.id LIMIT 1) AS organization
		,t.study_form
		
	FROM public.study_document_registers AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_registers_list OWNER TO ;
