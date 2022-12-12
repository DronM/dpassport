-- VIEW: public.user_operations_dialog

--DROP VIEW public.user_operations_dialog;

CREATE OR REPLACE VIEW public.user_operations_dialog AS
	SELECT
		t.user_id
		,t.operation_id
		,t.operation
		,t.status
		,t.date_time
		,t.error_text
		,t.comment_text
		,t.date_time_end
		,CASE WHEN t.file_content IS NULL THEN FALSE ELSE TRUE END AS file_content_exists
	FROM public.user_operations AS t
	
	
	;
	
ALTER VIEW public.user_operations_dialog OWNER TO ;
