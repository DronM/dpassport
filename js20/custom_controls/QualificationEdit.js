/* Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function QualificationEdit(id,options){
	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Квалификация:";
	}
	options.cmdInsert = false;
	options.title = options.title || "Значение должно быть выбрано строго из определенного списка";
	options.placeholder = options.placeholder || "Выберите из справочника";
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = QualificationList_Form;
	options.selectDescrIds = options.selectDescrIds || ["name"];
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = 1;
	options.acController = new Qualification_Controller(options.app);
	options.acModel = new Qualification_Model();
	options.acPatternFieldId = options.acPatternFieldId || "name";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	QualificationEdit.superclass.constructor.call(this,id,options);
}
extend(QualificationEdit, EditComplete);

/* Constants */


/* private members */

/* protected*/


/* public methods */

