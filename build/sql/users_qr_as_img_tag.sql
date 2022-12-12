-- Function: users_qr_as_img_tag(in_qr bytea)

-- DROP FUNCTION users_qr_as_img_tag(in_qr bytea);

CREATE OR REPLACE FUNCTION users_qr_as_img_tag(in_qr bytea)
  RETURNS text AS
$$
	SELECT '<img src="data:image/png;base64,  '||encode(in_qr, 'base64')||'" </img>';
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION users_qr_as_img_tag(in_qr bytea) OWNER TO ;
