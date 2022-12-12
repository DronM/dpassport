/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 * @class
 * @classdesc Enumerator class. Created from template build/templates/js/Enum_js.xsl. !!!DO NOT MODIFY!!!
 
 * @extends EditSelect
 
 * @requires core/extend.js
 * @requires controls/EditSelect.js
 
 * @param string id 
 * @param {object} options
 */

function Enum_order_placements(id,options){
	options = options || {};
	options.addNotSelected = (options.addNotSelected!=undefined)? options.addNotSelected:true;
	options.options = [{"value":"email",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"email"],
checked:(options.defaultValue&&options.defaultValue=="email")}
,{"value":"tel",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"tel"],
checked:(options.defaultValue&&options.defaultValue=="tel")}
,{"value":"manual",
"descr":this.multyLangValues[window.getApp().getLocale()+"_"+"manual"],
checked:(options.defaultValue&&options.defaultValue=="manual")}
];
	
	Enum_order_placements.superclass.constructor.call(this,id,options);
	
}
extend(Enum_order_placements,EditSelect);

Enum_order_placements.prototype.multyLangValues = {"ru_email":"Электронная почта", "ru_tel":"Телефон", "ru_manual":"Вручную"
};


