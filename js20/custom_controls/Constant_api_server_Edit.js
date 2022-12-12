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
function Constant_api_server_Edit(id,options){
	options = options || {};	
	
	options.className = "";
	options.editContClassName = "";
	options.viewClass = Constant_api_server_View;
	options.dialogWidth = "50%";
	
	Constant_api_server_Edit.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(Constant_api_server_Edit, EditModalDialog);//Control

/* Constants */


/* private members */

/* protected*/


/* public methods */

Constant_api_server_Edit.prototype.formatValue = function(val){
	var res = "";	
	if(val["check_interval_ms"]){
		res = "Период обновления:" +val["check_interval_ms"];
	}
	if(val["host"]){
		res+= (res=="")? "":", ";
		res+= "хост:" +val["host"];
	}
	if(val["worker_count"]){
		res+= (res=="")? "":", ";
		res+= "потоков:" +val["worker_count"];
	}
	
	return res;
}

Constant_api_server_Edit.prototype.closeSelect = function(modif){
	Constant_api_server_Edit.superclass.closeSelect.call(this, modif);
	
	if(modif){
		window.getApp().getConstantManager().set("api_server", CommonHelper.serialize(this.m_valueJSON));
	}
}

