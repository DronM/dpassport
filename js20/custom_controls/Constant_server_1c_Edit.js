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
function Constant_server_1c_Edit(id,options){
	options = options || {};	
	
	options.className = "";
	options.editContClassName = "";
	options.viewClass = Constant_server_1c_View;
	options.dialogWidth = "50%";
	
	Constant_server_1c_Edit.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(Constant_server_1c_Edit, EditModalDialog);//Control

/* Constants */


/* private members */

/* protected*/


/* public methods */

Constant_server_1c_Edit.prototype.formatValue = function(val){
	var res = "";	
	if(val["host"]){
		res = "Хост:" +val["host"];
	}
	
	return res;
}

Constant_server_1c_Edit.prototype.closeSelect = function(modif){
	Constant_server_1c_Edit.superclass.closeSelect.call(this, modif);
	
	if(modif){
		window.getApp().getConstantManager().set("server_1c", CommonHelper.serialize(this.m_valueJSON));
	}
}

