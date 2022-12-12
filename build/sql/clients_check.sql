-- Function: clients_check(in_client clients)

/* DROP FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text);
*/

-- ALTER TABLE clients ADD CONSTRAINT clients_clients_check CHECK (clients_check(id,parent_id,inn,kpp,ogrn,name));
-- ALTER TABLE clients DROP CONSTRAINT clients_clients_check;

CREATE OR REPLACE FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text)
  RETURNS bool AS
$$
	SELECT
		--Верные
		CASE WHEN in_client_id < 1000000000 THEN TRUE
		ELSE
			--Поиск дубля
			coalesce(
				(SELECT
					TRUE
				FROM clients AS cl
				WHERE  
					--Не есть он сам
					(in_client_id IS NULL OR cl.id<>in_client_id)
					AND 	(
							(in_client_parent_id IS NOT NULL AND cl.parent_id = in_client_parent_id)
							OR
							(in_client_parent_id IS NULL AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
							OR
							(in_client_parent_id = in_client_id AND (cl.parent_id IS NULL OR cl.parent_id = cl.id))
						)
					AND	(
							(in_client_inn = cl.inn AND coalesce(in_client_kpp,'') = coalesce(cl.kpp,''))
					
							--ЗАБИТЬ!!!
							--OR lower(in_client_name) = lower(cl.name)
							--ВКЛЮЧИТЬ В РАБОЧЕЙ!!!
							--OR coalesce(in_client_ogrn,'') = coalesce(cl.ogrn,'')
						)
				LIMIT 1)
			, FALSE) = FALSE
		END
	;
$$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION clients_check(in_client_id int, in_client_parent_id int, in_client_inn varchar(12),
		in_client_kpp varchar(10), in_client_ogrn varchar(15), in_client_name text) OWNER TO ;
