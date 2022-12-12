/*
 * Copyright (c) 2022
 * Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentRegisterList_Form(options){
	options = options || {};	
	
	options.formName = "StudyDocumentRegisterList";
	options.controller = "StudyDocumentRegister_Controller";
	options.method = "get_list";
	
	StudyDocumentRegisterList_Form.superclass.constructor.call(this,options);
		
}
extend(StudyDocumentRegisterList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

