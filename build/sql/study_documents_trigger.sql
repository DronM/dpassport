-- Trigger: study_documents_trigger_before on public.study_documents

 DROP TRIGGER study_documents_trigger_before ON public.study_documents;


CREATE TRIGGER study_documents_trigger_before
  BEFORE UPDATE OR INSERT OR DELETE
  ON public.study_documents
  FOR EACH ROW
  EXECUTE PROCEDURE public.study_documents_process();

