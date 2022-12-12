DROP TRIGGER study_document_inserts_trigger_before ON public.study_document_inserts;
/*
    CREATE TRIGGER study_document_inserts_trigger_before
    BEFORE DELETE
    ON public.study_document_inserts
    FOR EACH ROW
    EXECUTE PROCEDURE public.study_document_inserts_process();
*/  
DROP TRIGGER study_document_inserts_trigger_after ON public.study_document_inserts;
/*

    CREATE TRIGGER study_document_inserts_trigger_after
    AFTER UPDATE
    ON public.study_document_inserts
    FOR EACH ROW
    EXECUTE PROCEDURE public.study_document_inserts_process();
*/
