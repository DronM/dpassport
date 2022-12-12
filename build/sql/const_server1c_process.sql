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
  OWNER TO ;

