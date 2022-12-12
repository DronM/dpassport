-- ******************* update 21/09/2022 17:38:14 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 22/09/2022 06:51:50 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active,
		
		(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update,
		
		(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 22/09/2022 09:44:11 ******************
-- VIEW: public.study_documents_list

--DROP VIEW public.study_documents_list;

CREATE OR REPLACE VIEW public.study_documents_list AS
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
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_documents_list OWNER TO dpassport;


-- ******************* update 22/09/2022 09:44:25 ******************
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
		
	FROM public.study_document_registers AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_registers_list OWNER TO dpassport;


-- ******************* update 22/09/2022 10:37:40 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF NEW.role_id ='person' AND NEW.person_url IS NULL AND (TG_OP='INSERT' OR OLD.snils <> NEW.snils)
	THEN		
		NEW.person_url = users_gen_url(NEW.snils);
	END IF;
	
	IF TG_OP='INSERT' OR OLD.name <> NEW.name OR OLD.name_full <> NEW.name_full OR OLD.snils <> NEW.snils THEN
		NEW.descr = coalesce(NEW.name_full||', ','')|| NEW.name||coalesce(', '||NEW.snils, '');
	END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 10:37:57 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF NEW.role_id ='person' AND NEW.person_url IS NULL AND (TG_OP='INSERT' OR OLD.snils <> NEW.snils)
	THEN		
		NEW.person_url = users_gen_url(NEW.snils);
	END IF;
	
	IF TG_OP='INSERT' OR OLD.name <> NEW.name OR OLD.name_full <> NEW.name_full OR OLD.snils <> NEW.snils THEN
		NEW.descr = coalesce(NEW.name_full||', ','')|| NEW.name||coalesce(', '||NEW.snils, '');
	END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 10:38:27 ******************
-- Function: public.users_ref(users)

-- DROP FUNCTION public.users_ref(users);

CREATE OR REPLACE FUNCTION public.users_ref(users)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', $1.descr,
		'dataType','users'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.users_ref(users) OWNER TO dpassport;



-- ******************* update 22/09/2022 10:41:17 ******************
-- Function: public.users_ref(users)

-- DROP FUNCTION public.users_ref(users);

CREATE OR REPLACE FUNCTION public.users_ref(users)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', $1.descr,
		'dataType','users'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.users_ref(users) OWNER TO dpassport;



-- ******************* update 22/09/2022 10:45:37 ******************
-- VIEW: public.users_select_list

--DROP VIEW public.users_select_list;

CREATE OR REPLACE VIEW public.users_select_list AS
	SELECT
		t.id
		,t.descr
	FROM public.users AS t
	
	ORDER BY descr ASC
	;
	
ALTER VIEW public.users_select_list OWNER TO dpassport;


-- ******************* update 22/09/2022 10:49:03 ******************
UPDATE users SET descr=coalesce(name_full||', ','')|| name||coalesce(', '||snils, '')


-- ******************* update 22/09/2022 10:51:53 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 22/09/2022 10:56:53 ******************
-- Function: public.study_document_registers_ref(study_document_registers)

-- DROP FUNCTION public.study_document_registers_ref(study_document_registers);

CREATE OR REPLACE FUNCTION public.study_document_registers_ref(study_document_registers)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', 'Протокол '||$1.name||' от '||to_char($1.issue_date, 'dd/mm/YYYY'),
		'dataType','study_document_registers'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.study_document_registers_ref(study_document_registers) OWNER TO dpassport;



-- ******************* update 22/09/2022 12:33:43 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		u.company_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.client_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			FALSE
		) AS client_banned
		
		,u.descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 22/09/2022 12:56:35 ******************
DROP VIEW study_documents_list;
DROP VIEW study_documents_dialog;
DROP VIEW study_document_with_pict_list;
ALTER TABLE study_documents ALTER COLUMN series TYPE text;
ALTER TABLE study_documents ALTER COLUMN number TYPE text;


-- ******************* update 22/09/2022 12:56:44 ******************
-- VIEW: public.study_documents_list

--DROP VIEW public.study_documents_list;

CREATE OR REPLACE VIEW public.study_documents_list AS
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
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_documents_list OWNER TO dpassport;


-- ******************* update 22/09/2022 12:56:53 ******************
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
		,t.create_type
		,t.digital_sig		
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_documents' AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachments
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	
	;
	
ALTER VIEW public.study_documents_dialog OWNER TO dpassport;


-- ******************* update 22/09/2022 12:57:05 ******************
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
		
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_with_pict_list OWNER TO dpassport;


-- ******************* update 22/09/2022 13:00:09 ******************
-- Function: const_study_document_fields_process()

-- DROP FUNCTION const_study_document_fields_process();

CREATE OR REPLACE FUNCTION const_study_document_fields_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		--event
		PERFORM pg_notify('APIServer.change_study_document_fields', null);			
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_study_document_fields_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 13:00:59 ******************
-- Function: const_study_document_register_fields_process()

-- DROP FUNCTION const_study_document_register_fields_process();

CREATE OR REPLACE FUNCTION const_study_document_register_fields_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		--event
		PERFORM pg_notify('APIServer.change_study_document_register_fields', null);			
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_study_document_register_fields_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 13:02:03 ******************
-- Trigger: const_study_document_fields_trigger_after on public.const_study_document_fields

-- DROP TRIGGER const_study_document_fields_trigger_after ON public.const_study_document_fields;


CREATE TRIGGER const_study_document_fields_trigger_after
  AFTER UPDATE
  ON public.const_study_document_fields
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_study_document_fields_process();



-- ******************* update 22/09/2022 13:03:40 ******************
-- Trigger: const_study_document_register_fields_trigger_after on public.const_study_document_register_fields

-- DROP TRIGGER const_study_document_register_fields_trigger_after ON public.const_study_document_register_fields;


CREATE TRIGGER const_study_document_register_fields_trigger_after
  AFTER UPDATE
  ON public.const_study_document_register_fields
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_study_document_fields_process();



-- ******************* update 22/09/2022 13:03:51 ******************
-- Trigger: const_study_document_register_fields_trigger_after on public.const_study_document_register_fields

 DROP TRIGGER const_study_document_register_fields_trigger_after ON public.const_study_document_register_fields;


CREATE TRIGGER const_study_document_register_fields_trigger_after
  AFTER UPDATE
  ON public.const_study_document_register_fields
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_study_document_register_fields_process();



-- ******************* update 22/09/2022 13:03:59 ******************
-- Trigger: const_study_document_fields_trigger_after on public.const_study_document_fields

 DROP TRIGGER const_study_document_fields_trigger_after ON public.const_study_document_fields;


CREATE TRIGGER const_study_document_fields_trigger_after
  AFTER UPDATE
  ON public.const_study_document_fields
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_study_document_fields_process();



-- ******************* update 22/09/2022 13:05:31 ******************
-- Function: const_study_document_fields_process()

-- DROP FUNCTION const_study_document_fields_process();

CREATE OR REPLACE FUNCTION const_study_document_fields_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		--event
		PERFORM pg_notify('StudyDocument.change_fields', null);			
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_study_document_fields_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 13:05:52 ******************
-- Function: const_study_document_register_fields_process()

-- DROP FUNCTION const_study_document_register_fields_process();

CREATE OR REPLACE FUNCTION const_study_document_register_fields_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		--event
		PERFORM pg_notify('StudyDocumentRegister.change_fields', null);			
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_study_document_register_fields_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 14:55:04 ******************
-- VIEW: public.study_documents_list

--DROP VIEW public.study_documents_list;

CREATE OR REPLACE VIEW public.study_documents_list AS
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
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		,(t.end_date > now()::date) AS overdue
		,(t.end_date - now()::date) <=30 AS month_left
		
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_documents_list OWNER TO dpassport;


-- ******************* update 22/09/2022 15:09:53 ******************
-- Function: const_study_document_register_fields_process()

-- DROP FUNCTION const_study_document_register_fields_process();

CREATE OR REPLACE FUNCTION const_study_document_register_fields_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		--event
		PERFORM pg_notify('StudyDocumentRegister.change_fields', null);			
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_study_document_register_fields_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 15:10:09 ******************
-- Function: const_study_document_fields_process()

-- DROP FUNCTION const_study_document_fields_process();

CREATE OR REPLACE FUNCTION const_study_document_fields_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		--event
		PERFORM pg_notify('StudyDocument.change_fields', null);			
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_study_document_fields_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 15:13:57 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"Company":{
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 22/09/2022 15:14:06 ******************
-- Function: public.study_document_registers_ref(study_document_registers)

-- DROP FUNCTION public.study_document_registers_ref(study_document_registers);

CREATE OR REPLACE FUNCTION public.study_document_registers_ref(study_document_registers)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', 'Протокол '||$1.name||' от '||to_char($1.issue_date, 'dd/mm/YYYY'),
		'dataType','study_document_registers'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.study_document_registers_ref(study_document_registers) OWNER TO dpassport;



-- ******************* update 22/09/2022 15:14:13 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 22/09/2022 15:14:20 ******************
-- VIEW: public.users_select_list

--DROP VIEW public.users_select_list;

CREATE OR REPLACE VIEW public.users_select_list AS
	SELECT
		t.id
		,t.descr
	FROM public.users AS t
	
	ORDER BY descr ASC
	;
	
ALTER VIEW public.users_select_list OWNER TO dpassport;


-- ******************* update 22/09/2022 15:14:26 ******************
-- Function: public.users_ref(users)

-- DROP FUNCTION public.users_ref(users);

CREATE OR REPLACE FUNCTION public.users_ref(users)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', $1.descr,
		'dataType','users'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.users_ref(users) OWNER TO dpassport;



-- ******************* update 22/09/2022 15:14:31 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF NEW.role_id ='person' AND NEW.person_url IS NULL AND (TG_OP='INSERT' OR OLD.snils <> NEW.snils)
	THEN		
		NEW.person_url = users_gen_url(NEW.snils);
	END IF;
	
	IF TG_OP='INSERT' OR OLD.name <> NEW.name OR OLD.name_full <> NEW.name_full OR OLD.snils <> NEW.snils THEN
		NEW.descr = coalesce(NEW.name_full||', ','')|| NEW.name||coalesce(', '||NEW.snils, '');
	END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 22/09/2022 15:14:42 ******************
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
		
	FROM public.study_document_registers AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_registers_list OWNER TO dpassport;


-- ******************* update 22/09/2022 15:14:48 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active,
		
		(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update,
		
		(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 22/09/2022 15:15:10 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF NEW.user_id IS NULL AND NEW.snils IS NULL THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF NEW.user_id IS NULL AND NEW.snils IS NOT NULL THEN
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils
			;
			IF NEW.user_id IS NULL THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				client_id, company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				(SELECT 
					cl.parent_id
				FROM clients AS cl
				WHERE cl.id = NEW.company_id),
				NEW.company_id
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 22/09/2022 16:03:06 ******************
-- VIEW: public.study_documents_list

--DROP VIEW public.study_documents_list;

CREATE OR REPLACE VIEW public.study_documents_list AS
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
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		,(t.end_date < now()::date) AS overdue
		,(t.end_date - now()::date) <=30 AS month_left
		
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_documents_list OWNER TO dpassport;


-- ******************* update 22/09/2022 17:10:40 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 22/09/2022 17:10:50 ******************
-- View: users_profile

-- DROP VIEW users_profile;

CREATE OR REPLACE VIEW users_profile AS 
	SELECT
	 	u.id,
	 	u.name,
	 	u.name_full,
	 	u.post,
	 	u.snils,
	 	u.phone_cel,
	 	u.locale_id,
	 	time_zone_locales_ref(tzl) AS time_zone_locales_ref,
	 	u.sex,
	 	u.person_url
	 	
 	FROM users AS u
 	LEFT JOIN time_zone_locales AS tzl ON tzl.id=u.time_zone_locale_id
	;
ALTER TABLE users_profile OWNER TO dpassport;



-- ******************* update 22/09/2022 17:11:07 ******************
-- VIEW: public.users_dialog

--DROP VIEW public.users_dialog CASCADE;

CREATE OR REPLACE VIEW public.users_dialog AS
	SELECT
		t.id
		,t.name
		,t.name_full
		,t.snils
		,t.sex
		,t.post
		,t.role_id
		,t.create_dt
		,t.banned
		,time_zone_locales_ref(time_zone_locales_ref_t) AS time_zone_locales_ref
		,t.phone_cel
		,t.tel_ext
		,t.locale_id
		,t.email_confirmed
		,clients_ref(clients_ref_t) AS clients_ref
		,clients_ref(companies_ref_t) AS companies_ref
		
		,jsonb_build_object(
			'id', md5(now()::text),
			'name', 'photo',
			'size', 0,
			'dataBase64',encode(t.photo, 'base64')
		) AS photo,
		
		t.client_admin
		
	FROM public.users AS t
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = t.client_id
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN time_zone_locales AS time_zone_locales_ref_t ON time_zone_locales_ref_t.id = t.time_zone_locale_id
	;
	
ALTER VIEW public.users_dialog OWNER TO dpassport;


-- ******************* update 22/09/2022 17:11:17 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		u.company_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.client_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			FALSE
		) AS client_banned
		
		,u.descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 22/09/2022 17:12:41 ******************
-- VIEW: public.study_documents_list

--DROP VIEW public.study_documents_list;

CREATE OR REPLACE VIEW public.study_documents_list AS
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
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		,(t.end_date < now()::date) AS overdue
		,(t.end_date - now()::date) <=30 AS month_left
		
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_documents_list OWNER TO dpassport;


-- ******************* update 22/09/2022 17:12:53 ******************
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
		
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_with_pict_list OWNER TO dpassport;


-- ******************* update 22/09/2022 17:13:09 ******************
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
		,t.create_type
		,t.digital_sig		
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_documents' AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachments
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	
	;
	
ALTER VIEW public.study_documents_dialog OWNER TO dpassport;


-- ******************* update 23/09/2022 17:52:29 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"Company":{
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 24/09/2022 07:49:52 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"Company":{
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 27/09/2022 12:05:25 ******************

	/* type get function */
	CREATE OR REPLACE FUNCTION enum_data_types_val(data_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='users'::data_types AND $2='ru'::locales THEN 'Пользователи'
		WHEN $1='study_document_types'::data_types AND $2='ru'::locales THEN 'Виды документов'
		WHEN $1='client_accesses'::data_types AND $2='ru'::locales THEN 'Доступы площадок'
		WHEN $1='clients'::data_types AND $2='ru'::locales THEN 'Площадка'
		WHEN $1='study_document_registers'::data_types AND $2='ru'::locales THEN 'Реестр'
		WHEN $1='study_documents'::data_types AND $2='ru'::locales THEN 'Документ'
		WHEN $1='study_document_attachments'::data_types AND $2='ru'::locales THEN 'Вложение документа'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_data_types_val(data_types,locales) OWNER TO dpassport;		
	
			



-- ******************* update 27/09/2022 12:06:42 ******************

	/* type get function */
	CREATE OR REPLACE FUNCTION enum_data_types_val(data_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='users'::data_types AND $2='ru'::locales THEN 'Пользователи'
		WHEN $1='study_document_types'::data_types AND $2='ru'::locales THEN 'Виды документов'
		WHEN $1='client_accesses'::data_types AND $2='ru'::locales THEN 'Доступы площадок'
		WHEN $1='clients'::data_types AND $2='ru'::locales THEN 'Площадка'
		WHEN $1='study_document_registers'::data_types AND $2='ru'::locales THEN 'Протокол'
		WHEN $1='study_documents'::data_types AND $2='ru'::locales THEN 'Документ'
		WHEN $1='study_document_attachments'::data_types AND $2='ru'::locales THEN 'Вложение документа'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_data_types_val(data_types,locales) OWNER TO dpassport;		
	
			



-- ******************* update 29/09/2022 15:06:23 ******************
-- VIEW: public.clients_dialog

--DROP VIEW public.clients_dialog;

CREATE OR REPLACE VIEW public.clients_dialog AS
	SELECT
		t.id
		,t.name
		,t.inn
		,t.create_info
		,t.name_full
		,t.legal_address
		,t.post_address
		,t.kpp
		,t.ogrn
		,t.okpo
		,t.okved
		,clients_ref(cl_p) AS parents_ref
		,t.parent_id
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	;
	
ALTER VIEW public.clients_dialog OWNER TO dpassport;


-- ******************* update 29/09/2022 15:09:05 ******************
-- VIEW: public.users_dialog

--DROP VIEW public.users_dialog CASCADE;

CREATE OR REPLACE VIEW public.users_dialog AS
	SELECT
		t.id
		,t.name
		,t.name_full
		,t.snils
		,t.sex
		,t.post
		,t.role_id
		,t.create_dt
		,t.banned
		,time_zone_locales_ref(time_zone_locales_ref_t) AS time_zone_locales_ref
		,t.phone_cel
		,t.tel_ext
		,t.locale_id
		,t.email_confirmed
		,clients_ref(clients_ref_t) AS clients_ref
		,clients_ref(companies_ref_t) AS companies_ref
		
		,jsonb_build_object(
			'id', md5(now()::text),
			'name', 'photo',
			'size', 0,
			'dataBase64',encode(t.photo, 'base64')
		) AS photo
		
		,t.client_admin
		,t.company_id
		
	FROM public.users AS t
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = t.client_id
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN time_zone_locales AS time_zone_locales_ref_t ON time_zone_locales_ref_t.id = t.time_zone_locale_id
	;
	
ALTER VIEW public.users_dialog OWNER TO dpassport;


-- ******************* update 29/09/2022 15:09:27 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		) AS last_update_user
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 29/09/2022 15:09:33 ******************
-- VIEW: public.users_select_list

--DROP VIEW public.users_select_list;

CREATE OR REPLACE VIEW public.users_select_list AS
	SELECT
		t.id
		,t.descr
		,t.company_id
	FROM public.users AS t
	
	ORDER BY descr ASC
	;
	
ALTER VIEW public.users_select_list OWNER TO dpassport;


-- ******************* update 29/09/2022 16:18:42 ******************
-- View: public.login_devices_list

-- DROP VIEW public.login_devices_list;

CREATE OR REPLACE VIEW public.login_devices_list
AS
	SELECT
		t.user_id,
		u.name AS user_descr,
		max(t.date_time_in) AS date_time_in,
		login_devices_uniq(t.user_agent) AS user_agent,
		CASE
		WHEN bn.user_id IS NULL THEN false
		ELSE true
		END AS banned,
		md5(login_devices_uniq(t.user_agent)) AS ban_hash,
		u.company_id AS user_company_id
		
	FROM logins t
	LEFT JOIN users u ON u.id = t.user_id
	LEFT JOIN sessions sess ON sess.id::text = t.session_id::text
	LEFT JOIN login_device_bans bn ON bn.user_id = u.id AND bn.hash::text = md5(login_devices_uniq(t.user_agent))
	
	WHERE login_devices_uniq(t.user_agent) IS NOT NULL
	GROUP BY t.user_id, (login_devices_uniq(t.user_agent)), u.name, bn.user_id, u.company_id
	ORDER BY (max(t.date_time_in)) DESC;

ALTER TABLE public.login_devices_list
    OWNER TO dpassport;




-- ******************* update 29/09/2022 16:20:11 ******************
-- View: public.user_mac_addresses_list

-- DROP VIEW public.user_mac_addresses_list;

CREATE OR REPLACE VIEW public.user_mac_addresses_list
AS
	SELECT
		adr.id,
		adr.user_id,
		u.name AS user_descr,
		adr.mac_address,
		u.company_id AS user_company_id
	
	FROM user_mac_addresses adr
	LEFT JOIN users u ON u.id = adr.user_id
	ORDER BY u.name;

ALTER TABLE public.user_mac_addresses_list
    OWNER TO dpassport;




-- ******************* update 29/09/2022 16:33:21 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 29/09/2022 16:39:45 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 29/09/2022 17:03:56 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"UserOperation":{
			"get_object":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"UserOperation":{
			"get_object":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 29/09/2022 17:06:54 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 30/09/2022 07:35:03 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF NEW.role_id ='person' AND NEW.person_url IS NULL AND (TG_OP='INSERT' OR OLD.snils <> NEW.snils)
	THEN		
		NEW.person_url = users_gen_url(NEW.snils);
	END IF;
	
	IF TG_OP='INSERT' OR OLD.name <> NEW.name OR OLD.name_full <> NEW.name_full OR OLD.snils <> NEW.snils THEN
		NEW.descr = coalesce(NEW.name_full,'')||
			coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
			coalesce(' '||NEW.snils, '');
	END IF;
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 30/09/2022 07:41:43 ******************
	
		ALTER TABLE public.study_documents ADD COLUMN name_full text;
		/*
	CREATE INDEX study_documents_study_period_idx
	ON study_documents(study_period);

	DROP INDEX IF EXISTS study_documents_name_second_idx;
	CREATE INDEX study_documents_name_second_idx
	ON study_documents(USING gin (name_second gin_trgm_ops));

	DROP INDEX IF EXISTS study_documents_name_full_idx;
	CREATE INDEX study_documents_name_full_idx
	ON study_documents(USING gin (name_full gin_trgm_ops));

*/


-- ******************* update 30/09/2022 07:47:23 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF NEW.user_id IS NULL AND NEW.snils IS NULL THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF NEW.user_id IS NULL AND NEW.snils IS NOT NULL THEN
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils
			;
			IF NEW.user_id IS NULL THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				NEW.company_id
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 30/09/2022 07:55:41 ******************
-- VIEW: public.study_documents_list

--DROP VIEW public.study_documents_list;

CREATE OR REPLACE VIEW public.study_documents_list AS
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
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		,(t.end_date < now()::date) AS overdue
		,(t.end_date - now()::date) <=30 AS month_left
		
		,t.name_full
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_documents_list OWNER TO dpassport;


-- ******************* update 30/09/2022 07:56:37 ******************
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
	
ALTER VIEW public.study_document_with_pict_list OWNER TO dpassport;


-- ******************* update 30/09/2022 11:14:07 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils
			;
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				NEW.company_id
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 30/09/2022 12:04:24 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') ='' AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,''))
	THEN		
		NEW.person_url = users_gen_url(NEW.snils);
	END IF;
	
	IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
	OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
	OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
	
		NEW.descr = coalesce(NEW.name_full,'')||
			coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
			coalesce(' '||NEW.snils, '');
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 30/09/2022 12:22:22 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 03/10/2022 09:29:49 ******************
-- View: public.login_devices_list

-- DROP VIEW public.login_devices_list;

CREATE OR REPLACE VIEW public.login_devices_list
AS
	SELECT
		t.user_id,
		u.name AS user_descr,
		max(t.date_time_in) AS date_time_in,
		login_devices_uniq(t.user_agent) AS user_agent,
		CASE
			WHEN bn.user_id IS NULL THEN false
			ELSE true
		END AS banned,
		md5(login_devices_uniq(t.user_agent)) AS ban_hash,
		u.company_id AS user_company_id
		
	FROM logins t
	LEFT JOIN users u ON u.id = t.user_id
	LEFT JOIN sessions sess ON sess.id::text = t.session_id::text
	LEFT JOIN login_device_bans bn ON bn.user_id = u.id AND bn.hash::text = md5(login_devices_uniq(t.user_agent))
	
	WHERE login_devices_uniq(t.user_agent) IS NOT NULL
	GROUP BY t.user_id, (login_devices_uniq(t.user_agent)), u.name, bn.user_id, u.company_id
	ORDER BY (max(t.date_time_in)) DESC;

ALTER TABLE public.login_devices_list
    OWNER TO dpassport;




-- ******************* update 04/10/2022 09:02:48 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 04/10/2022 09:29:20 ******************
-- VIEW: public.clients_dialog

--DROP VIEW public.clients_dialog;

CREATE OR REPLACE VIEW public.clients_dialog AS
	SELECT
		t.id
		,t.name
		,t.inn
		,t.create_info
		,t.name_full
		,t.legal_address
		,t.post_address
		,t.kpp
		,t.ogrn
		,t.okpo
		,t.okved
		,clients_ref(cl_p) AS parents_ref
		,t.parent_id
		,t.email
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	;
	
ALTER VIEW public.clients_dialog OWNER TO dpassport;


-- ******************* update 04/10/2022 09:46:07 ******************
-- VIEW: public.clients_dialog

--DROP VIEW public.clients_dialog;

CREATE OR REPLACE VIEW public.clients_dialog AS
	SELECT
		t.id
		,t.name
		,t.inn
		,t.create_info
		,t.name_full
		,t.legal_address
		,t.post_address
		,t.kpp
		,t.ogrn
		,t.okpo
		,t.okved
		,clients_ref(cl_p) AS parents_ref
		,t.parent_id
		,t.email
		,t.tel
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	;
	
ALTER VIEW public.clients_dialog OWNER TO dpassport;


-- ******************* update 04/10/2022 10:31:30 ******************

			
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
				
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
		
			
				
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
									
			
			
									
		
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
		
			
				
			
						
			
			
			
			
			
			
			
			
			
		
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
						
			
			
			
			
			
		
			
				
								
						
			
			
			
			
			
			
			
			
			
			
			
		
									
			
			
			
			
			
			
			
		
			
				
				
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
								
			
			
			
			
			
			
		
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
								
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
			
			
		
			
				
							
						
						
						
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
									
			
			
															
			
			
			
			
		
			
			
			
		
			
			
		
			
				
					
						
			
			
			
			
			
			
			
						
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
									
			
		
			
				
					
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
			
		
	-- ********** constant value table  client_offer *************
	CREATE TABLE IF NOT EXISTS const_client_offer
	(name text  NOT NULL, descr text, val json,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json,
	CONSTRAINT const_client_offer_pkey PRIMARY KEY (name));
	ALTER TABLE const_client_offer OWNER TO dpassport;
	INSERT INTO const_client_offer (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Клиентская оферта'
		,'Клиентская оферта'
		,NULL
		,'JSON'
		,'Constant_client_offer_Edit'
		,NULL
		,NULL
		,NULL
	);
	
		--constant get value
		
	CREATE OR REPLACE FUNCTION const_client_offer_val()
	RETURNS json AS
	$BODY$
		
		SELECT val::json AS val FROM const_client_offer LIMIT 1;
		
	$BODY$
	LANGUAGE sql STABLE COST 100;
	ALTER FUNCTION const_client_offer_val() OWNER TO dpassport;
	
	--constant set value
	CREATE OR REPLACE FUNCTION const_client_offer_set_val(JSON)
	RETURNS void AS
	$BODY$
		UPDATE const_client_offer SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;
	ALTER FUNCTION const_client_offer_set_val(JSON) OWNER TO dpassport;
	
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_client_offer_view AS
	SELECT
		'client_offer'::text AS id
		,t.name
		,t.descr
	,
	t.val::text AS val
	
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_client_offer AS t
	;
	ALTER VIEW const_client_offer_view OWNER TO dpassport;
	
	
	
	CREATE OR REPLACE VIEW constants_list_view AS
	
	SELECT *
	FROM const_doc_per_page_count_view
	UNION ALL
	
	SELECT *
	FROM const_grid_refresh_interval_view
	UNION ALL
	
	SELECT *
	FROM const_session_live_time_view
	UNION ALL
	
	SELECT *
	FROM const_allowed_attachment_extesions_view
	UNION ALL
	
	SELECT *
	FROM const_study_document_fields_view
	UNION ALL
	
	SELECT *
	FROM const_study_document_register_fields_view
	UNION ALL
	
	SELECT *
	FROM const_mail_server_view
	UNION ALL
	
	SELECT *
	FROM const_api_server_view
	UNION ALL
	
	SELECT *
	FROM const_client_offer_view
	ORDER BY name;
	ALTER VIEW constants_list_view OWNER TO dpassport;
	
	


-- ******************* update 04/10/2022 12:14:54 ******************
﻿-- Function: client_offer(in_client clients)

-- DROP FUNCTION client_offer(in_client clients);

CREATE OR REPLACE FUNCTION client_offer(in_client clients)
  RETURNS text AS
$$
	WITH contr AS (SELECT const_client_offer_val()->>'contract' AS v)
	SELECT
		templates_text(
			ARRAY[
				ROW('name_full', in_client.name_full::text)::template_value,
				ROW('name', in_client.name::text)::template_value,
				ROW('inn', in_client.inn::text)::template_value,
				ROW('kpp', in_client.kpp::text)::template_value,
				ROW('ogrn', in_client.ogrn::text)::template_value
			],
			(SELECT v FROM contr)
		);		
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION client_offer(in_client clients) OWNER TO dpassport;


-- ******************* update 04/10/2022 12:18:43 ******************
﻿-- Function: client_offer(in_client clients)

-- DROP FUNCTION client_offer(in_client clients);

CREATE TYPE client_offer AS (
    name_full text,
    name text,
    inn text,
    kpp text,
    ogrn text
);
/*
CREATE OR REPLACE FUNCTION client_offer(in_client record)
  RETURNS text AS
$$
	WITH contr AS (SELECT const_client_offer_val()->>'contract' AS v)
	SELECT
		templates_text(
			ARRAY[
				ROW('name_full', in_client.name_full::text)::template_value,
				ROW('name', in_client.name::text)::template_value,
				ROW('inn', in_client.inn::text)::template_value,
				ROW('kpp', in_client.kpp::text)::template_value,
				ROW('ogrn', in_client.ogrn::text)::template_value
			],
			(SELECT v FROM contr)
		);		
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION client_offer(in_client record) OWNER TO dpassport;
*/


-- ******************* update 04/10/2022 12:19:02 ******************
﻿-- Function: client_offer(in_client clients)

-- DROP FUNCTION client_offer(in_client clients);

DROP TYPE client_offer;
CREATE TYPE client_offer_params AS (
    name_full text,
    name text,
    inn text,
    kpp text,
    ogrn text
);
/*
CREATE OR REPLACE FUNCTION client_offer(in_client record)
  RETURNS text AS
$$
	WITH contr AS (SELECT const_client_offer_val()->>'contract' AS v)
	SELECT
		templates_text(
			ARRAY[
				ROW('name_full', in_client.name_full::text)::template_value,
				ROW('name', in_client.name::text)::template_value,
				ROW('inn', in_client.inn::text)::template_value,
				ROW('kpp', in_client.kpp::text)::template_value,
				ROW('ogrn', in_client.ogrn::text)::template_value
			],
			(SELECT v FROM contr)
		);		
$$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION client_offer(in_client record) OWNER TO dpassport;
*/


-- ******************* update 04/10/2022 12:34:05 ******************
﻿-- Function: client_offer(in_client clients)

-- DROP FUNCTION client_offer(in_client clients);

/*
DROP TYPE client_offer;
CREATE TYPE client_offer_params AS (
    name_full text,
    name text,
    inn text,
    kpp text,
    ogrn text
);
*/

CREATE OR REPLACE FUNCTION client_offer(in_params client_offer_params)
  RETURNS text AS
$$
	WITH contr AS (SELECT const_client_offer_val()->>'contract' AS v)
	SELECT
		templates_text(
			ARRAY[
				ROW('name_full', in_params.name_full::text)::template_value,
				ROW('name', in_params.name::text)::template_value,
				ROW('inn', in_params.inn::text)::template_value,
				ROW('kpp', in_params.kpp::text)::template_value,
				ROW('ogrn', in_params.ogrn::text)::template_value
			],
			(SELECT v FROM contr)
		);		
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION client_offer(in_params client_offer_params) OWNER TO dpassport;



-- ******************* update 04/10/2022 12:38:50 ******************
﻿-- Function: client_offer(in_client clients)

-- DROP FUNCTION client_offer(in_client clients);

/*
DROP TYPE client_offer;
CREATE TYPE client_offer_params AS (
    name_full text,
    name text,
    inn text,
    kpp text,
    ogrn text
);
*/

CREATE OR REPLACE FUNCTION client_offer(in_params client_offer_params)
  RETURNS text AS
$$
	WITH contr AS (SELECT const_client_offer_val()->>'contract' AS v)
	SELECT
		coalesce(
			templates_text(
				ARRAY[
					ROW('name_full', in_params.name_full::text)::template_value,
					ROW('name', in_params.name::text)::template_value,
					ROW('inn', in_params.inn::text)::template_value,
					ROW('kpp', in_params.kpp::text)::template_value,
					ROW('ogrn', in_params.ogrn::text)::template_value
				],
				(SELECT v FROM contr)
			),
		'');		
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION client_offer(in_params client_offer_params) OWNER TO dpassport;



-- ******************* update 04/10/2022 13:47:08 ******************
-- View: users_profile

-- DROP VIEW users_profile;

CREATE OR REPLACE VIEW users_profile AS 
	SELECT
	 	u.id,
	 	u.name,
	 	u.name_full,
	 	u.post,
	 	u.snils,
	 	u.phone_cel,
	 	u.locale_id,
	 	time_zone_locales_ref(tzl) AS time_zone_locales_ref,
	 	u.sex,
	 	u.person_url,
	 	clients_ref(cl) AS companies_ref
	 	
 	FROM users AS u
 	LEFT JOIN time_zone_locales AS tzl ON tzl.id=u.time_zone_locale_id
 	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;
ALTER TABLE users_profile OWNER TO dpassport;



-- ******************* update 04/10/2022 14:06:46 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.client_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			FALSE
		) AS client_banned
		
		,u.descr
		,clients_ref(cl)->>'descr' AS company_descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 04/10/2022 15:32:14 ******************
ALTER TABLE users DROP column client_admin;


-- ******************* update 04/10/2022 15:32:21 ******************
-- VIEW: public.users_dialog

DROP VIEW public.users_dialog CASCADE;

CREATE OR REPLACE VIEW public.users_dialog AS
	SELECT
		t.id
		,t.name
		,t.name_full
		,t.snils
		,t.sex
		,t.post
		,t.role_id
		,t.create_dt
		,t.banned
		,time_zone_locales_ref(time_zone_locales_ref_t) AS time_zone_locales_ref
		,t.phone_cel
		,t.tel_ext
		,t.locale_id
		,t.email_confirmed
		,clients_ref(clients_ref_t) AS clients_ref
		,clients_ref(companies_ref_t) AS companies_ref
		
		,jsonb_build_object(
			'id', md5(now()::text),
			'name', 'photo',
			'size', 0,
			'dataBase64',encode(t.photo, 'base64')
		) AS photo
		
		,t.company_id
		
	FROM public.users AS t
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = t.client_id
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN time_zone_locales AS time_zone_locales_ref_t ON time_zone_locales_ref_t.id = t.time_zone_locale_id
	;
	
ALTER VIEW public.users_dialog OWNER TO dpassport;


-- ******************* update 04/10/2022 15:32:46 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.client_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			FALSE
		) AS client_banned
		
		,u.descr
		,clients_ref(cl)->>'descr' AS company_descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 04/10/2022 15:43:29 ******************
ALTER TABLE clients ADD COLUMN viewed bool default false;


-- ******************* update 04/10/2022 15:43:36 ******************
ALTER TABLE users ADD COLUMN viewed bool default false;


-- ******************* update 04/10/2022 15:43:49 ******************
-- VIEW: public.clients_dialog

--DROP VIEW public.clients_dialog;

CREATE OR REPLACE VIEW public.clients_dialog AS
	SELECT
		t.id
		,t.name
		,t.inn
		,t.create_info
		,t.name_full
		,t.legal_address
		,t.post_address
		,t.kpp
		,t.ogrn
		,t.okpo
		,t.okved
		,clients_ref(cl_p) AS parents_ref
		,t.parent_id
		,t.email
		,t.tel
		,t.viewed
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	;
	
ALTER VIEW public.clients_dialog OWNER TO dpassport;


-- ******************* update 04/10/2022 15:44:06 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active,
		
		(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update,
		
		(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user,
		
		t.viewed
		
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 04/10/2022 15:44:28 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
		t.viewed
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 04/10/2022 15:44:56 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.client_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			FALSE
		) AS client_banned
		
		,u.descr
		,clients_ref(cl)->>'descr' AS company_descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 04/10/2022 16:08:22 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active,
		
		(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update,
		
		(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user,
		
		t.viewed
		
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY t.viewed DESC, t.name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:08:49 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
		t.viewed
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed DESC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:10:11 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
		t.viewed
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed ASC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:10:16 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active,
		
		(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update,
		
		(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user,
		
		t.viewed
		
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY t.viewed ASC, t.name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:10:43 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
		t.viewed
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed DESC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:12:42 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
		t.viewed
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed ASC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:13:45 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
		t.viewed
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed ASC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:35:57 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
		t.viewed
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed DESC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:36:09 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active,
		
		(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update,
		
		(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user,
		
		t.viewed
		
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY t.viewed DESC, t.name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:44:25 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		
		t.viewed
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed ASC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:44:31 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active,
		
		(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update,
		
		(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user,
		
		t.viewed
		
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY t.viewed ASC, t.name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 04/10/2022 16:58:31 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 04/10/2022 17:05:18 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active,
		
		(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update,
		
		(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'clients' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user,
		
		t.viewed
		
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY t.viewed ASC, active DESC, t.name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 05/10/2022 11:20:48 ******************

					ALTER TYPE mail_types ADD VALUE 'user_reset_pwd';
					
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_mail_types_val(mail_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='person_register'::mail_types AND $2='ru'::locales THEN 'Регистрация физического лица'
		WHEN $1='password_recover'::mail_types AND $2='ru'::locales THEN 'Восстановление пароля'
		WHEN $1='admin_1_register'::mail_types AND $2='ru'::locales THEN 'Регистрация администратора тип 1'
		WHEN $1='client_activation'::mail_types AND $2='ru'::locales THEN 'Активация площадки'
		WHEN $1='client_expiration'::mail_types AND $2='ru'::locales THEN 'Предупреждение об окончании срока оплаты площадки'
		WHEN $1='user_reset_pwd'::mail_types AND $2='ru'::locales THEN 'Восстановление пароля пользователя'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_mail_types_val(mail_types,locales) OWNER TO dpassport;		
	
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
				
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
		
			
				
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
									
			
			
									
		
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
		
			
				
				
								
			
						
			
			
			
			
			
			
						
			
						
			
		
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
						
			
			
			
			
			
		
			
				
								
						
			
			
			
			
			
			
			
			
			
			
			
		
									
			
			
			
			
			
			
			
		
			
				
				
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
								
			
			
			
			
			
			
		
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
								
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
			
			
		
			
				
							
						
						
						
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
									
			
			
															
			
			
			
			
		
			
			
			
		
			
			
		
			
				
					
						
			
			
			
			
			
			
			
						
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
									
			
		
			
				
					
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
			
		

-- ******************* update 05/10/2022 11:21:34 ******************
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_mail_types_val(mail_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='person_register'::mail_types AND $2='ru'::locales THEN 'Регистрация физического лица'
		WHEN $1='password_recover'::mail_types AND $2='ru'::locales THEN 'Восстановление пароля'
		WHEN $1='admin_1_register'::mail_types AND $2='ru'::locales THEN 'Регистрация администратора тип 1'
		WHEN $1='client_activation'::mail_types AND $2='ru'::locales THEN 'Активация площадки'
		WHEN $1='client_expiration'::mail_types AND $2='ru'::locales THEN 'Предупреждение об окончании срока оплаты площадки'
		WHEN $1='user_reset_pwd'::mail_types AND $2='ru'::locales THEN 'Сброс пароля пользователя'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_mail_types_val(mail_types,locales) OWNER TO dpassport;		
	
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
				
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
		
			
				
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
									
			
			
									
		
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
		
			
				
				
								
			
						
			
			
			
			
			
			
						
			
						
			
		
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
						
			
			
			
			
			
		
			
				
								
						
			
			
			
			
			
			
			
			
			
			
			
		
									
			
			
			
			
			
			
			
		
			
				
				
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
								
			
			
			
			
			
			
		
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
								
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
			
			
		
			
				
							
						
						
						
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
									
			
			
															
			
			
			
			
		
			
			
			
		
			
			
		
			
				
					
						
			
			
			
			
			
			
			
						
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
									
			
		
			
				
					
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
			
		


-- ******************* update 05/10/2022 11:24:33 ******************

					ALTER TYPE mail_types ADD VALUE 'client_registration';
					
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_mail_types_val(mail_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='person_register'::mail_types AND $2='ru'::locales THEN 'Регистрация физического лица'
		WHEN $1='password_recover'::mail_types AND $2='ru'::locales THEN 'Восстановление пароля'
		WHEN $1='admin_1_register'::mail_types AND $2='ru'::locales THEN 'Регистрация администратора тип 1'
		WHEN $1='client_activation'::mail_types AND $2='ru'::locales THEN 'Активация площадки'
		WHEN $1='client_registration'::mail_types AND $2='ru'::locales THEN 'Регистрация новой площадки'
		WHEN $1='client_expiration'::mail_types AND $2='ru'::locales THEN 'Предупреждение об окончании срока оплаты площадки'
		WHEN $1='user_reset_pwd'::mail_types AND $2='ru'::locales THEN 'Сброс пароля пользователя'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_mail_types_val(mail_types,locales) OWNER TO dpassport;		
	
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
				
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
		
			
				
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
									
			
			
									
		
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
		
			
				
				
								
			
						
			
			
			
			
			
			
						
			
						
			
		
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
						
			
			
			
			
			
		
			
				
								
						
			
			
			
			
			
			
			
			
			
			
			
		
									
			
			
			
			
			
			
			
		
			
				
				
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
								
			
			
			
			
			
			
		
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
								
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
			
			
		
			
				
							
						
						
						
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
									
			
			
															
			
			
			
			
		
			
			
			
		
			
			
		
			
				
					
						
			
			
			
			
			
			
			
						
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
									
			
		
			
				
					
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
			
		


-- ******************* update 05/10/2022 11:39:14 ******************
-- Function: mail_password_recover(in_user_id int, in_new_pwd text)

--DROP FUNCTION mail_password_recover(in_user_id int, in_new_pwd text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_password_recover(in_user_id int, in_new_pwd text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'password_recover'::mail_types
		)	
	SELECT
		u.name::text,
		u.name_full::text,
		templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('new_pwd', in_new_pwd)::template_value
			],
			(SELECT v FROM templ)
		),				
		(SELECT s FROM templ),
		'password_recover'::mail_types
		
	FROM users u
	WHERE u.id = in_user_id AND coalesce(u.name,'')<>'';
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_password_recover(in_user_id int,in_new_pwd text) OWNER TO dpassport;


-- ******************* update 05/10/2022 11:41:24 ******************
-- Function: mail_password_recover(in_user_id int, in_new_pwd text)

--DROP FUNCTION mail_password_recover(in_user_id int, in_new_pwd text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_password_recover(in_user_id int, in_new_pwd text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'password_recover'::mail_types
		)	
	SELECT
		u.name::text,
		u.name_full::text,
		templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('new_pwd', in_new_pwd)::template_value
			],
			(SELECT v FROM templ)
		),				
		(SELECT s FROM templ),
		'password_recover'::mail_types
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_password_recover(in_user_id int,in_new_pwd text) OWNER TO dpassport;


-- ******************* update 05/10/2022 11:52:52 ******************
-- Function: mail_password_recover(in_user_id int, in_new_pwd text)

--DROP FUNCTION mail_password_recover(in_user_id int, in_new_pwd text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_password_recover(in_user_id int, in_new_pwd text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'password_recover'::mail_types
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text,'') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('new_pwd', in_new_pwd)::template_value
			],
			(SELECT v FROM templ)
		),'') AS body,				
		coalesce((SELECT s FROM templ),'') AS subject,
		'password_recover'::mail_types AS mail_type
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_password_recover(in_user_id int,in_new_pwd text) OWNER TO dpassport;


-- ******************* update 05/10/2022 11:53:52 ******************
-- Function: mail_password_recover(in_user_id int, in_new_pwd text)

--DROP FUNCTION mail_password_recover(in_user_id int, in_new_pwd text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_password_recover(in_user_id int, in_new_pwd text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'password_recover'::mail_types
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text,'') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('new_pwd', in_new_pwd)::template_value
			],
			(SELECT v FROM templ)
		),'') AS body,				
		coalesce((SELECT s FROM templ),'') AS subject,
		'password_recover'::mail_types AS mail_type
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_password_recover(in_user_id int,in_new_pwd text) OWNER TO dpassport;


-- ******************* update 05/10/2022 12:27:49 ******************
-- Function: mail_admin_1_register(in_user_id int)

-- DROP FUNCTION mail_admin_1_register(in_user_id int);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_admin_1_register(in_user_id int)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'admin_1_register'::mail_types
		)	
	SELECT
		u.name::text,
		coalesce(u.name_full::text, ''),
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'admin_1_register'::mail_types
		
	FROM users u
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_admin_1_register(in_user_id int) OWNER TO dpassport;


-- ******************* update 05/10/2022 12:28:11 ******************
-- Function: mail_admin_1_register(in_user_id int)

-- DROP FUNCTION mail_admin_1_register(in_user_id int);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_admin_1_register(in_user_id int)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'admin_1_register'::mail_types
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, ''),
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'admin_1_register'::mail_types
		
	FROM users u
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_admin_1_register(in_user_id int) OWNER TO dpassport;


-- ******************* update 05/10/2022 12:29:10 ******************
-- Function: mail_person_register(in_user_id int, in_url text)

-- DROP FUNCTION mail_person_register(in_user_id int, in_url text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_person_register(in_user_id int, in_url text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'person_register'::mail_types
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, ''),
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('url', in_url)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'person_register'::mail_types
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_person_register(in_user_id int,in_url text) OWNER TO dpassport;


-- ******************* update 05/10/2022 12:29:26 ******************
-- Function: mail_person_register(in_user_id int, in_url text)

-- DROP FUNCTION mail_person_register(in_user_id int, in_url text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_person_register(in_user_id int, in_url text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'person_register'::mail_types
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('url', in_url)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'person_register'::mail_types
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_person_register(in_user_id int,in_url text) OWNER TO dpassport;


-- ******************* update 05/10/2022 12:30:07 ******************
-- Function: mail_client_activation(in_client_id int)

-- DROP FUNCTION mail_client_activation(in_client_id int);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиента


CREATE OR REPLACE FUNCTION mail_client_activation(in_client_id int)
  RETURNS TABLE(
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
  )  AS
$BODY$
	WITH 
		templ AS (
			SELECT
				t.template AS v,
				t.mes_subject AS s
			FROM mail_templates t
			WHERE t.mail_type = 'client_activation'::mail_types
		),
		last_payment AS (
			SELECT
				t.date_from,
				t.date_to
			FROM client_accesses AS t
			WHERE t.client_id = in_client_id
			ORDER BY t.date_to DESC
			LIMIT 1		
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value,
				ROW('date_from', (SELECT date_from FROM last_payment))::template_value,
				ROW('date_to', (SELECT date_to FROM last_payment))::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_activation'::mail_types
		
	FROM users AS u	
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.client_id = in_client_id AND u.role_id = 'client_admin1'
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_activation(in_client_id int) OWNER TO dpassport;


-- ******************* update 05/10/2022 12:30:41 ******************
-- Function: mail_client_expiration(in_client_ar int[])

-- DROP FUNCTION mail_client_expiration(in_client_ar int[]);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиентов


CREATE OR REPLACE FUNCTION mail_client_expiration(in_client_ar int[])
  RETURNS TABLE(
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
  )  AS
$BODY$
	WITH 
		templ AS (
			SELECT
				t.template AS v,
				t.mes_subject AS s
			FROM mail_templates t
			WHERE t.mail_type = 'client_expiration'::mail_types
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, ''),
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value,
				ROW('date_from', p_last.date_from)::template_value,
				ROW('date_to', p_last.date_to)::template_value,
				ROW('days_left', extract(day from p_last.date_to - now()))::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_expiration'::mail_types
		
	FROM users AS u	
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	LEFT JOIN (
		SELECT
			t.client_id,
			max(t.date_to) AS date_to
		FROM client_accesses AS t
		GROUP BY t.client_id
	) AS acc_m ON acc_m.client_id = u.client_id
	LEFT JOIN client_accesses p_last ON p_last.client_id = u.client_id AND p_last.date_to = acc_m.date_to	
	WHERE u.client_id =ANY(in_client_ar) AND u.role_id = 'client_admin1'
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_expiration(in_client_ar int[]) OWNER TO dpassport;


-- ******************* update 05/10/2022 13:11:15 ******************

			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
				
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
		
			
				
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
									
			
			
									
		
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
		
			
				
				
								
			
						
			
			
			
			
			
			
						
			
						
			
		
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
						
			
			
			
			
			
		
			
				
								
						
			
			
			
			
			
			
			
			
			
			
			
		
									
			
			
			
			
			
			
			
		
			
				
				
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
								
			
			
			
			
			
			
		
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
								
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
			
			
			
		
			
				
							
						
						
						
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
									
			
			
															
			
			
			
			
		
			
			
			
		
			
			
		
			
				
					
						
			
			
			
			
			
			
			
						
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
									
			
		
			
				
					
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
			
		
	
	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'10007',
	'StudyType_Controller',
	'get_list',
	'StudyTypeList',
	'Справочники',
	'Виды обучения',
	FALSE
	);
	
	
	
	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'10008',
	'Profession_Controller',
	'get_list',
	'ProfessionList',
	'Справочники',
	'Профессии',
	FALSE
	);
	
	
	
	-- Adding menu item
	INSERT INTO views
	(id,c,f,t,section,descr,limited)
	VALUES (
	'10009',
	'Qualification_Controller',
	'get_list',
	'QualificationList',
	'Справочники',
	'Квалификации',
	FALSE
	);
	
	

-- ******************* update 05/10/2022 13:13:11 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 05/10/2022 13:25:41 ******************
	CREATE INDEX professions_name_idx
	ON professions USING gin(lower(name) gin_trgm_ops);



-- ******************* update 05/10/2022 16:12:32 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
		}
		,"StudyDocumentInsertAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 06/10/2022 10:33:55 ******************
ALTER TABLE public.study_document_insert_heads ADD COLUMN common_issue_date date,
ADD COLUMN common_end_date date,
ADD COLUMN common_post text,
ADD COLUMN common_work_place text,
ADD COLUMN common_organization text,
ADD COLUMN common_study_type text,
ADD COLUMN common_series text,
ADD COLUMN common_study_prog_name text,
ADD COLUMN common_profession text,
ADD COLUMN common_study_period text,
ADD COLUMN common_qualification_name text;



-- ******************* update 06/10/2022 10:42:06 ******************
-- VIEW: public.study_document_insert_heads_list

--DROP VIEW public.study_document_insert_heads_list;

CREATE OR REPLACE VIEW public.study_document_insert_heads_list AS
	SELECT
		t.id
		,t.register_name
		,t.register_date
		,clients_ref(companies_ref_t) AS companies_ref
		,t.company_id
		,t.user_id
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_document_insert_heads' AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS register_attachment,
		
		(SELECT count(cert.*) FROM study_document_inserts AS cert WHERE cert.study_document_insert_head_id = t.id) AS study_document_count
		
		,common_end_date
		,common_post
		,common_work_place
		,common_organization
		,common_study_type
		,common_series
		,common_study_prog_name
		,common_profession
		,common_study_period
		,common_qualification_name
		
	FROM public.study_document_insert_heads AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	ORDER BY t.register_date DESC
	;
	
ALTER VIEW public.study_document_insert_heads_list OWNER TO dpassport;


-- ******************* update 06/10/2022 10:42:58 ******************
-- VIEW: public.study_document_insert_heads_list

--DROP VIEW public.study_document_insert_heads_list;

CREATE OR REPLACE VIEW public.study_document_insert_heads_list AS
	SELECT
		t.id
		,t.register_name
		,t.register_date
		,clients_ref(companies_ref_t) AS companies_ref
		,t.company_id
		,t.user_id
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_document_insert_heads' AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS register_attachment,
		
		(SELECT count(cert.*) FROM study_document_inserts AS cert WHERE cert.study_document_insert_head_id = t.id) AS study_document_count
		
		,common_end_date
		,common_post
		,common_work_place
		,common_organization
		,common_study_type
		,common_series
		,common_study_prog_name
		,common_profession
		,common_study_period
		,common_qualification_name
		
	FROM public.study_document_insert_heads AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	ORDER BY t.register_date DESC
	;
	
ALTER VIEW public.study_document_insert_heads_list OWNER TO dpassport;


-- ******************* update 06/10/2022 10:45:51 ******************
-- VIEW: public.study_document_insert_heads_list

DROP VIEW public.study_document_insert_heads_list;

CREATE OR REPLACE VIEW public.study_document_insert_heads_list AS
	SELECT
		t.id
		,t.register_name
		,t.register_date
		,clients_ref(companies_ref_t) AS companies_ref
		,t.company_id
		,t.user_id
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_document_insert_heads' AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS register_attachment,
		
		(SELECT count(cert.*) FROM study_document_inserts AS cert WHERE cert.study_document_insert_head_id = t.id) AS study_document_count

		,common_issue_date		
		,common_end_date
		,common_post
		,common_work_place
		,common_organization
		,common_study_type
		,common_series
		,common_study_prog_name
		,common_profession
		,common_study_period
		,common_qualification_name
		
	FROM public.study_document_insert_heads AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	ORDER BY t.register_date DESC
	;
	
ALTER VIEW public.study_document_insert_heads_list OWNER TO dpassport;


-- ******************* update 06/10/2022 12:07:17 ******************
DROP TRIGGER study_document_inserts_trigger_before ON public.study_document_inserts;
/*
    CREATE TRIGGER study_document_inserts_trigger_before
    BEFORE DELETE
    ON public.study_document_inserts
    FOR EACH ROW
    EXECUTE PROCEDURE public.study_document_inserts_process();
*/  
DROP TRIGGER study_document_inserts_trigger_after ON public.study_document_inserts;
/*

    CREATE TRIGGER study_document_inserts_trigger_after
    AFTER UPDATE
    ON public.study_document_inserts
    FOR EACH ROW
    EXECUTE PROCEDURE public.study_document_inserts_process();
*/


-- ******************* update 06/10/2022 12:07:21 ******************
-- Function: study_document_inserts_process()

 DROP FUNCTION study_document_inserts_process();

--Более не используется!!!
/*
CREATE OR REPLACE FUNCTION study_document_inserts_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='AFTER' AND TG_OP='UPDATE' THEN
		IF 
			coalesce(NEW.name_first)<>coalesce(OLD.name_first) OR
			coalesce(NEW.name_second)<>coalesce(OLD.name_second) OR
			coalesce(NEW.name_middle)<>coalesce(OLD.name_middle)
		THEN
			UPDATE study_document_insert_attachments
			SET name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle)
			WHERE
				study_document_insert_head_id = NEW.study_document_insert_head_id
				AND study_document_insert_id = NEW.id;

		END IF;
				
		RETURN NEW;
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_insert_attachments
		WHERE
			study_document_insert_head_id = OLD.study_document_insert_head_id
			AND study_document_insert_id = OLD.id;
		
		RETURN OLD;		
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_document_inserts_process() OWNER TO dpassport;
*/


-- ******************* update 06/10/2022 12:19:45 ******************
-- VIEW: public.study_document_insert_attachments_list

DROP VIEW public.study_document_insert_attachments_list;

CREATE OR REPLACE VIEW public.study_document_insert_attachments_list AS
	SELECT
		t.id
		,h.user_id
		,t.study_document_insert_head_id
		,t.name_first AS name_full--name_full(t.name_first, t.name_second, t.name_middle) AS name_full
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_document_insert_attachments'
			AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachment
		
		
	FROM public.study_document_inserts AS t
	
	LEFT JOIN study_document_insert_heads AS h ON h.id = t.study_document_insert_head_id
	ORDER BY name_full
	;
	
ALTER VIEW public.study_document_insert_attachments_list OWNER TO dpassport;


-- ******************* update 06/10/2022 12:21:11 ******************
-- VIEW: public.study_document_insert_attachments_list

DROP VIEW public.study_document_insert_attachments_list;

CREATE OR REPLACE VIEW public.study_document_insert_attachments_list AS
	SELECT
		t.id
		,h.user_id
		,t.study_document_insert_head_id
		,name_full(t.name_first, t.name_second, t.name_middle) AS name_full
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_document_insert_attachments'
			AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachment
		
		
	FROM public.study_document_inserts AS t
	
	LEFT JOIN study_document_insert_heads AS h ON h.id = t.study_document_insert_head_id
	ORDER BY name_full
	;
	
ALTER VIEW public.study_document_insert_attachments_list OWNER TO dpassport;


-- ******************* update 06/10/2022 12:24:18 ******************
-- VIEW: public.study_document_insert_attachments_list

DROP VIEW public.study_document_insert_attachments_list;

CREATE OR REPLACE VIEW public.study_document_insert_attachments_list AS
	SELECT
		t.id
		,h.user_id
		,t.study_document_insert_head_id
		,name_full(t.name_first, t.name_second, t.name_middle) AS name_full
		
		,(SELECT
			jsonb_agg(
				att.content_info || jsonb_build_object('dataBase64',encode(att.content_preview, 'base64'))
			)
		FROM study_document_attachments att
		WHERE att.study_documents_ref->>'dataType' = 'study_document_inserts'
			AND (att.study_documents_ref->'keys'->>'id')::int = t.id
		) AS attachment
		
		
	FROM public.study_document_inserts AS t
	
	LEFT JOIN study_document_insert_heads AS h ON h.id = t.study_document_insert_head_id
	ORDER BY name_full
	;
	
ALTER VIEW public.study_document_insert_attachments_list OWNER TO dpassport;


-- ******************* update 06/10/2022 15:09:21 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				NEW.company_id
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 06/10/2022 15:10:27 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
RAISE EXCEPTION 'STOP';	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				NEW.company_id
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 06/10/2022 15:10:50 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				NEW.company_id
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 06/10/2022 15:11:06 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				NEW.company_id
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 06/10/2022 16:03:27 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 06/10/2022 16:10:34 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 06/10/2022 16:14:19 ******************
ALTER TABLE public.study_documents ADD COLUMN create_user_id int;
		
	CREATE INDEX study_documents_create_user_id_idx
	ON study_documents(create_user_id);



-- ******************* update 06/10/2022 16:18:55 ******************
ALTER TABLE public.study_document_registers ADD COLUMN create_user_id int;
		
	CREATE INDEX study_document_create_user_idx
	ON study_document_registers(create_user_id);



-- ******************* update 06/10/2022 16:19:27 ******************
-- VIEW: public.study_documents_list

--DROP VIEW public.study_documents_list;

CREATE OR REPLACE VIEW public.study_documents_list AS
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
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		,(t.end_date < now()::date) AS overdue
		,(t.end_date - now()::date) <=30 AS month_left
		
		,t.name_full
		,t.create_user_id
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_documents_list OWNER TO dpassport;


-- ******************* update 06/10/2022 16:19:42 ******************
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
		
	FROM public.study_document_registers AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_registers_list OWNER TO dpassport;


-- ******************* update 06/10/2022 16:20:12 ******************
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
		
	FROM public.study_document_registers AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	;
	
ALTER VIEW public.study_document_registers_dialog OWNER TO dpassport;


-- ******************* update 06/10/2022 16:20:24 ******************
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
	
ALTER VIEW public.study_documents_dialog OWNER TO dpassport;


-- ******************* update 06/10/2022 16:23:36 ******************
ALTER TABLE public.clients ADD COLUMN create_user_id int;
		
	CREATE INDEX clients_create_user_idx
	ON clients(create_user_id);



-- ******************* update 06/10/2022 16:24:22 ******************
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
		
		,coalesce((SELECT
			cl_acc.date_to >= now()
		FROM client_accesses AS cl_acc
		WHERE t.id = cl_acc.client_id
		ORDER BY  cl_acc.date_to DESC
		LIMIT 1		
		), FALSE) AS active
		
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
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY t.viewed ASC, active DESC, t.name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 06/10/2022 16:24:34 ******************
-- VIEW: public.clients_dialog

--DROP VIEW public.clients_dialog;

CREATE OR REPLACE VIEW public.clients_dialog AS
	SELECT
		t.id
		,t.name
		,t.inn
		,t.create_info
		,t.name_full
		,t.legal_address
		,t.post_address
		,t.kpp
		,t.ogrn
		,t.okpo
		,t.okved
		,clients_ref(cl_p) AS parents_ref
		,t.parent_id
		,t.email
		,t.tel
		,t.viewed
		,t.create_user_id
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	;
	
ALTER VIEW public.clients_dialog OWNER TO dpassport;


-- ******************* update 06/10/2022 16:37:02 ******************
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
		
	FROM public.clients AS t
	LEFT JOIN clients AS cl_p ON cl_p.id = t.parent_id
	
	ORDER BY t.viewed ASC, active DESC, t.name ASC
	;
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 06/10/2022 17:00:26 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 06/10/2022 17:17:09 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 07/10/2022 08:15:01 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"update":true
			,"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 10/10/2022 14:16:43 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') ='' AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,''))
	THEN		
		NEW.person_url = users_gen_url(NEW.snils);
	END IF;
	
	IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
		NEW.name = trim(NEW.name);
	END IF;
	IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
		NEW.name_full = trim(NEW.name_full);
	END IF;
	IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		NEW.snils = trim(NEW.snils);
	END IF;
	IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
		NEW.post = trim(NEW.post);
	END IF;
	IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
		NEW.post = trim(NEW.post);
	END IF;
	
	IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
	OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
	OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
	
		NEW.descr = coalesce(NEW.name_full,'')||
			coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
			coalesce(' '||NEW.snils, '');
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 10/10/2022 14:18:49 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				NEW.company_id
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'') THEN
			NEW.name_first = trim(NEW.name_first);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_second,'') <> coalesce(NEW.name_second,'') THEN
			NEW.name_second = trim(NEW.name_second);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'') THEN
			NEW.name_middle = trim(NEW.name_middle);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 11/10/2022 08:46:08 ******************
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
		
	FROM public.study_document_registers AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_registers_list OWNER TO dpassport;


-- ******************* update 11/10/2022 08:50:16 ******************
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
		
	FROM public.study_document_registers AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_document_registers_list OWNER TO dpassport;


-- ******************* update 11/10/2022 09:12:09 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"update":true
			,"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 11/10/2022 09:21:18 ******************
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
	
ALTER VIEW public.study_document_registers_list OWNER TO dpassport;


-- ******************* update 11/10/2022 09:21:42 ******************
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
	
ALTER VIEW public.study_document_registers_dialog OWNER TO dpassport;


-- ******************* update 11/10/2022 10:59:03 ******************
	
		ALTER TABLE public.study_documents ADD COLUMN study_form text;
	CREATE INDEX study_documents_study_form_idx
	ON study_documents USING gin(study_form gin_trgm_ops);



-- ******************* update 11/10/2022 11:00:26 ******************
-- VIEW: public.study_documents_list

DROP VIEW public.study_documents_list;

CREATE OR REPLACE VIEW public.study_documents_list AS
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
		,t.study_form
		,t.create_type
		,t.digital_sig		
		--custom field
		,study_documents_ref(t)->>'descr' AS self_descr
		
		,(SELECT
			m_log.date_time
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update
		
		,(SELECT
			m_log.user_descr
		FROM object_mod_log AS m_log
		WHERE m_log.object_type = 'study_documents' AND m_log.object_id = t.id
		ORDER BY m_log.date_time DESC
		LIMIT 1
		) AS last_update_user
		
		,(t.end_date < now()::date) AS overdue
		,(t.end_date - now()::date) <=30 AS month_left
		
		,t.name_full
		,t.create_user_id
		
	FROM public.study_documents AS t
	
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	LEFT JOIN users AS users_ref_t ON users_ref_t.id = t.user_id
	LEFT JOIN study_document_registers AS study_document_registers_ref_t ON study_document_registers_ref_t.id = t.study_document_register_id
	ORDER BY issue_date DESC
	;
	
ALTER VIEW public.study_documents_list OWNER TO dpassport;


-- ******************* update 11/10/2022 11:00:51 ******************
-- VIEW: public.study_documents_dialog

DROP VIEW public.study_documents_dialog;

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
	
ALTER VIEW public.study_documents_dialog OWNER TO dpassport;


-- ******************* update 11/10/2022 11:09:24 ******************
ALTER TABLE public.study_document_insert_heads ADD COLUMN common_study_form text;



-- ******************* update 11/10/2022 11:09:54 ******************
ALTER TABLE public.study_document_inserts ADD COLUMN common_study_form text;



-- ******************* update 11/10/2022 11:12:04 ******************
-- View: public.study_document_insert_heads_list

-- DROP VIEW public.study_document_insert_heads_list;

CREATE OR REPLACE VIEW public.study_document_insert_heads_list
 AS
 SELECT t.id,
    t.register_name,
    t.register_date,
    clients_ref(companies_ref_t.*) AS companies_ref,
    t.company_id,
    t.user_id,
    ( SELECT jsonb_agg(att.content_info || jsonb_build_object('dataBase64', encode(att.content_preview, 'base64'::text))) AS jsonb_agg
           FROM study_document_attachments att
          WHERE (att.study_documents_ref ->> 'dataType'::text) = 'study_document_insert_heads'::text AND (((att.study_documents_ref -> 'keys'::text) ->> 'id'::text)::integer) = t.id) AS register_attachment,
    ( SELECT count(cert.*) AS count
           FROM study_document_inserts cert
          WHERE cert.study_document_insert_head_id = t.id) AS study_document_count,
    t.common_issue_date,
    t.common_end_date,
    t.common_post,
    t.common_work_place,
    t.common_organization,
    t.common_study_type,
    t.common_series,
    t.common_study_prog_name,
    t.common_profession,
    t.common_study_period,
    t.common_qualification_name,
    t.common_study_form
    
   FROM study_document_insert_heads t
     LEFT JOIN clients companies_ref_t ON companies_ref_t.id = t.company_id
  ORDER BY t.register_date DESC;

ALTER TABLE public.study_document_insert_heads_list
    OWNER TO dpassport;




-- ******************* update 11/10/2022 11:13:43 ******************
ALTER TABLE public.study_document_inserts DROP COLUMN _study_form;
ALTER TABLE public.study_document_inserts ADD COLUMN study_form text;



-- ******************* update 11/10/2022 11:13:45 ******************
-- VIEW: public.study_document_inserts_list

--DROP VIEW public.study_document_inserts_list;

CREATE OR REPLACE VIEW public.study_document_inserts_list AS
	SELECT
		t.id
		,t.study_document_insert_head_id
		,h.user_id
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
		,name_full(t.name_first, t.name_second, t.name_middle) AS name_full
		,t.study_form
		
	FROM public.study_document_inserts AS t
	
	LEFT JOIN study_document_insert_heads AS h ON h.id = study_document_insert_head_id
	;
	
ALTER VIEW public.study_document_inserts_list OWNER TO dpassport;


-- ******************* update 11/10/2022 12:36:20 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.company_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			FALSE
		) AS client_banned
		
		,u.descr
		,clients_ref(cl)->>'descr' AS company_descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 11/10/2022 13:00:45 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF (coalesce(OLD.banned, FALSE) = FLASE AND coalesce(NEW.banned, FALSE) = TRUE) THEN
			--user ban
			UPDATE logins SET date_time_out = now() WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = NEW.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins SET date_time_out = now() WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 13:03:54 ******************
-- Trigger: users_trigger_before on public.users

-- DROP TRIGGER users_trigger_before ON public.users;

/*
CREATE TRIGGER users_trigger_before
  BEFORE UPDATE OR INSERT
  ON public.users
  FOR EACH ROW
  EXECUTE PROCEDURE public.users_process();
*/

-- Trigger: users_trigger_after on public.users

-- DROP TRIGGER users_trigger_after ON public.users;


CREATE TRIGGER users_trigger_after
  AFTER UPDATE OR DELETE
  ON public.users
  FOR EACH ROW
  EXECUTE PROCEDURE public.users_process();



-- ******************* update 11/10/2022 13:05:37 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF (coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE) THEN
			--user ban
			UPDATE logins SET date_time_out = now() WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = NEW.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins SET date_time_out = now() WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 13:07:30 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN
			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins SET date_time_out = now() WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins SET date_time_out = now() WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 13:09:35 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN
			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 13:10:27 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN
			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
RAISE EXCEPTION 'OLD.banned=%, NEW.banned=%', coalesce(OLD.banned, FALSE), coalesce(NEW.banned, FALSE);			
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 13:10:32 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN
RAISE EXCEPTION 'OLD.banned=%, NEW.banned=%', coalesce(OLD.banned, FALSE), coalesce(NEW.banned, FALSE);					
			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 13:11:54 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN
--RAISE EXCEPTION 'OLD.banned=%, NEW.banned=%', coalesce(OLD.banned, FALSE), coalesce(NEW.banned, FALSE);					
			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 14:20:43 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
RAISE EXCEPTION 'OLD.banned=%, NEW.banned=%', coalesce(OLD.banned, FALSE), coalesce(NEW.banned, FALSE);								
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 14:21:36 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
RAISE EXCEPTION 'session_id=%', (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 14:22:18 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
RAISE EXCEPTION 'NEW.id=%, session_id=%', NEW.id, (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 14:23:40 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN

				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 14:23:47 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
RAISE EXCEPTION 'NEW.id=%, session_id=%', NEW.id, (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 14:25:33 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
RAISE EXCEPTION 'NEW.id=%, session_id=%', NEW.id, (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL)
				AND date_time_out IS NULL;
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				)
			AND date_time_out IS NULL;
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 14:27:05 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
RAISE EXCEPTION 'NEW.id=%, session_id=%', NEW.id, (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL)
				AND date_time_out IS NULL;
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				)
			AND date_time_out IS NULL;
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 14:27:14 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
/*RAISE EXCEPTION 'NEW.id=%, session_id=%', NEW.id, (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
*/					
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL)
				AND date_time_out IS NULL;
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				)
			AND date_time_out IS NULL;
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 16:12:48 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
/*RAISE EXCEPTION 'NEW.id=%, session_id=%', NEW.id, (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
*/					
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				)AND date_time_out IS NULL;
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 16:13:45 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
/*RAISE EXCEPTION 'NEW.id=%, session_id=%', NEW.id, (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
*/					
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE session_id = 
					(SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE session_id = 
				(SELECT
					session_id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 11/10/2022 16:15:08 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
/*RAISE EXCEPTION 'NEW.id=%, session_id=%', NEW.id, (SELECT
						session_id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL);								
*/					
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 13/10/2022 14:17:11 ******************

			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
				
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
		
			
				
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
									
			
			
									
		
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
		
			
				
				
								
			
						
			
			
			
			
			
			
						
			
						
			
			
		
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
						
			
			
			
			
			
		
			
				
								
						
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
		
									
			
			
			
			
			
			
			
			
			
		
			
				
				
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
						
									
			
								
			
			
			
			
			
			
			
		
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
								
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
						
									
			
			
			
			
		
			
				
							
						
						
						
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
									
			
			
															
			
			
			
			
		
			
			
			
		
			
			
		
			
				
					
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
									
			
		
			
				
					
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
		
	-- ********** constant value table  server_1c *************
	CREATE TABLE IF NOT EXISTS const_server_1c
	(name text  NOT NULL, descr text, val json,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json,
	CONSTRAINT const_server_1c_pkey PRIMARY KEY (name));
	ALTER TABLE const_server_1c OWNER TO dpassport;
	INSERT INTO const_server_1c (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Интеграция с 1с'
		,'Данные по интеграции с 1с'
		,NULL
		,'JSON'
		,NULL
		,NULL
		,NULL
		,NULL
	);
	
		--constant get value
		
	CREATE OR REPLACE FUNCTION const_server_1c_val()
	RETURNS json AS
	$BODY$
		
		SELECT val::json AS val FROM const_server_1c LIMIT 1;
		
	$BODY$
	LANGUAGE sql STABLE COST 100;
	ALTER FUNCTION const_server_1c_val() OWNER TO dpassport;
	
	--constant set value
	CREATE OR REPLACE FUNCTION const_server_1c_set_val(JSON)
	RETURNS void AS
	$BODY$
		UPDATE const_server_1c SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;
	ALTER FUNCTION const_server_1c_set_val(JSON) OWNER TO dpassport;
	
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_server_1c_view AS
	SELECT
		'server_1c'::text AS id
		,t.name
		,t.descr
	,
	t.val::text AS val
	
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_server_1c AS t
	;
	ALTER VIEW const_server_1c_view OWNER TO dpassport;
	
	
	-- ********** constant value table  qr_code *************
	CREATE TABLE IF NOT EXISTS const_qr_code
	(name text  NOT NULL, descr text, val json,
		val_type text,ctrl_class text,ctrl_options json, view_class text,view_options json,
	CONSTRAINT const_qr_code_pkey PRIMARY KEY (name));
	ALTER TABLE const_qr_code OWNER TO dpassport;
	INSERT INTO const_qr_code (name,descr,val,val_type,ctrl_class,ctrl_options,view_class,view_options) VALUES (
		'Генерация QR кодов'
		,'Настройка генерации QR кодов'
		,NULL
		,'JSON'
		,NULL
		,NULL
		,NULL
		,NULL
	);
	
		--constant get value
		
	CREATE OR REPLACE FUNCTION const_qr_code_val()
	RETURNS json AS
	$BODY$
		
		SELECT val::json AS val FROM const_qr_code LIMIT 1;
		
	$BODY$
	LANGUAGE sql STABLE COST 100;
	ALTER FUNCTION const_qr_code_val() OWNER TO dpassport;
	
	--constant set value
	CREATE OR REPLACE FUNCTION const_qr_code_set_val(JSON)
	RETURNS void AS
	$BODY$
		UPDATE const_qr_code SET val=$1;
	$BODY$
	LANGUAGE sql VOLATILE COST 100;
	ALTER FUNCTION const_qr_code_set_val(JSON) OWNER TO dpassport;
	
	--edit view: all keys and descr
	CREATE OR REPLACE VIEW const_qr_code_view AS
	SELECT
		'qr_code'::text AS id
		,t.name
		,t.descr
	,
	t.val::text AS val
	
	,t.val_type::text AS val_type
	,t.ctrl_class::text
	,t.ctrl_options::json
	,t.view_class::text
	,t.view_options::json
	FROM const_qr_code AS t
	;
	ALTER VIEW const_qr_code_view OWNER TO dpassport;
	
	
	
	CREATE OR REPLACE VIEW constants_list_view AS
	
	SELECT *
	FROM const_doc_per_page_count_view
	UNION ALL
	
	SELECT *
	FROM const_grid_refresh_interval_view
	UNION ALL
	
	SELECT *
	FROM const_session_live_time_view
	UNION ALL
	
	SELECT *
	FROM const_allowed_attachment_extesions_view
	UNION ALL
	
	SELECT *
	FROM const_study_document_fields_view
	UNION ALL
	
	SELECT *
	FROM const_study_document_register_fields_view
	UNION ALL
	
	SELECT *
	FROM const_mail_server_view
	UNION ALL
	
	SELECT *
	FROM const_api_server_view
	UNION ALL
	
	SELECT *
	FROM const_client_offer_view
	UNION ALL
	
	SELECT *
	FROM const_server_1c_view
	UNION ALL
	
	SELECT *
	FROM const_qr_code_view
	ORDER BY name;
	ALTER VIEW constants_list_view OWNER TO dpassport;
	
	

-- ******************* update 14/10/2022 08:21:41 ******************
ALTER TABLE public.users ADD COLUMN qr_code bytea;



-- ******************* update 14/10/2022 08:23:27 ******************
-- VIEW: public.users_dialog

--DROP VIEW public.users_dialog CASCADE;

CREATE OR REPLACE VIEW public.users_dialog AS
	SELECT
		t.id
		,t.name
		,t.name_full
		,t.snils
		,t.sex
		,t.post
		,t.role_id
		,t.create_dt
		,t.banned
		,time_zone_locales_ref(time_zone_locales_ref_t) AS time_zone_locales_ref
		,t.phone_cel
		,t.tel_ext
		,t.locale_id
		,t.email_confirmed
		,clients_ref(clients_ref_t) AS clients_ref
		,clients_ref(companies_ref_t) AS companies_ref
		
		,jsonb_build_object(
			'id', 'user_photo'||t.id::text,
			'name', 'photo',
			'size', 0,
			'dataBase64',encode(t.photo, 'base64')
		) AS photo
		
		,t.company_id
		,t.viewed
		,jsonb_build_object(
			'id', 'user_qr_code'||t.id::text,
			'name', 'qr_code',
			'size', 0,
			'dataBase64',encode(t.qr_code, 'base64')
		) AS qr_code
		
	FROM public.users AS t
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = t.client_id
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN time_zone_locales AS time_zone_locales_ref_t ON time_zone_locales_ref_t.id = t.time_zone_locale_id
	;
	
ALTER VIEW public.users_dialog OWNER TO dpassport;


-- ******************* update 14/10/2022 08:23:57 ******************
-- View: users_profile

-- DROP VIEW users_profile;

CREATE OR REPLACE VIEW users_profile AS 
	SELECT
	 	u.id,
	 	u.name,
	 	u.name_full,
	 	u.post,
	 	u.snils,
	 	u.phone_cel,
	 	u.locale_id,
	 	time_zone_locales_ref(tzl) AS time_zone_locales_ref,
	 	u.sex,
	 	u.person_url,
	 	clients_ref(cl) AS companies_ref
		,jsonb_build_object(
			'id', 'user_qr_code'||u.id::text,
			'name', 'qr_code',
			'size', 0,
			'dataBase64',encode(u.qr_code, 'base64')
		) AS qr_code
	 	
 	FROM users AS u
 	LEFT JOIN time_zone_locales AS tzl ON tzl.id=u.time_zone_locale_id
 	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;
ALTER TABLE users_profile OWNER TO dpassport;



-- ******************* update 14/10/2022 09:28:15 ******************

					ALTER TYPE mail_types ADD VALUE 'person_url';
					
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_mail_types_val(mail_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='person_register'::mail_types AND $2='ru'::locales THEN 'Регистрация физического лица'
		WHEN $1='password_recover'::mail_types AND $2='ru'::locales THEN 'Восстановление пароля'
		WHEN $1='admin_1_register'::mail_types AND $2='ru'::locales THEN 'Регистрация администратора тип 1'
		WHEN $1='client_activation'::mail_types AND $2='ru'::locales THEN 'Активация площадки'
		WHEN $1='client_registration'::mail_types AND $2='ru'::locales THEN 'Регистрация новой площадки'
		WHEN $1='client_expiration'::mail_types AND $2='ru'::locales THEN 'Предупреждение об окончании срока оплаты площадки'
		WHEN $1='person_url'::mail_types AND $2='ru'::locales THEN 'Персональная ссылка для входа в личный кабинет'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_mail_types_val(mail_types,locales) OWNER TO dpassport;		



-- ******************* update 14/10/2022 09:37:06 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"update":true
			,"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 14/10/2022 09:46:32 ******************
-- VIEW: public.users_dialog

--DROP VIEW public.users_dialog CASCADE;

CREATE OR REPLACE VIEW public.users_dialog AS
	SELECT
		t.id
		,t.name
		,t.name_full
		,t.snils
		,t.sex
		,t.post
		,t.role_id
		,t.create_dt
		,t.banned
		,time_zone_locales_ref(time_zone_locales_ref_t) AS time_zone_locales_ref
		,t.phone_cel
		,t.tel_ext
		,t.locale_id
		,t.email_confirmed
		,clients_ref(clients_ref_t) AS clients_ref
		,clients_ref(companies_ref_t) AS companies_ref
		
		,jsonb_build_object(
			'id', 'user_photo'||t.id::text,
			'name', 'photo',
			'size', 0,
			'dataBase64',encode(t.photo, 'base64')
		) AS photo
		
		,t.company_id
		,t.viewed
		,encode(t.qr_code, 'base64') AS qr_code
		
	FROM public.users AS t
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = t.client_id
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN time_zone_locales AS time_zone_locales_ref_t ON time_zone_locales_ref_t.id = t.time_zone_locale_id
	;
	
ALTER VIEW public.users_dialog OWNER TO dpassport;


-- ******************* update 14/10/2022 09:46:42 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.company_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			FALSE
		) AS client_banned
		
		,u.descr
		,clients_ref(cl)->>'descr' AS company_descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 14/10/2022 09:48:05 ******************
-- View: users_profile

 DROP VIEW users_profile;

CREATE OR REPLACE VIEW users_profile AS 
	SELECT
	 	u.id,
	 	u.name,
	 	u.name_full,
	 	u.post,
	 	u.snils,
	 	u.phone_cel,
	 	u.locale_id,
	 	time_zone_locales_ref(tzl) AS time_zone_locales_ref,
	 	u.sex,
	 	u.person_url,
	 	clients_ref(cl) AS companies_ref
		,encode(u.qr_code, 'base64') AS qr_code
	 	
 	FROM users AS u
 	LEFT JOIN time_zone_locales AS tzl ON tzl.id=u.time_zone_locale_id
 	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;
ALTER TABLE users_profile OWNER TO dpassport;



-- ******************* update 14/10/2022 12:31:07 ******************
﻿-- Function: users_qr_as_img_tag(in_qr bytea)

-- DROP FUNCTION users_qr_as_img_tag(in_qr bytea);

CREATE OR REPLACE FUNCTION users_qr_as_img_tag(in_qr bytea)
  RETURNS text AS
$$
	SELECT '<img src="data:image/png;base64,  '||encode(in_qr, 'base64')||'" </img>';
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION users_qr_as_img_tag(in_qr bytea) OWNER TO dpassport;


-- ******************* update 14/10/2022 12:32:27 ******************
-- Function: mail_person_register(in_user_id int, in_url text)

-- DROP FUNCTION mail_person_register(in_user_id int, in_url text);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_person_register(in_user_id int, in_url text)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'person_register'::mail_types
		),
		qr_ini AS (
			SELECT
				coalesce((SELECT const_qr_code_val()->>'url'),'') AS url
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('url', (SELECT url FROM qr_ini)||coalesce(u.person_url,''))::template_value,
				--image with base64 QR
				ROW('qr', users_qr_as_img_tag(u.qr_code))::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'person_register'::mail_types
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_person_register(in_user_id int,in_url text) OWNER TO dpassport;


-- ******************* update 14/10/2022 12:36:34 ******************
-- Function: mail_person_url(in_user_id int)

-- DROP FUNCTION mail_person_register(in_user_id int);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_person_url(in_user_id int)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'person_url'::mail_types
		),
		qr_ini AS (
			SELECT
				coalesce((SELECT const_qr_code_val()->>'url'),'') AS url
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('url', (SELECT url FROM qr_ini)||coalesce(u.person_url,''))::template_value,
				--image with base64 QR
				ROW('qr', users_qr_as_img_tag(u.qr_code))::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'person_url'::mail_types
		
	FROM users u
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_person_url(in_user_id int) OWNER TO dpassport;


-- ******************* update 14/10/2022 17:11:45 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_list_for_person":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_list_for_person":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"update":true
			,"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_list_for_person":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_list_for_person":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 14/10/2022 18:00:12 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"update":true
			,"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 20/10/2022 09:49:58 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				--set parent!
				(SELECT coalesce(cl.parent_id, cl.id) FROM clients AS cl WHERE cl.id = NEW.company_id)
				)
				RETURNING id INTO NEW.user_id;				
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'') THEN
			NEW.name_first = trim(NEW.name_first);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_second,'') <> coalesce(NEW.name_second,'') THEN
			NEW.name_second = trim(NEW.name_second);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'') THEN
			NEW.name_middle = trim(NEW.name_middle);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 22/10/2022 05:12:52 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.company_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			TRUE
		) AS client_banned
		
		,u.descr
		,clients_ref(cl)->>'descr' AS company_descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 22/10/2022 05:18:00 ******************
ALTER TABLE users ADD COLUMN qr_code_sent_date timestampTZ;


-- ******************* update 22/10/2022 05:18:02 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
		t.qr_code_sent_date
		
		
	FROM public.users AS t
	LEFT JOIN clients AS companies_ref_t ON companies_ref_t.id = t.company_id
	LEFT JOIN clients AS clients_ref_t ON clients_ref_t.id = companies_ref_t.parent_id
	
	ORDER BY t.viewed ASC, t.name_full ASC
	;
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 22/10/2022 05:34:32 ******************
-- Function: public.study_document_registers_ref(study_document_registers)

-- DROP FUNCTION public.study_document_registers_ref(study_document_registers);

CREATE OR REPLACE FUNCTION public.study_document_registers_ref(study_document_registers)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		--'descr', 'Протокол '||$1.name||' от '||to_char($1.issue_date, 'dd/mm/YYYY'),
		'descr', coalesce($1.name, to_char($1.issue_date, 'dd/mm/YYYY')),
		'dataType','study_document_registers'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.study_document_registers_ref(study_document_registers) OWNER TO dpassport;



-- ******************* update 22/10/2022 05:38:29 ******************

					ALTER TYPE mail_types ADD VALUE 'user_activation';
					
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_mail_types_val(mail_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='person_register'::mail_types AND $2='ru'::locales THEN 'Регистрация физического лица'
		WHEN $1='password_recover'::mail_types AND $2='ru'::locales THEN 'Восстановление пароля'
		WHEN $1='admin_1_register'::mail_types AND $2='ru'::locales THEN 'Регистрация администратора тип 1'
		WHEN $1='client_activation'::mail_types AND $2='ru'::locales THEN 'Активация площадки'
		WHEN $1='client_registration'::mail_types AND $2='ru'::locales THEN 'Регистрация новой площадки'
		WHEN $1='client_expiration'::mail_types AND $2='ru'::locales THEN 'Предупреждение об окончании срока оплаты площадки'
		WHEN $1='person_url'::mail_types AND $2='ru'::locales THEN 'Персональная ссылка для входа в личный кабинет'
		WHEN $1='user_activation'::mail_types AND $2='ru'::locales THEN 'Активация пользователя'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_mail_types_val(mail_types,locales) OWNER TO dpassport;		
	



-- ******************* update 22/10/2022 05:45:33 ******************
-- Function: mail_user_activation(in_user_id int)

-- DROP FUNCTION mail_user_activation(in_user_id int);

-- Все функции по одному шаблону: возвращают структуру

CREATE OR REPLACE FUNCTION mail_user_activation(in_user_id int)
  RETURNS mail_message  AS
$BODY$
	WITH 
		templ AS (
		SELECT
			t.template AS v,
			t.mes_subject AS s
		FROM mail_templates t
		WHERE t.mail_type = 'user_activation'::mail_types
		),
		qr_ini AS (
			SELECT
				coalesce((SELECT const_qr_code_val()->>'url'),'') AS url
		)	
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'user_activation'::mail_types
		
	FROM users u
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	WHERE u.id = in_user_id;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_user_activation(in_user_id int) OWNER TO dpassport;


-- ******************* update 22/10/2022 06:10:53 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				PERFORM mail_user_activation(NEW.id);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 22/10/2022 06:13:15 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				RAISE EXCEPTION 'mail_user_activation';
				PERFORM mail_user_activation(NEW.id);
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 22/10/2022 06:16:23 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_user_activation(NEW.id) AS act
				;
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 22/10/2022 06:17:51 ******************
-- VIEW: public.users_list

--DROP VIEW public.users_list;

CREATE OR REPLACE VIEW public.users_list AS
	SELECT
		t.id
		,t.name
		,t.name_full
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
	
ALTER VIEW public.users_list OWNER TO dpassport;


-- ******************* update 22/10/2022 06:26:51 ******************
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
	
ALTER VIEW public.clients_list OWNER TO dpassport;


-- ******************* update 22/10/2022 09:25:38 ******************
﻿-- Function: clients_check(in_client clients)

-- DROP FUNCTION clients_check(in_client clients);

CREATE OR REPLACE FUNCTION clients_check(in_client clients)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE (in_client.id IS NOT NULL AND cl.id<>in_client.id)
			AND (in_client.parent_id IS NOT NULL AND cl.parent_id = in_client.parent_id)
			AND 
				(
					(in_client.inn = cl.inn AND coalesce(in_client.kpp,'') = coalesce(cl.kpp,''))
					OR lower(in_client.name) = lower(cl.name)
					OR in_client.ogrn = cl.ogrn
				)
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client clients) OWNER TO dpassport;


-- ******************* update 22/10/2022 09:29:51 ******************
﻿-- Function: clients_check(in_client clients)

 DROP FUNCTION clients_check(in_client clients);

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE (in_client_id IS NOT NULL AND cl.id<>in_client_id)
			AND (in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					OR lower(in_client_name) = lower(cl.name)
					OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 09:34:22 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE (in_client_id IS NOT NULL AND cl.id<>in_client_id)
			AND (in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					OR lower(in_client_name) = lower(cl.name)
					--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 09:36:32 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE (in_client_id IS NULL OR cl.id<>in_client_id)
			AND (in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					OR lower(in_client_name) = lower(cl.name)
					--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 09:36:49 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE (in_client_id IS NULL OR cl.id<>in_client_id)
			AND (in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					OR lower(in_client_name) = lower(cl.name)
					--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
		LIMIT 1
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 09:48:54 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE (in_client_id IS NULL OR cl.id<>in_client_id)
			AND 	(
					(in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
					OR
					(in_client_parent_id IS NULL AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
					OR
					(in_client_parent_id = in_client_id AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
				)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					OR lower(in_client_name) = lower(cl.name)
					--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
		LIMIT 1
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 09:56:39 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE
			(in_client_id IS NULL OR in_client_id >= 1000000000)
			AND (in_client_id IS NULL OR cl.id<>in_client_id)
			AND 	(
					(in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
					OR
					(in_client_parent_id IS NULL AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
					OR
					(in_client_parent_id = in_client_id AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
				)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					OR lower(in_client_name) = lower(cl.name)
					--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
		LIMIT 1
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 10:09:51 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE
			(in_client_id IS NULL OR in_client_id >= 1000000000)
			AND (in_client_id IS NULL OR cl.id<>in_client_id)
			AND 	(
					(in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
					OR
					(in_client_parent_id IS NULL AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
					OR
					(in_client_parent_id = in_client_id AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
				)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					--ЗАБИТЬ!!!
					--OR lower(in_client_name) = lower(cl.name)
					--ВКЛЮЧИТЬ В РАБОЧЕЙ!!!
					--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
		LIMIT 1
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 10:11:50 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE	NOT(
			(in_client_id IS NULL OR in_client_id >= 1000000000)
			AND (in_client_id IS NULL OR cl.id<>in_client_id)
			AND 	(
					(in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
					OR
					(in_client_parent_id IS NULL AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
					OR
					(in_client_parent_id = in_client_id AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
				)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					--ЗАБИТЬ!!!
					--OR lower(in_client_name) = lower(cl.name)
					--ВКЛЮЧИТЬ В РАБОЧЕЙ!!!
					--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
			)
		LIMIT 1
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 10:11:57 ******************
ALTER TABLE clients ADD CONSTRAINT clients_clients_check CHECK (clients_check(id,parent_id,inn,kpp,ogrn,name));


-- ******************* update 22/10/2022 10:12:26 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

-- ALTER TABLE clients ADD CONSTRAINT clients_clients_check CHECK (clients_check(id,parent_id,inn,kpp,ogrn,name));
-- ALTER TABLE clients DROP CONSTRAINT clients_clients_check;

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT TRUE
		FROM clients AS cl
		WHERE	NOT(
			(in_client_id IS NULL OR in_client_id >= 1000000000)
			AND (in_client_id IS NULL OR cl.id<>in_client_id)
			AND 	(
					(in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
					OR
					(in_client_parent_id IS NULL AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
					OR
					(in_client_parent_id = in_client_id AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
				)
			AND 
				(
					(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					--ЗАБИТЬ!!!
					--OR lower(in_client_name) = lower(cl.name)
					--ВКЛЮЧИТЬ В РАБОЧЕЙ!!!
					--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
				)
			)
		LIMIT 1
		), FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 10:23:59 ******************
﻿-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

-- ALTER TABLE clients ADD CONSTRAINT clients_clients_check CHECK (clients_check(id,parent_id,inn,kpp,ogrn,name));
-- ALTER TABLE clients DROP CONSTRAINT clients_clients_check;

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT
		--Верные
		CASE WHEN in_client_id < 1000000000 THEN TRUE
		ELSE
			--Поиск дубля
			coalesce(
				(SELECT
					TRUE
				FROM clients AS cl
				WHERE  
					--Не есть он сам
					(in_client_id IS NULL OR cl.id<>in_client_id)
					AND 	(
							(in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
							OR
							(in_client_parent_id IS NULL AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
							OR
							(in_client_parent_id = in_client_id AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
						)
					AND	(
							(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					
							--ЗАБИТЬ!!!
							--OR lower(in_client_name) = lower(cl.name)
							--ВКЛЮЧИТЬ В РАБОЧЕЙ!!!
							--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
						)
				LIMIT 1)
			, FALSE) = FALSE
		END
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO dpassport;


-- ******************* update 22/10/2022 10:51:15 ******************
﻿-- Function: users_gen_url(in_url text)

-- DROP FUNCTION users_gen_url(in_url text);

CREATE OR REPLACE FUNCTION users_gen_url(in_url text)
  RETURNS text AS
$$
	SELECT md5(gen_random_uuid()::text);
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION users_gen_url(in_url text) OWNER TO dpassport;


-- ******************* update 22/10/2022 10:52:42 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_user_activation(NEW.id) AS act
				;
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 24/10/2022 07:50:37 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		IF OLD.qr_code IS NULL AND NEW.qr_code IS NOT NULL THEN
			--mail QR url
			INSERT INTO mail_messages
				(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
				body, sender_addr, subject, mail_type)
				WITH srv_mail AS (
					SELECT
						srv.val->>'user' AS from_addr,
						srv.val->>'name' AS from_name,
						coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
						coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
						srv.val->>'user' AS sender_addr
					FROM const_mail_server AS srv
					LIMIT 1
				)
				SELECT	
					(SELECT from_addr FROM srv_mail),
					(SELECT from_name FROM srv_mail),
					act.to_addr,
					act.to_name,
					(SELECT reply_addr FROM srv_mail),
					(SELECT reply_name FROM srv_mail),
					act.body,
					(SELECT sender_addr FROM srv_mail),
					act.subject,
					act.mail_type
				FROM mail_person_url(NEW.id) AS act
			;
			NEW.qr_code_sent_date = now();
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_user_activation(NEW.id) AS act
				;
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 24/10/2022 07:54:20 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		IF NEW.qr_code IS NOT NULL AND (TG_OP='INSERT' OR OLD.qr_code IS NULL)  THEN
			--mail QR url
			INSERT INTO mail_messages
				(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
				body, sender_addr, subject, mail_type)
				WITH srv_mail AS (
					SELECT
						srv.val->>'user' AS from_addr,
						srv.val->>'name' AS from_name,
						coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
						coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
						srv.val->>'user' AS sender_addr
					FROM const_mail_server AS srv
					LIMIT 1
				)
				SELECT	
					(SELECT from_addr FROM srv_mail),
					(SELECT from_name FROM srv_mail),
					act.to_addr,
					act.to_name,
					(SELECT reply_addr FROM srv_mail),
					(SELECT reply_name FROM srv_mail),
					act.body,
					(SELECT sender_addr FROM srv_mail),
					act.subject,
					act.mail_type
				FROM mail_person_url(NEW.id) AS act
			;
			NEW.qr_code_sent_date = now();
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_user_activation(NEW.id) AS act
				;
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 24/10/2022 07:56:57 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				--set parent!
				(SELECT coalesce(cl.parent_id, cl.id) FROM clients AS cl WHERE cl.id = NEW.company_id)
				)
				RETURNING id INTO NEW.user_id;
				
				-- gen_qrcode event!
				SELECT pg_notify('User.gen_qrcode',
					json_build_object('params',
						json_build_object('keys', json_build_object('user_id', NEW.user_id))
					)::text);
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'') THEN
			NEW.name_first = trim(NEW.name_first);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_second,'') <> coalesce(NEW.name_second,'') THEN
			NEW.name_second = trim(NEW.name_second);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'') THEN
			NEW.name_middle = trim(NEW.name_middle);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 24/10/2022 07:58:45 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				--set parent!
				(SELECT coalesce(cl.parent_id, cl.id) FROM clients AS cl WHERE cl.id = NEW.company_id)
				)
				RETURNING id INTO NEW.user_id;
				
				-- gen_qrcode event!
				SELECT pg_notify('User.gen_qrcode',
					json_build_object('params',
						json_build_object('keys', json_build_object('user_id', NEW.user_id))
					)::text);
			END IF;
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'') THEN
			NEW.name_first = trim(NEW.name_first);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_second,'') <> coalesce(NEW.name_second,'') THEN
			NEW.name_second = trim(NEW.name_second);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'') THEN
			NEW.name_middle = trim(NEW.name_middle);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 24/10/2022 07:58:49 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		IF NEW.qr_code IS NOT NULL AND (TG_OP='INSERT' OR OLD.qr_code IS NULL)  THEN
			--mail QR url
			INSERT INTO mail_messages
				(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
				body, sender_addr, subject, mail_type)
				WITH srv_mail AS (
					SELECT
						srv.val->>'user' AS from_addr,
						srv.val->>'name' AS from_name,
						coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
						coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
						srv.val->>'user' AS sender_addr
					FROM const_mail_server AS srv
					LIMIT 1
				)
				SELECT	
					(SELECT from_addr FROM srv_mail),
					(SELECT from_name FROM srv_mail),
					act.to_addr,
					act.to_name,
					(SELECT reply_addr FROM srv_mail),
					(SELECT reply_name FROM srv_mail),
					act.body,
					(SELECT sender_addr FROM srv_mail),
					act.subject,
					act.mail_type
				FROM mail_person_url(NEW.id) AS act
			;
			NEW.qr_code_sent_date = now();
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_user_activation(NEW.id) AS act
				;
			END IF;
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 24/10/2022 08:15:52 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_user_activation(NEW.id) AS act
				;
			END IF;
			
			IF NEW.qr_code IS NOT NULL AND coalesce(NEW.name,'')<>'' AND OLD.qr_code IS NULL  THEN
				--mail QR url
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_person_url(NEW.id) AS act
				;
			END IF;
			
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 24/10/2022 08:17:34 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		IF TG_OP='UPDATE' AND NEW.qr_code IS NOT NULL AND coalesce(NEW.name,'')<>'' AND OLD.qr_code IS NULL  THEN
			NEW.qr_code_sent_date = now();
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_user_activation(NEW.id) AS act
				;
			END IF;
			
			IF NEW.qr_code IS NOT NULL AND coalesce(NEW.name,'')<>'' AND OLD.qr_code IS NULL  THEN
				--mail QR url
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_person_url(NEW.id) AS act
				;
			END IF;
			
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 24/10/2022 08:18:40 ******************
-- Function: users_process()

-- DROP FUNCTION users_process();

CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' THEN
		IF NEW.role_id ='person' AND coalesce(NEW.person_url,'') =''
		AND (TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')) THEN		
			NEW.person_url = users_gen_url(NEW.snils);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'') THEN
			NEW.name = trim(NEW.name);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'') THEN
			NEW.name_full = trim(NEW.name_full);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
			NEW.snils = trim(NEW.snils);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.post,'') <> coalesce(NEW.post,'') THEN
			NEW.post = trim(NEW.post);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name,'') <> coalesce(NEW.name,'')
		OR coalesce(OLD.name_full,'') <> coalesce(NEW.name_full,'')
		OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'') THEN
		
			NEW.descr = coalesce(NEW.name_full,'')||
				coalesce( CASE WHEN coalesce(NEW.name_full,'')<>'' THEN ', ' ELSE '' END ||NEW.name,'')||
				coalesce(' '||NEW.snils, '');
		END IF;
		
		IF TG_OP='UPDATE' AND NEW.qr_code IS NOT NULL AND coalesce(NEW.name,'')<>'' AND OLD.qr_code IS NULL  THEN
			NEW.qr_code_sent_date = now();
		END IF;
		
		RETURN NEW;
		
	ELSE	
		--AFTER
		
		IF TG_OP = 'UPDATE' THEN

			IF coalesce(OLD.banned, FALSE) = FALSE AND coalesce(NEW.banned, FALSE) = TRUE THEN
				--user ban
				UPDATE logins
				SET date_time_out = now()
				WHERE id = 
					(SELECT id
					FROM logins
					WHERE user_id = NEW.id
					AND date_time_out IS NULL
					ORDER BY date_time_in DESC
					LIMIT 1);
					
			ELSIF coalesce(OLD.banned, FALSE) = TRUE AND coalesce(NEW.banned, FALSE) = FALSE THEN
				--activaion
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_user_activation(NEW.id) AS act
				;
			END IF;
			
			IF NEW.qr_code IS NOT NULL AND coalesce(NEW.name,'')<>'' AND OLD.qr_code IS NULL  THEN
				--mail QR url
				INSERT INTO mail_messages
					(from_addr, from_name, to_addr, to_name, reply_addr, reply_name,
					body, sender_addr, subject, mail_type)
					WITH srv_mail AS (
						SELECT
							srv.val->>'user' AS from_addr,
							srv.val->>'name' AS from_name,
							coalesce(srv.val->>'reply_mail', srv.val->>'user') AS reply_addr,
							coalesce(srv.val->>'reply_name', srv.val->>'name') AS reply_name,
							srv.val->>'user' AS sender_addr
						FROM const_mail_server AS srv
						LIMIT 1
					)
					SELECT	
						(SELECT from_addr FROM srv_mail),
						(SELECT from_name FROM srv_mail),
						act.to_addr,
						act.to_name,
						(SELECT reply_addr FROM srv_mail),
						(SELECT reply_name FROM srv_mail),
						act.body,
						(SELECT sender_addr FROM srv_mail),
						act.subject,
						act.mail_type
					FROM mail_person_url(NEW.id) AS act
				;
			END IF;
			
			
			RETURN NEW;
			
		ELSIF TG_OP = 'DELETE' THEN
			--user ban
			UPDATE logins
			SET date_time_out = now()
			WHERE id = 
				(SELECT
					id
				FROM logins
				WHERE user_id = OLD.id
				AND date_time_out IS NULL
				ORDER BY date_time_in DESC
				LIMIT 1);
			RETURN OLD;
		END IF;
	END IF;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO dpassport;



-- ******************* update 24/10/2022 08:18:55 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				--set parent!
				(SELECT coalesce(cl.parent_id, cl.id) FROM clients AS cl WHERE cl.id = NEW.company_id)
				)
				RETURNING id INTO NEW.user_id;
				
			END IF;
			
			-- gen_qrcode event!
			SELECT pg_notify('User.gen_qrcode',
				json_build_object('params',
					json_build_object('keys', json_build_object('user_id', NEW.user_id))
				)::text);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'') THEN
			NEW.name_first = trim(NEW.name_first);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_second,'') <> coalesce(NEW.name_second,'') THEN
			NEW.name_second = trim(NEW.name_second);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'') THEN
			NEW.name_middle = trim(NEW.name_middle);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 24/10/2022 08:21:31 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				--set parent!
				(SELECT coalesce(cl.parent_id, cl.id) FROM clients AS cl WHERE cl.id = NEW.company_id)
				)
				RETURNING id INTO NEW.user_id;
				
			END IF;
			
			-- gen_qrcode event!
			PERFORM pg_notify('User.gen_qrcode',
				json_build_object('params',
					json_build_object('keys', json_build_object('user_id', NEW.user_id))
				)::text);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'') THEN
			NEW.name_first = trim(NEW.name_first);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_second,'') <> coalesce(NEW.name_second,'') THEN
			NEW.name_second = trim(NEW.name_second);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'') THEN
			NEW.name_middle = trim(NEW.name_middle);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 24/10/2022 08:36:53 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				--set parent!
				(SELECT coalesce(cl.parent_id, cl.id) FROM clients AS cl WHERE cl.id = NEW.company_id)
				)
				RETURNING id INTO NEW.user_id;
				
			END IF;
			
			-- gen_qrcode event!
			PERFORM pg_notify('User.gen_qrcode',
				json_build_object('params',
					json_build_object('user_id', NEW.user_id)
				)::text);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'') THEN
			NEW.name_first = trim(NEW.name_first);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_second,'') <> coalesce(NEW.name_second,'') THEN
			NEW.name_second = trim(NEW.name_second);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'') THEN
			NEW.name_middle = trim(NEW.name_middle);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 24/10/2022 09:06:30 ******************
-- Function: study_documents_process()

-- DROP FUNCTION study_documents_process();

CREATE OR REPLACE FUNCTION study_documents_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND (TG_OP='INSERT' OR TG_OP='UPDATE') THEN
--RAISE EXCEPTION 'STOP NEW.user_id=%', NEW.user_id;	
		IF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') = '' THEN
			RAISE EXCEPTION 'Не задан ни пользователь ни СНИСЛ';
			
		ELSIF coalesce(NEW.user_id, 0) = 0 AND coalesce(NEW.snils,'') <>'' THEN
			--Есть СНИСЛ, нет юзера
			SELECT
				u.id
			INTO
				NEW.user_id
			FROM users AS u
			WHERE u.snils = NEW.snils;
			
			IF coalesce(NEW.user_id, 0) = 0 THEN
				--создание юзера по СНИЛС
				INSERT INTO users
				(name_full, post, snils,
				role_id, locale_id,
				company_id)
				VALUES
				(name_full(NEW.name_first, NEW.name_second, NEW.name_middle),
				NEW.post,
				NEW.snils,
				'person', 'ru',
				--set parent!
				(SELECT coalesce(cl.parent_id, cl.id) FROM clients AS cl WHERE cl.id = NEW.company_id)
				)
				RETURNING id INTO NEW.user_id;
				
			END IF;
			
			-- gen_qrcode event!
			PERFORM pg_notify('User.gen_qrcode', json_build_object('user_id', NEW.user_id)::text);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'') THEN
			NEW.name_first = trim(NEW.name_first);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_second,'') <> coalesce(NEW.name_second,'') THEN
			NEW.name_second = trim(NEW.name_second);
		END IF;
		IF TG_OP='INSERT' OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'') THEN
			NEW.name_middle = trim(NEW.name_middle);
		END IF;
		
		IF TG_OP='INSERT' OR coalesce(NEW.name_first,'') <> coalesce(OLD.name_first,'')
		OR coalesce(NEW.name_second,'') <> coalesce(OLD.name_second,'')
		OR coalesce(NEW.name_middle,'') <> coalesce(OLD.name_middle,'') THEN
			NEW.name_full = name_full(NEW.name_first, NEW.name_second, NEW.name_middle);
		END IF;
		
		RETURN NEW;		
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_documents'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;				
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_documents_process() OWNER TO dpassport;



-- ******************* update 28/11/2022 17:56:22 ******************
-- Function: const_server_1c_process()

-- DROP FUNCTION const_server_1c_process();

CREATE OR REPLACE FUNCTION const_server_1c_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF text_to_int_safe_cast(OLD.val->>'pay_check_interval') <> text_to_int_safe_cast(NEW.val->>'pay_check_interval') THEN
			--event
			PERFORM pg_notify('Server1С.change_pay_check_interval', null);			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_server_1c_process()
  OWNER TO dpassport;



-- ******************* update 28/11/2022 17:56:28 ******************
-- Trigger: const_server_1c_trigger_after on public.const_server_1c

-- DROP TRIGGER const_server_1c_trigger_after ON public.const_server_1c;


CREATE TRIGGER const_server_1c_trigger_after
  AFTER UPDATE
  ON public.const_server_1c
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_server_1c_process();



-- ******************* update 29/11/2022 13:03:27 ******************

					ALTER TYPE mail_types ADD VALUE 'client_order';
					
	/* type get function */
	CREATE OR REPLACE FUNCTION enum_mail_types_val(mail_types,locales)
	RETURNS text AS $$
		SELECT
		CASE
		WHEN $1='person_register'::mail_types AND $2='ru'::locales THEN 'Регистрация физического лица'
		WHEN $1='password_recover'::mail_types AND $2='ru'::locales THEN 'Восстановление пароля'
		WHEN $1='admin_1_register'::mail_types AND $2='ru'::locales THEN 'Регистрация администратора тип 1'
		WHEN $1='client_activation'::mail_types AND $2='ru'::locales THEN 'Активация площадки'
		WHEN $1='client_registration'::mail_types AND $2='ru'::locales THEN 'Регистрация новой площадки'
		WHEN $1='client_expiration'::mail_types AND $2='ru'::locales THEN 'Предупреждение об окончании срока оплаты площадки'
		WHEN $1='person_url'::mail_types AND $2='ru'::locales THEN 'Персональная ссылка для входа в личный кабинет'
		WHEN $1='user_activation'::mail_types AND $2='ru'::locales THEN 'Активация пользователя'
		WHEN $1='client_order'::mail_types AND $2='ru'::locales THEN 'Счет на оплату клиенту'
		ELSE ''
		END;		
	$$ LANGUAGE sql;	
	ALTER FUNCTION enum_mail_types_val(mail_types,locales) OWNER TO dpassport;		
	
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
			
			
			
			
		
			
				
			
		
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
			
		
			
				
			
			
			
			
			
			
			
			
			
			
		
			
				
			
			
			
			
									
			
			
									
		
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
			
		
			
			
			
			
			
		
			
			
			
			
			
			
		
			
				
				
								
			
						
			
			
			
			
			
			
						
			
						
			
			
			
		
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
			
				
					
						
			
			
			
			
			
		
			
				
								
						
			
			
			
			
			
			
			
			
			
			
						
			
			
			
			
		
									
			
			
			
			
			
			
			
			
			
		
			
				
				
			
			
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
						
									
			
								
			
			
			
			
			
			
			
		
			
				
				
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
									
								
			
			
			
			
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
						
									
			
			
			
			
		
			
				
							
						
						
						
			
			
		
			
			
			
			
			
		
			
			
			
			
			
		
			
									
			
			
															
			
			
			
			
		
			
			
			
		
			
			
		
			
				
					
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
						
		
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
									
			
		
			
				
					
			
			
			
			
			
			
		
			
				
					
			
			
			
			
			
			
		

-- ******************* update 29/11/2022 13:55:23 ******************
-- Function: mail_client_activation(in_client_id int)

-- DROP FUNCTION mail_client_activation(in_client_id int);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиента


CREATE OR REPLACE FUNCTION mail_client_activation(in_client_id int)
  RETURNS TABLE(
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
  )  AS
$BODY$
	WITH 
		templ AS (
			SELECT
				t.template AS v,
				t.mes_subject AS s
			FROM mail_templates t
			WHERE t.mail_type = 'client_activation'::mail_types
		),
		last_payment AS (
			SELECT
				t.date_from,
				t.date_to
			FROM client_accesses AS t
			WHERE t.client_id = in_client_id
			ORDER BY t.date_to DESC
			LIMIT 1		
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value,
				ROW('date_from', (SELECT date_from FROM last_payment))::template_value,
				ROW('date_to', (SELECT date_to FROM last_payment))::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_activation'::mail_types
		
	FROM users AS u	
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.company_id = in_client_id AND u.role_id = 'client_admin1'
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_activation(in_client_id int) OWNER TO dpassport;


-- ******************* update 29/11/2022 14:42:15 ******************
-- Function: mail_client_order(in_client_id int)

-- DROP FUNCTION mail_client_order(in_client_id int);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиента


CREATE OR REPLACE FUNCTION mail_client_order(in_client_id int)
  RETURNS TABLE(
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
  )  AS
$BODY$
	WITH 
		templ AS (
			SELECT
				t.template AS v,
				t.mes_subject AS s
			FROM mail_templates t
			WHERE t.mail_type = 'client_activation'::mail_types
		),
		last_payment AS (
			SELECT
				t.date_from,
				t.date_to
			FROM client_accesses AS t
			WHERE t.client_id = in_client_id
			ORDER BY t.date_to DESC
			LIMIT 1		
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_order'::mail_types
		
	FROM users AS u
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.client_id = in_client_id AND u.role_id = 'client_admin1'
	LIMIT 1;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_order(in_client_id int) OWNER TO dpassport;


-- ******************* update 29/11/2022 14:59:55 ******************
-- Function: mail_client_order(in_client_id int)

-- DROP FUNCTION mail_client_order(in_client_id int);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиента


CREATE OR REPLACE FUNCTION mail_client_order(in_client_id int)
  RETURNS TABLE(
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
  )  AS
$BODY$
	WITH 
		templ AS (
			SELECT
				t.template AS v,
				t.mes_subject AS s
			FROM mail_templates t
			WHERE t.mail_type = 'client_activation'::mail_types
		),
		last_payment AS (
			SELECT
				t.date_from,
				t.date_to
			FROM client_accesses AS t
			WHERE t.client_id = in_client_id
			ORDER BY t.date_to DESC
			LIMIT 1		
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_order'::mail_types
		
	FROM users AS u
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.company_id = in_client_id AND u.role_id = 'client_admin1'
	LIMIT 1;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_order(in_client_id int) OWNER TO dpassport;


-- ******************* update 29/11/2022 15:00:29 ******************
-- Function: mail_client_order(in_client_id int)

-- DROP FUNCTION mail_client_order(in_client_id int);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиента


CREATE OR REPLACE FUNCTION mail_client_order(in_client_id int)
  RETURNS TABLE(
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
  )  AS
$BODY$
	WITH 
		templ AS (
			SELECT
				t.template AS v,
				t.mes_subject AS s
			FROM mail_templates t
			WHERE t.mail_type = 'client_order'::mail_types
		),
		last_payment AS (
			SELECT
				t.date_from,
				t.date_to
			FROM client_accesses AS t
			WHERE t.client_id = in_client_id
			ORDER BY t.date_to DESC
			LIMIT 1		
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', u.name_full::text)::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_order'::mail_types
		
	FROM users AS u
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.company_id = in_client_id AND u.role_id = 'client_admin1'
	LIMIT 1;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_order(in_client_id int) OWNER TO dpassport;


-- ******************* update 30/11/2022 13:07:42 ******************
	CREATE INDEX client_accesses_doc_1c_ref_idx
	ON client_accesses((doc_1c_ref->>'ref'),(doc_1c_ref->>'payed'));



-- ******************* update 30/11/2022 14:54:56 ******************
-- Function: client_accesses_process()

-- DROP FUNCTION client_accesses_process();

CREATE OR REPLACE FUNCTION client_accesses_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_OP='INSERT' OR TG_OP='UPDATE' AND 
	(NEW.date_to <> OLD.date_to
	OR NEW.client_id <> OLD.client_id
	)
	THEN
		PERFORM mail_client_activation(NEW.client_id);
				
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION client_accesses_process()
  OWNER TO dpassport;



-- ******************* update 30/11/2022 16:39:30 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"make_order":true
			,"get_order_print":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"update":true
			,"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 30/11/2022 16:41:19 ******************
/**
 * Andrey Mikhalevich 15/12/21
 * This file is part of the OSBE framework
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/permissions/permissions.sql.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

/*
-- If this is the first time you execute the script, uncomment these lines
-- to create table and insert row
CREATE TABLE IF NOT EXISTS permissions (
    rules json NOT NULL
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.permissions OWNER to ;

INSERT INTO permissions VALUES ('{"admin":{}}');
*/

UPDATE permissions SET rules = '{
	"admin":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"set_value":true
			,"get_list":true
			,"get_object":true
			,"get_values":true
		}
		,"Enum":{
			"get_enum_list":true
		}
		,"MainMenuConstructor":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MainMenuContent":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"View":{
			"get_list":true
			,"complete":true
			,"get_section_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"password_recover":true
			,"register":true
			,"set_viewed":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
			,"get_object":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserMacAddress":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"check_for_register":true
			,"update_attrs":true
			,"select_company":true
			,"set_viewed":true
		}
		,"ClientAccess":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"make_order":true
			,"get_order_print":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"Constant_study_document_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Constant_study_document_register_fields":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"PersonData":{
			"login":true
		}
		,"MailMessage":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailMessageAttachment":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"MailTemplate":{
			"insert":true
			,"update":true
			,"get_list":true
			,"get_object":true
		}
		,"ReportTemplateField":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Captcha":{
			"get":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"guest":{
		"User":{
			"login":true
			,"register":true
			,"password_recover":true
		}
		,"Captcha":{
			"get":true
		}
		,"Client":{
			"check_for_register":true
		}
		,"PersonData":{
			"login":true
		}
	}
	,"client_admin1":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"login":true
			,"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"Login":{
			"get_list":true
		}
		,"LoginDevice":{
			"get_list":true
			,"switch_banned":true
		}
		,"LoginDeviceBan":{
			"insert":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
			,"get_order_print":true
			,"make_order":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"client_admin2":{
		"Event":{
			"subscribe":true
			,"unsubscribe":true
			,"publish":true
		}
		,"Constant":{
			"get_values":true
		}
		,"Enum":{
			"get_list":true
		}
		,"VariantStorage":{
			"insert":true
			,"upsert_filter_data":true
			,"upsert_col_visib_data":true
			,"upsert_col_order_data":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"get_filter_data":true
			,"get_col_visib_data":true
			,"get_col_order_data":true
		}
		,"About":{
			"get_object":true
		}
		,"User":{
			"update":true
			,"login":true
			,"get_list":true
			,"get_object":true
			,"get_profile":true
			,"reset_pwd":true
			,"login_refresh":true
			,"logout":true
			,"logout_html":true
			,"download_photo":true
			,"delete_photo":true
			,"gen_qrcode":true
			,"send_qrcode_email":true
		}
		,"TimeZoneLocale":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
		}
		,"Client":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"set_viewed":true
		}
		,"ClientSearch":{
			"search":true
		}
		,"UserOperation":{
			"get_object":true
			,"delete":true
		}
		,"ClientAccess":{
			"get_list":true
		}
		,"ObjectModLog":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentRegister":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"batch_update":true
			,"batch_delete":true
			,"complete":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocument":{
			"insert":true
			,"update":true
			,"batch_update":true
			,"batch_delete":true
			,"delete":true
			,"get_list":true
			,"get_with_pict_list":true
			,"get_object":true
			,"complete":true
			,"get_preview":true
			,"analyze_excel":true
			,"get_analyze_count":true
			,"upload_excel":true
			,"get_excel_template":true
			,"save_field_order":true
			,"get_excel_error":true
		}
		,"StudyDocumentAttachment":{
			"get_list":true
			,"get_object":true
			,"delete_file":true
			,"get_file":true
			,"add_file":true
		}
		,"StudyDocumentInsertHead":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_object":true
			,"get_list":true
			,"close":true
		}
		,"StudyDocumentInsert":{
			"insert":true
			,"update":true
			,"delete":true
			,"get_list":true
			,"get_object":true
			,"complete":true
			,"batch_update":true
			,"batch_delete":true
			,"add_files":true
		}
		,"StudyDocumentInsertAttachment":{
			"get_list":true
			,"add_files":true
		}
		,"StudyType":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Profession":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"Qualification":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
		,"StudyForm":{
			"get_list":true
			,"get_object":true
			,"complete":true
		}
	}
	,"person":{
		"PersonData":{
			"login":true
		}
		,"User":{
			"get_profile":true
			,"update":true
		}
		,"StudyDocument":{
			"get_list":true
			,"get_object":true
		}
		,"StudyDocumentAttachment":{
			"get_file":true
		}
		,"TimeZoneLocale":{
			"get_list":true
		}
	}
}';


-- ******************* update 06/12/2022 16:45:08 ******************
﻿-- Function: text_to_float_safe_cast(in_text text)

-- DROP FUNCTION text_to_float_safe_cast(in_text text);

CREATE OR REPLACE FUNCTION text_to_float_safe_cast(in_text text)
  RETURNS numeric AS
$$
	SELECT CASE WHEN coalesce(in_text,'') = '' THEN NULL ELSE in_text::numeric END;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION text_to_float_safe_cast(in_text text) OWNER TO dpassport;


-- ******************* update 09/12/2022 09:06:28 ******************
-- Function: const_server_1c_process()

-- DROP FUNCTION const_server_1c_process();

CREATE OR REPLACE FUNCTION const_server_1c_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF text_to_int_safe_cast(OLD.val->>'pay_check_interval') <> text_to_int_safe_cast(NEW.val->>'pay_check_interval') THEN
			--event
			PERFORM pg_notify('Server1C.change_pay_check_interval', null);			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_server_1c_process()
  OWNER TO dpassport;



-- ******************* update 09/12/2022 09:10:19 ******************
-- Function: const_server_1c_process()

-- DROP FUNCTION const_server_1c_process();

CREATE OR REPLACE FUNCTION const_server_1c_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF text_to_int_safe_cast(OLD.val->>'pay_check_interval') <> text_to_int_safe_cast(NEW.val->>'pay_check_interval') THEN
			--event
			PERFORM pg_notify('Server1C.change_pay_check_interval', null);			
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF coalesce(OLD.val->>'firm_inn','') <> coalesce(NEW.val->>'firm_inn','') THEN
			NEW.val = NEW.val || '{"firm_ref": null}'::jsonb;
		END IF;
		IF coalesce(OLD.val->>'sklad_name','') <> coalesce(NEW.val->>'sklad_name','') THEN
			NEW.val = NEW.val || '{"sklad_ref": null}'::jsonb;
		END IF;
		IF coalesce(OLD.val->>'item_name','') <> coalesce(NEW.val->>'item_name','') THEN
			NEW.val = NEW.val || '{"item_ref": null}'::jsonb;
		END IF;
		IF coalesce(OLD.val->>'bank_account','') <> coalesce(NEW.val->>'bank_account','') THEN
			NEW.val = NEW.val || '{"bank_account_ref": null}'::jsonb;
		END IF;
	
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_server_1c_process()
  OWNER TO dpassport;



-- ******************* update 09/12/2022 09:10:58 ******************
-- Trigger: const_server_1c_trigger_after on public.const_server_1c

-- DROP TRIGGER const_server_1c_trigger_after ON public.const_server_1c;

/*
CREATE TRIGGER const_server_1c_trigger_after
  AFTER UPDATE
  ON public.const_server_1c
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_server_1c_process();
*/

-- Trigger: const_server_1c_trigger_before on public.const_server_1c

-- DROP TRIGGER const_server_1c_trigger_before ON public.const_server_1c;

CREATE TRIGGER const_server_1c_trigger_before
  BEFORE UPDATE
  ON public.const_server_1c
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_server_1c_process();



-- ******************* update 09/12/2022 09:12:35 ******************
-- Function: const_server_1c_process()

-- DROP FUNCTION const_server_1c_process();

CREATE OR REPLACE FUNCTION const_server_1c_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF text_to_int_safe_cast(OLD.val->>'pay_check_interval') <> text_to_int_safe_cast(NEW.val->>'pay_check_interval') THEN
			--event
			PERFORM pg_notify('Server1C.change_pay_check_interval', null);			
		END IF;
		
		RETURN NEW;
		
	ELSIF (TG_WHEN='BEFORE' AND TG_OP='UPDATE') THEN
		IF coalesce(OLD.val->>'firm_inn','') <> coalesce(NEW.val->>'firm_inn','') THEN
			NEW.val = NEW.val::jsonb || '{"firm_ref": null}'::jsonb;
		END IF;
		IF coalesce(OLD.val->>'sklad_name','') <> coalesce(NEW.val->>'sklad_name','') THEN
			NEW.val = NEW.val::jsonb || '{"sklad_ref": null}'::jsonb;
		END IF;
		IF coalesce(OLD.val->>'item_name','') <> coalesce(NEW.val->>'item_name','') THEN
			NEW.val = NEW.val::jsonb || '{"item_ref": null}'::jsonb;
		END IF;
		IF coalesce(OLD.val->>'bank_account','') <> coalesce(NEW.val->>'bank_account','') THEN
			NEW.val = NEW.val::jsonb || '{"bank_account_ref": null}'::jsonb;
		END IF;
	
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_server_1c_process()
  OWNER TO dpassport;



-- ******************* update 09/12/2022 13:40:29 ******************
﻿-- Function: client_accesses_allowed(in_company_id int)

-- DROP FUNCTION client_accesses_allowed(in_company_id int);

CREATE OR REPLACE FUNCTION client_accesses_allowed(in_company_id int)
  RETURNS bool AS
$$
	SELECT coalesce(
		(SELECT
			(acc.date_to >= now()::date)
			AND (
				acc.doc_1c_ref IS NOT NULL
				AND coalesce(acc.doc_1c_ref->>'ref','') <>''
				AND coalesce(acc.doc_1c_ref->>'payed','') = 'true'
			) AS access_payed
		FROM client_accesses AS acc
		WHERE acc.client_id = in_company_id
		ORDER BY acc.date_to DESC
		LIMIT 1),
		FALSE
	);
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION client_accesses_allowed(in_company_id int) OWNER TO dpassport;


-- ******************* update 09/12/2022 13:41:33 ******************
-- View: public.users_login

-- DROP VIEW public.users_login;

CREATE OR REPLACE VIEW public.users_login AS 
	SELECT
		ud.*,
		u.pwd,
		u.person_url,
		u.client_id,
		(SELECT string_agg(bn.hash,',') FROM login_device_bans bn WHERE bn.user_id=u.id) AS ban_hash,
		
		--Доступ для площадки по оплате
		(client_accesses_allowed(u.company_id)=FALSE) AS client_banned
		/* coalesce(
			(SELECT acc.date_to < now()::date
			FROM client_accesses AS acc
			WHERE acc.client_id = u.company_id
			ORDER BY acc.date_to DESC
			LIMIT 1),
			TRUE
		)*/
		
		,u.descr
		,clients_ref(cl)->>'descr' AS company_descr
		
	FROM users AS u
	LEFT JOIN users_dialog AS ud ON ud.id=u.id
	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;

ALTER TABLE public.users_login
  OWNER TO dpassport;



-- ******************* update 09/12/2022 15:54:40 ******************
-- Function: mail_client_order(in_client_id int)

-- DROP FUNCTION mail_client_order(in_client_id int);

-- Все функции по одному шаблону: возвращают структуру
-- Отправляем всем админам типа 1 при активации клиента


CREATE OR REPLACE FUNCTION mail_client_order(in_client_id int)
  RETURNS TABLE(
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
  )  AS
$BODY$
	WITH 
		templ AS (
			SELECT
				t.template AS v,
				t.mes_subject AS s
			FROM mail_templates t
			WHERE t.mail_type = 'client_order'::mail_types
		),
		last_payment AS (
			SELECT
				t.date_from,
				t.date_to
			FROM client_accesses AS t
			WHERE t.client_id = in_client_id
			ORDER BY t.date_to DESC
			LIMIT 1		
		)
	SELECT
		coalesce(u.name::text,'') AS to_addr,
		coalesce(u.name_full::text, '') AS to_name,
		coalesce(templates_text(
			ARRAY[
				ROW('name_full', coalesce(u.name_full::text, cl.name::text))::template_value,
				ROW('client_name', cl.name::text)::template_value,
				ROW('client_name_full', cl.name_full::text)::template_value,
				ROW('client_inn', cl.inn::text)::template_value,
				ROW('client_orgn', cl.ogrn::text)::template_value
			],
			(SELECT v FROM templ)
		), '') AS mes_body,		
		coalesce((SELECT s FROM templ), '') AS subject,
		'client_order'::mail_types
		
	FROM users AS u
	LEFT JOIN clients AS cl ON cl.id = u.client_id
	WHERE u.company_id = in_client_id AND u.role_id = 'client_admin1'
	LIMIT 1;
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION mail_client_order(in_client_id int) OWNER TO dpassport;


-- ******************* update 09/12/2022 16:40:34 ******************
-- VIEW: mail_messages_list

--DROP VIEW mail_messages_list;

CREATE OR REPLACE VIEW mail_messages_list AS
	SELECT
		id,
		date_time,
		from_name,
		to_addr,
		to_name,
		reply_addr,
		reply_name,
		SUBSTRING(body, 1, 100) AS body_begin,
		sender_addr,
		subject,
		sent
		sent_date_time,
		mail_type,
		error_str,
		(SELECT count(*) FROM mail_message_attachments AS att WHERE att.mail_message_id = m.id) AS attachment_count
		
	FROM mail_messages AS m
	
	;
	
ALTER VIEW mail_messages_list OWNER TO dpassport;


-- ******************* update 09/12/2022 16:40:43 ******************
-- VIEW: mail_messages_list

--DROP VIEW mail_messages_list;

CREATE OR REPLACE VIEW mail_messages_list AS
	SELECT
		id,
		date_time,
		from_name,
		to_addr,
		to_name,
		reply_addr,
		reply_name,
		SUBSTRING(body, 1, 100) AS body_begin,
		sender_addr,
		subject,
		sent
		sent_date_time,
		mail_type,
		error_str,
		(SELECT count(*) FROM mail_message_attachments AS att WHERE att.mail_message_id = m.id) AS attachment_count
		
	FROM mail_messages AS m
	
	;
	
ALTER VIEW mail_messages_list OWNER TO dpassport;


-- ******************* update 09/12/2022 17:22:49 ******************
-- VIEW: mail_messages_list

DROP VIEW mail_messages_list;

CREATE OR REPLACE VIEW mail_messages_list AS
	SELECT
		id,
		date_time,
		from_addr,
		from_name,
		to_addr,
		to_name,
		reply_addr,
		reply_name,
		SUBSTRING(body, 1, 100) AS body_begin,
		sender_addr,
		subject,
		sent
		sent_date_time,
		mail_type,
		error_str,
		(SELECT count(*) FROM mail_message_attachments AS att WHERE att.mail_message_id = m.id) AS attachment_count
		
	FROM mail_messages AS m
	ORDER BY date_time desc
	;
	
ALTER VIEW mail_messages_list OWNER TO dpassport;


-- ******************* update 09/12/2022 17:23:13 ******************
-- VIEW: mail_messages_list

DROP VIEW mail_messages_list;

CREATE OR REPLACE VIEW mail_messages_list AS
	SELECT
		id,
		date_time,
		from_addr,
		from_name,
		to_addr,
		to_name,
		reply_addr,
		reply_name,
		SUBSTRING(body, 1, 100) AS body_begin,
		sender_addr,
		subject,
		sent,
		sent_date_time,
		mail_type,
		error_str,
		(SELECT count(*) FROM mail_message_attachments AS att WHERE att.mail_message_id = m.id) AS attachment_count
		
	FROM mail_messages AS m
	ORDER BY date_time desc
	;
	
ALTER VIEW mail_messages_list OWNER TO dpassport;


-- ******************* update 09/12/2022 17:28:46 ******************
-- VIEW: mail_messages_list

--DROP VIEW mail_messages_list;

CREATE OR REPLACE VIEW mail_messages_list AS
	SELECT
		id,
		date_time,
		from_addr,
		from_name,
		to_addr,
		to_name,
		reply_addr,
		reply_name,
		body AS body_begin,
		--SUBSTRING(body, 1, 100) AS body_begin,
		sender_addr,
		subject,
		sent,
		sent_date_time,
		mail_type,
		error_str,
		(SELECT count(*) FROM mail_message_attachments AS att WHERE att.mail_message_id = m.id) AS attachment_count
		
	FROM mail_messages AS m
	ORDER BY date_time desc
	;
	
ALTER VIEW mail_messages_list OWNER TO dpassport;


-- ******************* update 12/12/2022 10:19:08 ******************
-- Function: public.users_ref(users)

-- DROP FUNCTION public.users_ref(users);

CREATE OR REPLACE FUNCTION public.users_ref(users)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', coalesce($1.descr, $1.name),
		'dataType','users'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.users_ref(users) OWNER TO dpassport;



-- ******************* update 12/12/2022 10:22:50 ******************
-- Function: public.users_ref(users)

-- DROP FUNCTION public.users_ref(users);

CREATE OR REPLACE FUNCTION public.users_ref(users)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', $1.descr,
		'dataType','users'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.users_ref(users) OWNER TO dpassport;



-- ******************* update 12/12/2022 10:23:33 ******************
-- VIEW: public.users_list

DROP VIEW public.users_list;

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
	
ALTER VIEW public.users_list OWNER TO dpassport;