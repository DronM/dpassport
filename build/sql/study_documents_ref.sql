-- Function: public.study_documents_ref(study_documents)

-- DROP FUNCTION public.study_documents_ref(study_documents);

CREATE OR REPLACE FUNCTION public.study_documents_ref(study_documents)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', 'Документ '||$1.id,
		'dataType','study_documents'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.study_documents_ref(study_documents) OWNER TO ;

