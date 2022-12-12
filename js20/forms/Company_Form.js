/** Copyright (c) 2022
	Andrey Mikhalevich, Katren ltd.
*/
function Company_Form(options){
	options = options || {};	
	
	options.formName = "CompanyDialog";
	options.controller = "Company_Controller";
	options.method = "get_object";
	
	Company_Form.superclass.constructor.call(this,options);
	
}
extend(Company_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

