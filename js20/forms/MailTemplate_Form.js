/** Copyright (c) 2017 
 *	Andrey Mikhalevich, Katren ltd.
 */
function MailTemplate_Form(options){
	options = options || {};	
	
	options.formName = "MailTemplate";
	options.controller = "MailTemplate_Controller";
	options.method = "get_object";
	
	MailTemplate_Form.superclass.constructor.call(this,options);
	
}
extend(MailTemplate_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

