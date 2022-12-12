-- Function: study_document_registers_process()

-- DROP FUNCTION study_document_registers_process();

CREATE OR REPLACE FUNCTION study_document_registers_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_attachments
		WHERE study_documents_ref->>'dataType' = 'study_document_registers'
			AND (study_documents_ref->'keys'->>'id')::int = OLD.id;
			
		RETURN OLD;
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_document_registers_process() OWNER TO ;

