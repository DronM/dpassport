/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 * @class
 * @classdesc Grid column Enumerator class. Created from build/templates/enumGridColumn.js.tmpl !!!DO NOT MODIFY!!!
 
 * @extends GridColumnEnum
 
 * @requires core/extend.js
 * @requires controls/GridColumnEnum.js
 
 * @param {object} options
 */

function EnumGridColumn_object_mod_actions(options){
	options = options || {};
	
	options.multyLangValues = {};
	options.multyLangValues["ru"] = {};
	options.multyLangValues["ru"]["insert"] = "Добавление";
	
	options.multyLangValues["ru"]["update"] = "Изменение";
	
	options.multyLangValues["ru"]["delete"] = "Удаление";
	
	options.multyLangValues["ru"]["upload_scan"] = "Добавлен скан";
	
	options.multyLangValues["ru"]["delete_scan"] = "Удален скан";
	
	options.ctrlClass = options.ctrlClass || Enum_object_mod_actions;
	options.searchOptions = options.searchOptions || {};
	options.searchOptions.searchType = options.searchOptions.searchType || "on_match";
	options.searchOptions.typeChange = (options.searchOptions.typeChange!=undefined)? options.searchOptions.typeChange:false;
	
	EnumGridColumn_object_mod_actions.superclass.constructor.call(this,options);		
}
extend(EnumGridColumn_object_mod_actions, GridColumnEnum);

