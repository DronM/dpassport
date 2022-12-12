/* Copyright (c) 2022 
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentInsertEdit(id,options){
	options = options || {};	
	
	options.cmdInsert = false;
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = StudyDocumentInsertList_Form;
	options.selectDescrIds = options.selectDescrIds || ["name_full"];
	
	//форма редактирования элемента
	options.editWinClass = null;
	
	options.acMinLengthForQuery = 1;
	options.acController = new StudyDocumentInsert_Controller(options.app);
	options.acModel = new StudyDocumentInsertSelectList_Model();
	options.acPatternFieldId = options.acPatternFieldId || "name_full";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("name_full")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";
	
	StudyDocumentInsertEdit.superclass.constructor.call(this,id,options);
}
extend(StudyDocumentInsertEdit, EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */

