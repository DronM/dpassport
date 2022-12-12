/* Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyFormEdit(id,options){
	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Форма обучения:";
	}
	options.cmdInsert = false;
	options.title = options.title || "Значение должно быть выбрано строго из определенного списка";
	options.placeholder = options.placeholder || "Выберите из справочника";
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = StudyFormList_Form;
	options.selectDescrIds = options.selectDescrIds || ["name"];
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = 1;
	options.acController = new StudyForm_Controller(options.app);
	options.acModel = new StudyForm_Model();
	options.acPatternFieldId = options.acPatternFieldId || "name";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	StudyFormEdit.superclass.constructor.call(this,id,options);
}
extend(StudyFormEdit, EditComplete);

/* Constants */


/* private members */

/* protected*/


/* public methods */

