/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends EditString
 * @requires core/extend.js
 * @requires controls/EditString.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function Constant_qr_code_Edit(id,options){
	options = options || {};	
	
	options.className = "";
	options.editContClassName = "";
	options.viewClass = Constant_qr_code_View;
	options.dialogWidth = "50%";
	
	Constant_qr_code_Edit.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(Constant_qr_code_Edit, EditModalDialog);//Control

/* Constants */


/* private members */

/* protected*/


/* public methods */

Constant_qr_code_Edit.prototype.formatValue = function(val){
	var res = "";	
	if(val["url"]){
		res = "URL:" +val["url"];
	}
	
	return res;
}

Constant_qr_code_Edit.prototype.closeSelect = function(modif){
	Constant_qr_code_Edit.superclass.closeSelect.call(this, modif);
	
	if(modif){
		this.m_valueJSON.size = parseInt(this.m_valueJSON.size, 10);
		this.m_valueJSON.recovery_level = parseInt(this.m_valueJSON.recovery_level, 10);
		window.getApp().getConstantManager().set("qr_code", CommonHelper.serialize(this.m_valueJSON));
	}
}

