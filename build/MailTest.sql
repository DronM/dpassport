INSERT INTO public.mail_messages(
	from_addr, from_name, to_addr, to_name, reply_addr, reply_name, body, sender_addr, subject, mail_type)
	VALUES ('katrenplus@mail.ru', 'Andrey',
			'katren_shd@rambler.ru', 'Anrdey Mikhalevich',
			'katrenplus@mail.ru', 'Andrey',
			'Message test',
			'katrenplus@mail.ru',
			'Test',
		   'person_register');
