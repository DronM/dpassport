/*
 * Copyright (c) 2022
 * Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentList_Form(options){
	options = options || {};	
	
	options.formName = "StudyDocumentList";
	options.controller = "StudyDocument_Controller";
	options.method = "get_list";
	
	StudyDocumentList_Form.superclass.constructor.call(this,options);
		
}
extend(StudyDocumentList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

