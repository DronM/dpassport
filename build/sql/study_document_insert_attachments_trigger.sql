
	-- DROP TRIGGER study_document_insert_attachments_trigger_before ON public.study_document_insert_attachments;
	
	CREATE TRIGGER study_document_insert_attachments_trigger_before
	BEFORE INSERT OR DELETE
	ON public.study_document_insert_attachments
	FOR EACH ROW
	EXECUTE PROCEDURE public.study_document_insert_attachments_process();

