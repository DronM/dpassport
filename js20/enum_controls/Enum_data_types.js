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

function Enum_data_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"users",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"users"],
checked:(options.defaultValue&&options.defaultValue=="users")}
	, {"value":"study_document_types",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"study_document_types"],
checked:(options.defaultValue&&options.defaultValue=="study_document_types")}
	, {"value":"client_accesses",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"client_accesses"],
checked:(options.defaultValue&&options.defaultValue=="client_accesses")}
	, {"value":"clients",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"clients"],
checked:(options.defaultValue&&options.defaultValue=="clients")}
	, {"value":"study_document_registers",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"study_document_registers"],
checked:(options.defaultValue&&options.defaultValue=="study_document_registers")}
	, {"value":"study_documents",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"study_documents"],
checked:(options.defaultValue&&options.defaultValue=="study_documents")}
	, {"value":"study_document_attachments",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"study_document_attachments"],
checked:(options.defaultValue&&options.defaultValue=="study_document_attachments")}
	];
	
	Enum_data_types.superclass.constructor.call(this, id, options);
	
}
extend(Enum_data_types,EditSelect);

Enum_data_types.prototype.multyLangValues = {
	"ru_users":"Пользователи", "ru_study_document_types":"Виды документов", "ru_client_accesses":"Доступы площадок", "ru_clients":"Площадка", "ru_study_document_registers":"Протокол", "ru_study_documents":"Документ", "ru_study_document_attachments":"Вложение документа"
};


