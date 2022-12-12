-- Тип соответствует структуре Golang controllers.mailMessage

--DROP TYPE mail_message CASCADE;

CREATE TYPE mail_message AS (
	to_addr text,
	to_name text,
	body text,
	subject text,
	mail_type mail_types
);

