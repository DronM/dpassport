/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 */	
function ClientSelect(id,options){
	options = options || {};
	options.model = new ClientList_Model();
	options.autoRefresh = false;
	
	if (options.labelCaption!=""){
		options.labelCaption = options.labelCaption || "Компания:";
	}
	
	options.keyIds = options.keyIds || ["company_id"];
	options.modelKeyFields = [options.model.getField("id")];
	options.modelDescrFields = [options.model.getField("name")];
	
	options.readPublicMethod = (new Client_Controller()).getPublicMethod("select_company");
	if(options.parent_id){
		options.readPublicMethod.setFieldValue("parent_id", options.parent_id)
	}
	
	ClientSelect.superclass.constructor.call(this,id,options);
	
}
extend(ClientSelect,EditSelectRef);

ClientSelect.prototype.onRefresh = function(){	
	if(this.getReadPublicMethod().getFieldValue("parent_id")){
		ClientSelect.superclass.onRefresh.call(this);
	}
}
