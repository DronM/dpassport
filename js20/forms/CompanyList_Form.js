/*
 * Copyright (c) 2022
 * Andrey Mikhalevich, Katren ltd.
 */
function CompanyList_Form(options){
	options = options || {};	
	
	options.formName = "CompanyList";
	options.controller = "Company_Controller";
	options.method = "get_list";
	
	CompanyList_Form.superclass.constructor.call(this,options);
		
}
extend(CompanyList_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

