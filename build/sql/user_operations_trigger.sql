-- Trigger: user_operations_trigger_after on public.user_operations

-- DROP TRIGGER user_operations_trigger_after ON public.user_operations;


CREATE TRIGGER user_operations_trigger_after
  AFTER UPDATE
  ON public.user_operations
  FOR EACH ROW
  EXECUTE PROCEDURE public.user_operations_process();

