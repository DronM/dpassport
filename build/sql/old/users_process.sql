-- Function: users_process()

 DROP FUNCTION users_process();
/*
CREATE OR REPLACE FUNCTION users_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF 
		(TG_OP='UPDATE' AND
			(coalesce(OLD.name,'') <> coalesce(NEW.name,'')
			OR coalesce(OLD.name_first,'') <> coalesce(NEW.name_first,'')
			OR coalesce(OLD.name_middle,'') <> coalesce(NEW.name_middle,'')
			OR coalesce(OLD.snils,'') <> coalesce(NEW.snils,'')
			)
		)
		OR (TG_OP='INSERT')
	THEN
		NEW.search = lower(NEW.name)||
			coalesce(lower(NEW.name_first),'')||
			coalesce(lower(NEW.name_second),'')||
			coalesce(lower(NEW.name_middle),'')||
			coalesce(NEW.snils,'');				
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION users_process()
  OWNER TO ;
*/
