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

function Enum_doc_create_types(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"manual",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"manual"],
checked:(options.defaultValue&&options.defaultValue=="manual")}
	, {"value":"upload",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"upload"],
checked:(options.defaultValue&&options.defaultValue=="upload")}
	, {"value":"api",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"api"],
checked:(options.defaultValue&&options.defaultValue=="api")}
	];
	
	Enum_doc_create_types.superclass.constructor.call(this, id, options);
	
}
extend(Enum_doc_create_types,EditSelect);

Enum_doc_create_types.prototype.multyLangValues = {
	"ru_manual":"Вручную", "ru_upload":"Загружено из файла", "ru_api":"Загружено через API"
};


