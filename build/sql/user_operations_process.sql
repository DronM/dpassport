-- Function: user_operations_process()

-- DROP FUNCTION user_operations_process();

CREATE OR REPLACE FUNCTION user_operations_process()
  RETURNS trigger AS
$BODY$
BEGIN
	IF TG_OP='UPDATE' AND (
		 (OLD.status<>'end' AND NEW.status='end')
		 OR NEW.status='progress'
	)
	THEN		
		PERFORM pg_notify(
			'UserOperation.'||md5(NEW.user_id::text||NEW.operation_id)
			,json_build_object(
				'params',json_build_object(
					'status', NEW.status,
					'operation_id', NEW.operation_id
				)
			)::text
		);
	END IF;
	
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION user_operations_process()
  OWNER TO ;

