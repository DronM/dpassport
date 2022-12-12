-- View: users_profile

 DROP VIEW users_profile;

CREATE OR REPLACE VIEW users_profile AS 
	SELECT
	 	u.id,
	 	u.name,
	 	u.name_full,
	 	u.post,
	 	u.snils,
	 	u.phone_cel,
	 	u.locale_id,
	 	time_zone_locales_ref(tzl) AS time_zone_locales_ref,
	 	u.sex,
	 	u.person_url,
	 	clients_ref(cl) AS companies_ref
		,encode(u.qr_code, 'base64') AS qr_code
	 	
 	FROM users AS u
 	LEFT JOIN time_zone_locales AS tzl ON tzl.id=u.time_zone_locale_id
 	LEFT JOIN clients AS cl ON cl.id = u.company_id
	;
ALTER TABLE users_profile OWNER TO ;

