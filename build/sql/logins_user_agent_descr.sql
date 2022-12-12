-- Function: logins_user_agent_descr(user_agent jsonb)

-- DROP FUNCTION logins_user_agent_descr(user_agent jsonb);

CREATE OR REPLACE FUNCTION logins_user_agent_descr(user_agent jsonb)
  RETURNS text AS
$$
	SELECT
		CASE WHEN (user_agent->>'bot')::bool THEN 'Бот, ' ELSE '' END||
		CASE WHEN (user_agent->>'mobile')::bool THEN 'Мобильное устр-во, ' ELSE '' END||
		'ОС:'||(user_agent->>'osName')::text||', '||
		CASE WHEN coalesce(user_agent->>'osVersion','')<>'' THEN 'версия:'||(user_agent->>'osVersion')::text||', ' ELSE '' END||	
		'платформа: '||(user_agent->>'platform')::text||', '||
		CASE WHEN coalesce(user_agent->>'browserName','')<>'' THEN 'браузер:'||(user_agent->>'browserName')::text||' '||(user_agent->>'browserVersion')::text||', ' ELSE '' END
	
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION logins_user_agent_descr(user_agent jsonb) OWNER TO ;

