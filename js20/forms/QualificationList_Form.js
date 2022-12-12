/*
 * Copyright (c) 2022
 * Andrey Mikhalevich, Katren ltd.
 */
function QualificationList_Form(options){
	options = options || {};	
	
	options.formName = "QualificationList";
	options.controller = "Qualification_Controller";
	options.method = "get_list";
	
	QualificationList_Form.superclass.constructor.call(this,options);
		
}
extend(QualificationList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

