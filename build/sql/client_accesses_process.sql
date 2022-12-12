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
  OWNER TO ;

