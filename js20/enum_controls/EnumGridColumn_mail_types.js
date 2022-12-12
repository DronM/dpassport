/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 * @class
 * @classdesc Grid column Enumerator class. Created from build/templates/enumGridColumn.js.tmpl !!!DO NOT MODIFY!!!
 
 * @extends GridColumnEnum
 
 * @requires core/extend.js
 * @requires controls/GridColumnEnum.js
 
 * @param {object} options
 */

function EnumGridColumn_mail_types(options){
	options = options || {};
	
	options.multyLangValues = {};
	options.multyLangValues["ru"] = {};
	options.multyLangValues["ru"]["person_register"] = "Регистрация физического лица";
	
	options.multyLangValues["ru"]["password_recover"] = "Восстановление пароля";
	
	options.multyLangValues["ru"]["admin_1_register"] = "Регистрация администратора тип 1";
	
	options.multyLangValues["ru"]["client_activation"] = "Активация площадки";
	
	options.multyLangValues["ru"]["client_registration"] = "Регистрация новой площадки";
	
	options.multyLangValues["ru"]["client_expiration"] = "Предупреждение об окончании срока оплаты площадки";
	
	options.multyLangValues["ru"]["person_url"] = "Персональная ссылка для входа в личный кабинет";
	
	options.multyLangValues["ru"]["user_activation"] = "Активация пользователя";
	
	options.multyLangValues["ru"]["client_order"] = "Счет на оплату клиенту";
	
	options.ctrlClass = options.ctrlClass || Enum_mail_types;
	options.searchOptions = options.searchOptions || {};
	options.searchOptions.searchType = options.searchOptions.searchType || "on_match";
	options.searchOptions.typeChange = (options.searchOptions.typeChange!=undefined)? options.searchOptions.typeChange:false;
	
	EnumGridColumn_mail_types.superclass.constructor.call(this,options);		
}
extend(EnumGridColumn_mail_types, GridColumnEnum);

