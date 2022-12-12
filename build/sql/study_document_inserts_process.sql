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
ALTER FUNCTION study_document_inserts_process() OWNER TO ;
*/
