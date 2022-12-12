/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends EditJSON
 * @requires core/extend.js
 * @requires controls/EditJSON.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function Constant_mail_server_View(id,options){

	options = options || {};
	
	options.className = options.className || "form-group";
	
	var self = this;

	options.addElement = function(){
		var id = this.getId();

		this.addElement(new EditEmail(id+":user",{
			"maxLength":"200",
			"labelCaption":"Имя пользователя:",
			"title":"Адрес почты отправителя в виде имя@хост"
		}));
		this.addElement(new EditString(id+":name",{
			"maxLength":"500",
			"labelCaption":"Имя отправителя:",
			"title":"Имя отправителя электронной почты"
		}));
		this.addElement(new EditEmail(id+":reply_mail",{
			"maxLength":"200",
			"labelCaption":"Адрес для ответа (имя@хост):",
			"title":"Адрес почты отправителя для ответных писем в виде имя@хост"
		}));
		this.addElement(new EditString(id+":reply_name",{
			"maxLength":"500",
			"labelCaption":"Имя отправителя для ответа:",
			"title":"Имя отправителя электронной почты для ответных писем"
		}));
		//imap :993
		this.addElement(new EditString(id+":smtp_host",{
			"maxLength":"200",
			"labelCaption":"Хост SMTP (хост:порт):",
			"title":"Хост SMTP в виде ИМЯ_ХОСТА:НОМЕР_ПОРТА, например, для mail.ru smtp.mail.ru:465"
		}));
		this.addElement(new EditPassword(id+":pwd",{
			"maxLength":"200",
			"labelCaption":"Пароль:"
		}));
		this.addElement(new EditNum(id+":check_interval_ms",{
			"labelCaption":"Интервал отправки писем (мс):",
			"title":"С заданным интервалом сервер будет отправлять новые письма. Устанавливается в миллисекундах."
		}));

	}	
	Constant_mail_server_View.superclass.constructor.call(this,id,options);
	
}
extend(Constant_mail_server_View, EditJSON);

/* Constants */


/* private members */

/* protected*/


/* public methods */

