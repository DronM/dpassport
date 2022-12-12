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

function Enum_test_enum(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"v1",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"v1"],
checked:(options.defaultValue&&options.defaultValue=="v1")}
	, {"value":"v2",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"v2"],
checked:(options.defaultValue&&options.defaultValue=="v2")}
	];
	
	Enum_test_enum.superclass.constructor.call(this, id, options);
	
}
extend(Enum_test_enum,EditSelect);

Enum_test_enum.prototype.multyLangValues = {
	"ru_v1":"Значение1", "ru_v2":"Значение2"
};


