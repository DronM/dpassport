-- Function: public.study_document_types_ref(study_document_types)

-- DROP FUNCTION public.study_document_types_ref(study_document_types);

CREATE OR REPLACE FUNCTION public.study_document_types_ref(study_document_types)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', $1.name,
		'dataType','study_document_types'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.study_document_types_ref(study_document_types) OWNER TO ;

