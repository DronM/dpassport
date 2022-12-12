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

function Enum_role_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"admin",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"admin"],
checked:(options.defaultValue&&options.defaultValue=="admin")}
	, {"value":"client_admin1",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"client_admin1"],
checked:(options.defaultValue&&options.defaultValue=="client_admin1")}
	, {"value":"client_admin2",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"client_admin2"],
checked:(options.defaultValue&&options.defaultValue=="client_admin2")}
	, {"value":"person",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"person"],
checked:(options.defaultValue&&options.defaultValue=="person")}
	];
	
	Enum_role_types.superclass.constructor.call(this, id, options);
	
}
extend(Enum_role_types,EditSelect);

Enum_role_types.prototype.multyLangValues = {
	"ru_admin":"Администратор", "ru_client_admin1":"Администратор уровень 1", "ru_client_admin2":"Администратор уровень 2", "ru_person":"Физическое лицо"
};


