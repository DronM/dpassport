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
function Constant_study_document_register_fields_Edit(id,options){
	options = options || {};	
	
	options.className = "";
	options.editContClassName = "";
	options.viewClass = Constant_study_document_register_fields_View;
	options.dialogWidth = "70%";
	
	Constant_study_document_register_fields_Edit.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(Constant_study_document_register_fields_Edit, EditModalDialog);//Control

/* Constants */


/* private members */

/* protected*/


/* public methods */

Constant_study_document_register_fields_Edit.prototype.formatValue = function(val){
	var res = "";	
	if(val.rows){
		var r_arr;
		if(typeof val.rows == "string"){
			r_arr = CommonHelper.unserialize(val.rows);
		}else{
			r_arr = val.rows
		}
		var s = "";
		for(var i=0; i< r_arr.length;i++){
			s+= (s=="")? "":", ";
			s+= r_arr[i]["descr"];
		}
		res = "Порядок полей: "+s;
	}
	
	return res;
}

Constant_study_document_register_fields_Edit.prototype.closeSelect = function(modif){
	Constant_study_document_register_fields_Edit.superclass.closeSelect.call(this, modif);
	
	if(modif){
	//console.log("Constant_study_document_register_fields_Edit.closeSelect stub", CommonHelper.serialize(this.m_valueJSON))
		window.getApp().getConstantManager().set("study_document_register_fields", CommonHelper.serialize(this.m_valueJSON));
	}
}

