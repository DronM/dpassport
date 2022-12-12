/* Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyTypeEdit(id,options){
	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Вид обучения:";
	}
	options.cmdInsert = false;
	options.title = options.title || "Значение должно быть выбрано строго из определенного списка";
	options.placeholder = options.placeholder || "Выберите из справочника";
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = StudyTypeList_Form;
	options.selectDescrIds = options.selectDescrIds || ["name"];
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = 1;
	options.acController = new StudyType_Controller(options.app);
	options.acModel = new StudyType_Model();
	options.acPatternFieldId = options.acPatternFieldId || "name";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	StudyTypeEdit.superclass.constructor.call(this,id,options);
}
extend(StudyTypeEdit, EditComplete);

/* Constants */


/* private members */

/* protected*/


/* public methods */

