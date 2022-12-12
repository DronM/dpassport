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
ALTER FUNCTION study_documents_process() OWNER TO ;

