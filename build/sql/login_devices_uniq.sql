-- Function: login_devices_uniq(user_agent jsonb)

-- DROP FUNCTION login_devices_uniq(user_agent jsonb);

-- Совпадает с функцией в User_Controller!!!
CREATE OR REPLACE FUNCTION login_devices_uniq(user_agent jsonb)
  RETURNS text AS
$$
	SELECT CASE WHEN (user_agent->>'bot')::bool THEN 'Бот, ' ELSE '' END||
		CASE WHEN (user_agent->>'mobile')::bool THEN 'Мобильное устр-во, ' ELSE '' END||
		'ОС:'||(user_agent->>'osName')::text||', '||
		'платформа: '||(user_agent->>'platform')::text
	;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION login_devices_uniq(user_agent jsonb) OWNER TO ;

