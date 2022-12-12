--Refrerece type
CREATE OR REPLACE FUNCTION study_document_inserts_ref(study_document_inserts)
  RETURNS json AS
$$
	SELECT json_build_object(
		'keys',json_build_object(
			'id', $1.id    
			),	
		'descr', name_full($1.name_first::text, $1.name_second::text, $1.name_middle::text),
		'dataType','study_document_inserts'
	);
$$
  LANGUAGE sql VOLATILE COST 100;
ALTER FUNCTION study_document_inserts_ref(study_document_inserts) OWNER TO dpassport;	
	

