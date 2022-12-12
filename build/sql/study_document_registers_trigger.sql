-- Trigger: study_document_registers_trigger_before on public.study_document_registers

-- DROP TRIGGER study_document_registers_trigger_before ON public.study_document_registers;


CREATE TRIGGER study_document_registers_trigger_before
  BEFORE DELETE
  ON public.study_document_registers
  FOR EACH ROW
  EXECUTE PROCEDURE public.study_document_registers_process();

