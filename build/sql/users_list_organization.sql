-- Function: users_list_organization(in_company_id int, in_parent_id int)

-- DROP FUNCTION users_list_organization(in_company_id int, in_parent_id int);

CREATE OR REPLACE FUNCTION users_list_organization(in_company_id int, in_parent_id int)
  RETURNS int AS
$$
	SELECT in_company_id
$$
  LANGUAGE sql IMMUTABLE
  COST 100;
ALTER FUNCTION users_list_organization(in_company_id int, in_parent_id int) OWNER TO ;
