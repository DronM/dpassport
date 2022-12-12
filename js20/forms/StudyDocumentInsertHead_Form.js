/** Copyright (c) 2022
	Andrey Mikhalevich, Katren ltd.
*/

function StudyDocumentInsertHead_Form(options){
	options = options || {};	
	
	options.formName = "StudyDocumentInsertHeadDialog";
	options.controller = "StudyDocumentInsertHead_Controller";
	options.method = "get_object";
	
	StudyDocumentInsertHead_Form.superclass.constructor.call(this,options);
	
}
extend(StudyDocumentInsertHead_Form,WindowFormObject);

/* Constants */


/* private members */

/* protected*/


/* public methods */

