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
function Constant_client_offer_Edit(id,options){
	options = options || {};	
	
	options.className = "";
	options.editContClassName = "";
	options.viewClass = Constant_client_offer_View;
	options.dialogWidth = "50%";
	
	Constant_client_offer_Edit.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(Constant_client_offer_Edit, EditModalDialog);//Control

/* Constants */


/* private members */

/* protected*/


/* public methods */

Constant_client_offer_Edit.prototype.formatValue = function(val){
	return "Оферта";
}

Constant_client_offer_Edit.prototype.closeSelect = function(modif){
	Constant_client_offer_Edit.superclass.closeSelect.call(this, modif);
	
	if(modif){
		window.getApp().getConstantManager().set("client_offer", CommonHelper.serialize(this.m_valueJSON));
	}
}

