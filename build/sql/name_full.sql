-- Function: name_full(in_name_first text, in_name_second text, in_name_middle text)

-- DROP FUNCTION name_full(in_name_first text, in_name_second text, in_name_middle text);

CREATE OR REPLACE FUNCTION name_full(in_name_first text, in_name_second text, in_name_middle text)
  RETURNS text AS
$$
	SELECT
		coalesce(in_name_second,'')||
		CASE WHEN coalesce(in_name_second,'')<>'' THEN ' ' ELSE '' END||coalesce(in_name_first,'')||
		CASE WHEN coalesce(in_name_first,'')<>'' THEN ' '
			WHEN coalesce(in_name_second,'')<>'' THEN ' '
			ELSE '' END
			||coalesce(in_name_middle,'')
		;
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION name_full(in_name_first text, in_name_second text, in_name_middle text) OWNER TO ;
