-- Trigger: const_study_document_fields_trigger_after on public.const_study_document_fields

 DROP TRIGGER const_study_document_fields_trigger_after ON public.const_study_document_fields;


CREATE TRIGGER const_study_document_fields_trigger_after
  AFTER UPDATE
  ON public.const_study_document_fields
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_study_document_fields_process();

