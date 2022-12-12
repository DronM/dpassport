-- View: public.study_document_insert_heads_list

-- DROP VIEW public.study_document_insert_heads_list;

CREATE OR REPLACE VIEW public.study_document_insert_heads_list
 AS
 SELECT t.id,
    t.register_name,
    t.register_date,
    clients_ref(companies_ref_t.*) AS companies_ref,
    t.company_id,
    t.user_id,
    ( SELECT jsonb_agg(att.content_info || jsonb_build_object('dataBase64', encode(att.content_preview, 'base64'::text))) AS jsonb_agg
           FROM study_document_attachments att
          WHERE (att.study_documents_ref ->> 'dataType'::text) = 'study_document_insert_heads'::text AND (((att.study_documents_ref -> 'keys'::text) ->> 'id'::text)::integer) = t.id) AS register_attachment,
    ( SELECT count(cert.*) AS count
           FROM study_document_inserts cert
          WHERE cert.study_document_insert_head_id = t.id) AS study_document_count,
    t.common_issue_date,
    t.common_end_date,
    t.common_post,
    t.common_work_place,
    t.common_organization,
    t.common_study_type,
    t.common_series,
    t.common_study_prog_name,
    t.common_profession,
    t.common_study_period,
    t.common_qualification_name,
    t.common_study_form
    
   FROM study_document_insert_heads t
     LEFT JOIN clients companies_ref_t ON companies_ref_t.id = t.company_id
  ORDER BY t.register_date DESC;

ALTER TABLE public.study_document_insert_heads_list
    OWNER TO dpassport;


