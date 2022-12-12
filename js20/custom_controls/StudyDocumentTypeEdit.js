/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function StudyDocumentTypeEdit(id,options){
	options = options || {};
	options.model = new StudyDocumentType_Model();
	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Вид документа:";
	}
	
	options.keyIds = options.keyIds || ["id"];
	options.modelKeyFields = [options.model.getField("id")];
	options.modelDescrFields = [options.model.getField("name")];
	
	options.readPublicMethod = (new StudyDocumentType_Controller()).getPublicMethod("get_list");
	
	StudyDocumentTypeEdit.superclass.constructor.call(this,id,options);
	
}
extend(StudyDocumentTypeEdit,EditSelectRef);

