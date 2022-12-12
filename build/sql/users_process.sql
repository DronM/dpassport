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
  OWNER TO ;

