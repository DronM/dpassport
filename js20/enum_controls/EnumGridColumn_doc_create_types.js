/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 * @class
 * @classdesc Grid column Enumerator class. Created from build/templates/enumGridColumn.js.tmpl !!!DO NOT MODIFY!!!
 
 * @extends GridColumnEnum
 
 * @requires core/extend.js
 * @requires controls/GridColumnEnum.js
 
 * @param {object} options
 */

function EnumGridColumn_doc_create_types(options){
	options = options || {};
	
	options.multyLangValues = {};
	options.multyLangValues["ru"] = {};
	options.multyLangValues["ru"]["manual"] = "Вручную";
	
	options.multyLangValues["ru"]["upload"] = "Загружено из файла";
	
	options.multyLangValues["ru"]["api"] = "Загружено через API";
	
	options.ctrlClass = options.ctrlClass || Enum_doc_create_types;
	options.searchOptions = options.searchOptions || {};
	options.searchOptions.searchType = options.searchOptions.searchType || "on_match";
	options.searchOptions.typeChange = (options.searchOptions.typeChange!=undefined)? options.searchOptions.typeChange:false;
	
	EnumGridColumn_doc_create_types.superclass.constructor.call(this,options);		
}
extend(EnumGridColumn_doc_create_types, GridColumnEnum);

