-- Function: study_document_insert_attachments_process()

-- DROP FUNCTION study_document_insert_attachments_process();

CREATE OR REPLACE FUNCTION study_document_insert_attachments_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND TG_OP='INSERT' THEN
		SELECT
			name_full(l.name_first, l.name_second, l.name_middle)
		INTO
			NEW.name_full
		FROM study_document_inserts AS l
		WHERE l.id = NEW.study_document_insert_id
		;
		
		RETURN NEW;
		
	ELSIF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN		
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_document_insert_attachments'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
		
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_document_insert_attachments_process() OWNER TO ;

