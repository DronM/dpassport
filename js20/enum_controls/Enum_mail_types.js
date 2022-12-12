/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 * @class
 * @classdesc Enumerator class. Created from template build/templates/enum.js.tmpl. !!!DO NOT MODIFY!!!
 
 * @extends EditSelect
 
 * @requires core/extend.js
 * @requires controls/EditSelect.js
 
 * @param string id 
 * @param {object} options
 */

function Enum_mail_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"person_register",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"person_register"],
checked:(options.defaultValue&&options.defaultValue=="person_register")}
	, {"value":"password_recover",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"password_recover"],
checked:(options.defaultValue&&options.defaultValue=="password_recover")}
	, {"value":"admin_1_register",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"admin_1_register"],
checked:(options.defaultValue&&options.defaultValue=="admin_1_register")}
	, {"value":"client_activation",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"client_activation"],
checked:(options.defaultValue&&options.defaultValue=="client_activation")}
	, {"value":"client_registration",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"client_registration"],
checked:(options.defaultValue&&options.defaultValue=="client_registration")}
	, {"value":"client_expiration",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"client_expiration"],
checked:(options.defaultValue&&options.defaultValue=="client_expiration")}
	, {"value":"person_url",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"person_url"],
checked:(options.defaultValue&&options.defaultValue=="person_url")}
	, {"value":"user_activation",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"user_activation"],
checked:(options.defaultValue&&options.defaultValue=="user_activation")}
	, {"value":"client_order",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"client_order"],
checked:(options.defaultValue&&options.defaultValue=="client_order")}
	];
	
	Enum_mail_types.superclass.constructor.call(this, id, options);
	
}
extend(Enum_mail_types,EditSelect);

Enum_mail_types.prototype.multyLangValues = {
	"ru_person_register":"Регистрация физического лица", "ru_password_recover":"Восстановление пароля", "ru_admin_1_register":"Регистрация администратора тип 1", "ru_client_activation":"Активация площадки", "ru_client_registration":"Регистрация новой площадки", "ru_client_expiration":"Предупреждение об окончании срока оплаты площадки", "ru_person_url":"Персональная ссылка для входа в личный кабинет", "ru_user_activation":"Активация пользователя", "ru_client_order":"Счет на оплату клиенту"
};


