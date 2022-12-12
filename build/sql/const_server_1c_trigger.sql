-- Trigger: const_server_1c_trigger_after on public.const_server_1c

-- DROP TRIGGER const_server_1c_trigger_after ON public.const_server_1c;

/*
CREATE TRIGGER const_server_1c_trigger_after
  AFTER UPDATE
  ON public.const_server_1c
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_server_1c_process();
*/

-- Trigger: const_server_1c_trigger_before on public.const_server_1c

-- DROP TRIGGER const_server_1c_trigger_before ON public.const_server_1c;

CREATE TRIGGER const_server_1c_trigger_before
  BEFORE UPDATE
  ON public.const_server_1c
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_server_1c_process();

