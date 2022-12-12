-- VIEW: public._list

--DROP VIEW public._list;

CREATE OR REPLACE VIEW public._list AS
	SELECT
		t.id
		,t.name
		,t.descr
		,t.val
		,t.val_type
		,t.ctrl_class
		,t.ctrl_options
		,t.view_class
		,t.view_options
	FROM public. AS t
	
	ORDER BY name ASC
	;
	
ALTER VIEW public._list OWNER TO ;
