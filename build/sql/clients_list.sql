-- VIEW: public.clients_list

--DROP VIEW public.clients_list;

CREATE OR REPLACE VIEW public.clients_list AS
	SELECT
		t.id
		,t.name
		,t.inn
		,t.ogrn
		,t.parent_id
		,clients_ref(cl_p) AS parents_ref
		
		,coalesce(
			CASE WHEN t.parent_id IS NOT NULL THEN
				(SELECT
					cl_acc.date_to >= now()
				FROM client_accesses AS cl_acc
				WHERE t.parent_id = cl_acc.client_id
				ORDER BY  cl_acc.date_to DESC
				LIMIT 1		
				)
			
			ELSE
				(SELECT
					cl_acc.date_to >= now()
				FROM client_accesses AS cl_acc
				WHERE t.id = cl_acc.client_id
				ORDER BY  cl_acc.date_to DESC
				LIMIT 1		
				)
			END,
		FALSE) AS active
		
		,(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		,t.viewed
		,t.create_user_id
		,(t.parent_id IS NULL OR t.parent_id = t.id)  AS no_parent
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY t.viewed ASC, active DESC, t.name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO ;
