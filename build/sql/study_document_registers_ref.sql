-- Function: public.study_document_registers_ref(study_document_registers)

-- DROP FUNCTION public.study_document_registers_ref(study_document_registers);

CREATE OR REPLACE FUNCTION public.study_document_registers_ref(study_document_registers)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		--'descr', 'Протокол '||$1.name||' от '||to_char($1.issue_date, 'dd/mm/YYYY'),
		'descr', coalesce($1.name, to_char($1.issue_date, 'dd/mm/YYYY')),
		'dataType','study_document_registers'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.study_document_registers_ref(study_document_registers) OWNER TO ;

