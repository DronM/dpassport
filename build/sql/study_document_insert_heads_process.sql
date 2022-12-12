-- Function: study_document_insert_heads_process()

-- DROP FUNCTION study_document_insert_heads_process();

CREATE OR REPLACE FUNCTION study_document_insert_heads_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_WHEN='BEFORE' AND TG_OP='DELETE' THEN
		DELETE FROM study_document_inserts
		WHERE
			study_document_insert_head_id = OLD.id;
		
		RETURN OLD;		
	END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION study_document_insert_heads_process() OWNER TO ;

