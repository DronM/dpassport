/* Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientEditStr(id,options){
	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Организация:";
	}
	options.cmdInsert = false;
	options.title = options.title || "Значение может быть выбрано из списка";
	options.placeholder = options.placeholder || "Выберите из справочника";
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = ClientList_Form;
	options.selectDescrIds = options.selectDescrIds || ["name"];
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = 1;
	options.acController = new Client_Controller(options.app);
	options.acModel = new Client_Model();
	options.acPatternFieldId = options.acPatternFieldId || "name";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	ClientEditStr.superclass.constructor.call(this,id,options);
}
extend(ClientEditStr, EditComplete);//

/* Constants */


/* private members */

/* protected*/


/* public methods */
/*
ProfessionEdit.prototype.getIsRef = function(){
	return false;
}

ProfessionEdit.prototype.getValue = function(){
	return this.getNode().value;
}

ProfessionEdit.prototype.setInitValue = function(val){
	this.setValue(val);
	this.setAttr(this.VAL_INIT_ATTR, this.getValue());
}

ProfessionEdit.prototype.getModified = function(){
	return (this.getValue()!=this.getInitValue());
}
*/
