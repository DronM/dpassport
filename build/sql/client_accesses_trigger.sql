-- Trigger: client_accesses_trigger_after on public.client_accesses

-- DROP TRIGGER client_accesses_trigger_after ON public.client_accesses;


CREATE TRIGGER client_accesses_trigger_after
  AFTER UPDATE OR INSERT
  ON public.client_accesses
  FOR EACH ROW
  EXECUTE PROCEDURE public.client_accesses_process();

