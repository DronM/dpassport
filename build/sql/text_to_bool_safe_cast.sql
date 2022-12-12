-- Function: text_to_bool_safe_cast(in_text text)

-- DROP FUNCTION text_to_bool_safe_cast(in_text text);

CREATE OR REPLACE FUNCTION text_to_bool_safe_cast(in_text text)
  RETURNS bool AS
$$
	SELECT CASE WHEN coalesce(in_text,'') = '' THEN NULL ELSE in_text::bool END
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION text_to_bool_safe_cast(in_text text) OWNER TO ;
