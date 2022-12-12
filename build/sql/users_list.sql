-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,coalesce(t.name_full::text, t.name::text) AS name_full
		,t.snils
		,t.sex
		,t.post
		,t.role_id
		,t.phone_cel
		,t.tel_ext
		,clients_ref(clients_ref_t) AS clients_ref
		,t.client_id
		,clients_ref(companies_ref_t) AS companies_ref
		,t.company_id
		,t.person_url
		,t.descr
		
		,(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'users' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'users' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user,
		
		t.viewed,
		t.qr_code_sent_date,
		t.banned
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed ASC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO ;
