-- Function: text_to_int_safe_cast(in_text text)

-- DROP FUNCTION text_to_int_safe_cast(in_text text);

CREATE OR REPLACE FUNCTION text_to_int_safe_cast(in_text text)
  RETURNS int AS
$$
	SELECT CASE WHEN coalesce(in_text,'') = '' THEN NULL ELSE in_text::int END
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION text_to_int_safe_cast(in_text text) OWNER TO ;
