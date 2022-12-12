-- Function: const_mail_server_process()

-- DROP FUNCTION const_mail_server_process();

CREATE OR REPLACE FUNCTION const_mail_server_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF (TG_WHEN='AFTER' AND TG_OP='UPDATE') THEN
		IF text_to_int_safe_cast(OLD.val->>'check_interval_ms') <> text_to_int_safe_cast(NEW.val->>'check_interval_ms') THEN
			--event
			PERFORM pg_notify('MailServer.change_interval', null);			
		END IF;
		
		RETURN NEW;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION const_mail_server_process()
  OWNER TO ;

