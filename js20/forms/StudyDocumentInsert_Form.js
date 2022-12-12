/** Copyright (c) 2022
	Andrey Mikhalevich, Katren ltd.
*/
function StudyDocumentInsert_Form(options){
	options = options || {};	
	
	options.formName = "StudyDocumentInsertDialog";
	options.controller = "StudyDocumentInsert_Controller";
	options.method = "get_object";
	
	StudyDocumentInsert_Form.superclass.constructor.call(this,options);
	
}
extend(StudyDocumentInsert_Form, WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

