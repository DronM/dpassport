/*
 * Copyright (c) 2022
 * Andrey Mikhalevich, Katren ltd.
 */
function StudyFormList_Form(options){
	options = options || {};	
	
	options.formName = "StudyFormList";
	options.controller = "StudyForm_Controller";
	options.method = "get_list";
	
	StudyFormList_Form.superclass.constructor.call(this,options);
		
}
extend(StudyFormList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

