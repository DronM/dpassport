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
function Constant_mail_server_Edit(id,options){
	options = options || {};	
	
	options.className = "";
	options.editContClassName = "";
	options.viewClass = Constant_mail_server_View;
	options.dialogWidth = "50%";
	
	Constant_mail_server_Edit.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(Constant_mail_server_Edit, EditModalDialog);//Control

/* Constants */


/* private members */

/* protected*/


/* public methods */

Constant_mail_server_Edit.prototype.formatValue = function(val){
	var res = "";	
	if(val["name"]){
		res = "Имя:" +val["name"];
	}
	if(val["mail"]){
		res+= (res=="")? "":", ";
		res+= "адрес:" +val["mail"];
	}
	
	return res;
}

Constant_mail_server_Edit.prototype.closeSelect = function(modif){
	Constant_mail_server_Edit.superclass.closeSelect.call(this, modif);
	
	if(modif){
		window.getApp().getConstantManager().set("mail_server", CommonHelper.serialize(this.m_valueJSON));
	}
}

