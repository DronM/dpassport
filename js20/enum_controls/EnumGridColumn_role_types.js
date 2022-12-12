/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 * @class
 * @classdesc Grid column Enumerator class. Created from build/templates/enumGridColumn.js.tmpl !!!DO NOT MODIFY!!!
 
 * @extends GridColumnEnum
 
 * @requires core/extend.js
 * @requires controls/GridColumnEnum.js
 
 * @param {object} options
 */

function EnumGridColumn_role_types(options){
	options = options || {};
	
	options.multyLangValues = {};
	options.multyLangValues["ru"] = {};
	options.multyLangValues["ru"]["admin"] = "Администратор";
	
	options.multyLangValues["ru"]["client_admin1"] = "Администратор уровень 1";
	
	options.multyLangValues["ru"]["client_admin2"] = "Администратор уровень 2";
	
	options.multyLangValues["ru"]["person"] = "Физическое лицо";
	
	options.ctrlClass = options.ctrlClass || Enum_role_types;
	options.searchOptions = options.searchOptions || {};
	options.searchOptions.searchType = options.searchOptions.searchType || "on_match";
	options.searchOptions.typeChange = (options.searchOptions.typeChange!=undefined)? options.searchOptions.typeChange:false;
	
	EnumGridColumn_role_types.superclass.constructor.call(this,options);		
}
extend(EnumGridColumn_role_types, GridColumnEnum);

