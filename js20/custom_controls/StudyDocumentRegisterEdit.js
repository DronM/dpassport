/* Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentRegisterEdit(id,options){
	options = options || {};	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Протокол:";
	}
	options.cmdInsert = (options.cmdInsert!=undefined)? options.cmdInsert:false;
	var self = this;
	options.placeholder = "Введите наименование для поиска";
	
	options.keyIds = options.keyIds || ["id"];
	
	//форма выбора из списка
	options.selectWinClass = StudyDocumentRegisterList_Form;
	options.selectDescrIds = options.selectDescrIds || ["self_descr"];
	
	//форма редактирования элемента
	options.editWinClass = StudyDocumentRegister_Form;
	
	options.acMinLengthForQuery = 1;
	options.acController = new StudyDocumentRegister_Controller();
	options.acModel = new StudyDocumentRegisterList_Model();
	options.acPatternFieldId = options.acPatternFieldId || "name";
	options.acKeyFields = options.acKeyFields || [options.acModel.getField("id")];
	options.acDescrFields = options.acDescrFields || [options.acModel.getField("self_descr")];
	options.acICase = options.acICase || "1";
	options.acMid = options.acMid || "1";

	StudyDocumentRegisterEdit.superclass.constructor.call(this,id,options);
}
extend(StudyDocumentRegisterEdit,EditRef);

/* Constants */


/* private members */

/* protected*/


/* public methods */

