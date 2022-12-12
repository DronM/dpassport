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
  OWNER TO ;

