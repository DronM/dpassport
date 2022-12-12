    CREATE TRIGGER study_document_insert_heads_trigger_before
    BEFORE DELETE
    ON public.study_document_insert_heads
    FOR EACH ROW
    EXECUTE PROCEDURE public.study_document_insert_heads_process();
