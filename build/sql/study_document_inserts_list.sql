-- VIEW: public.study_document_inserts_list

--DROP VIEW public.study_document_inserts_list;

CREATE OR REPLACE VIEW public.study_document_inserts_list AS
	SELECT
		t.id
		,t.study_document_insert_head_id
		,h.user_id
		,t.snils
		,t.issue_date
		,t.end_date
		,t.post
		,t.work_place
		,t.organization
		,t.study_type
		,t.series
		,t.number
		,t.study_prog_name
		,t.profession
		,t.reg_number
		,t.study_period
		,t.name_first
		,t.name_second
		,t.name_middle
		,t.qualification_name
		,name_full(t.name_first, t.name_second, t.name_middle) AS name_full
		,t.study_form
		
	FROM public.study_document_inserts AS t
	
	LEFT JOIN study_document_insert_heads AS h ON h.id = study_document_insert_head_id
	;
	
ALTER VIEW public.study_document_inserts_list OWNER TO ;
