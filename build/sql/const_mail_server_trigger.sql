-- Trigger: const_mail_server_trigger_after on public.const_mail_server

-- DROP TRIGGER const_mail_server_trigger_after ON public.const_mail_server;


CREATE TRIGGER const_mail_server_trigger_after
  AFTER UPDATE
  ON public.const_mail_server
  FOR EACH ROW
  EXECUTE PROCEDURE public.const_mail_server_process();

