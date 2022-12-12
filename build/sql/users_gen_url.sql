-- Function: users_gen_url(in_url text)

-- DROP FUNCTION users_gen_url(in_url text);

CREATE OR REPLACE FUNCTION users_gen_url(in_url text)
  RETURNS text AS
$$
	SELECT md5(gen_random_uuid()::text);
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION users_gen_url(in_url text) OWNER TO ;
