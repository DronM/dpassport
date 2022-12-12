-- VIEW: public.mail_templates_list

--DROP VIEW public.mail_templates_list;

CREATE OR REPLACE VIEW public.mail_templates_list AS
	SELECT
		t.id
		,t.mail_type
		,t.template
	FROM public.mail_templates AS t
	
	
	;
	
ALTER VIEW public.mail_templates_list OWNER TO ;
