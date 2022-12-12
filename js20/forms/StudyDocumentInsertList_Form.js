/*
 * Copyright (c) 2022
 * Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentInsertList_Form(options){
	options = options || {};	
	
	options.formName = "StudyDocumentInsertList";
	options.controller = "StudyDocumentInsert_Controller";
	options.method = "get_list";
	
	StudyDocumentInsertList_Form.superclass.constructor.call(this,options);
		
}
extend(StudyDocumentInsertList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

