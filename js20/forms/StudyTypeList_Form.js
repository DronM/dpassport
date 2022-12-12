/*
 * Copyright (c) 2022
 * Andrey Mikhalevich, Katren ltd.
 */
function StudyTypeList_Form(options){
	options = options || {};	
	
	options.formName = "StudyTypeList";
	options.controller = "StudyType_Controller";
	options.method = "get_list";
	
	StudyTypeList_Form.superclass.constructor.call(this,options);
		
}
extend(StudyTypeList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

