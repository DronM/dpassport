-- Function: public.client_accesses_ref(client_accesses)

-- DROP FUNCTION public.client_accesses_ref(client_accesses);

CREATE OR REPLACE FUNCTION public.client_accesses_ref(client_accesses)
  RETURNS json AS
$BODY$
	SELECT json_build_object(
		'keys',json_build_object(
			'id',$1.id    
			),	
		'descr', (SELECT cl.name FROM clients AS cl WHERE cl.id = $1.client_id)||' '||
			to_char($1.date_from, 'dd/mm/YYYY HH24:MI:SS') ||' - '||
			to_char($1.date_to, 'dd/mm/YYYY HH24:MI:SS'),
		'dataType','client_accesses'
	);
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION public.client_accesses_ref(client_accesses) OWNER TO ;

