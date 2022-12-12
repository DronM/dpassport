/** Copyright (c) 2022
	Andrey Mikhalevich, Katren ltd.
*/
function StudyDocument_Form(options){
	options = options || {};	
	
	options.formName = "StudyDocumentDialog";
	options.controller = "StudyDocument_Controller";
	options.method = "get_object";
	
	StudyDocument_Form.superclass.constructor.call(this,options);
	
}
extend(StudyDocument_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

