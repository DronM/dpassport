-- Function: text_to_float_safe_cast(in_text text)

-- DROP FUNCTION text_to_float_safe_cast(in_text text);

CREATE OR REPLACE FUNCTION text_to_float_safe_cast(in_text text)
  RETURNS numeric AS
$$
	SELECT CASE WHEN coalesce(in_text,'') = '' THEN NULL ELSE in_text::numeric END;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION text_to_float_safe_cast(in_text text) OWNER TO ;
