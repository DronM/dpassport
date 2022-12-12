/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 * @class
 * @classdesc Grid column Enumerator class. Created from build/templates/enumGridColumn.js.tmpl !!!DO NOT MODIFY!!!
 
 * @extends GridColumnEnum
 
 * @requires core/extend.js
 * @requires controls/GridColumnEnum.js
 
 * @param {object} options
 */

function EnumGridColumn_data_types(options){
	options = options || {};
	
	options.multyLangValues = {};
	options.multyLangValues["ru"] = {};
	options.multyLangValues["ru"]["users"] = "Пользователи";
	
	options.multyLangValues["ru"]["study_document_types"] = "Виды документов";
	
	options.multyLangValues["ru"]["client_accesses"] = "Доступы площадок";
	
	options.multyLangValues["ru"]["clients"] = "Площадка";
	
	options.multyLangValues["ru"]["study_document_registers"] = "Протокол";
	
	options.multyLangValues["ru"]["study_documents"] = "Документ";
	
	options.multyLangValues["ru"]["study_document_attachments"] = "Вложение документа";
	
	options.ctrlClass = options.ctrlClass || Enum_data_types;
	options.searchOptions = options.searchOptions || {};
	options.searchOptions.searchType = options.searchOptions.searchType || "on_match";
	options.searchOptions.typeChange = (options.searchOptions.typeChange!=undefined)? options.searchOptions.typeChange:false;
	
	EnumGridColumn_data_types.superclass.constructor.call(this,options);		
}
extend(EnumGridColumn_data_types, GridColumnEnum);

