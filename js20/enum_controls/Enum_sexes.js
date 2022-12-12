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

function Enum_sexes(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"male",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"male"],
checked:(options.defaultValue&&options.defaultValue=="male")}
	, {"value":"female",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"female"],
checked:(options.defaultValue&&options.defaultValue=="female")}
	];
	
	Enum_sexes.superclass.constructor.call(this, id, options);
	
}
extend(Enum_sexes,EditSelect);

Enum_sexes.prototype.multyLangValues = {
	"ru_male":"Мужской", "ru_female":"Женский"
};


