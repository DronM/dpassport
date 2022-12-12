-- Trigger: const_api_server_trigger_after on public.const_api_server

-- DROP TRIGGER const_api_server_trigger_after ON public.const_api_server;


CREATE TRIGGER const_api_server_trigger_after
  AFTER UPDATE
  ON public.const_api_server
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_api_server_process();

