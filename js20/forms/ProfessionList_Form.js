/*
 * Copyright (c) 2022
 * Andrey Mikhalevich, Katren ltd.
 */
function ProfessionList_Form(options){
	options = options || {};	
	
	options.formName = "ProfessionList";
	options.controller = "Profession_Controller";
	options.method = "get_list";
	
	ProfessionList_Form.superclass.constructor.call(this,options);
		
}
extend(ProfessionList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

