/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_js20.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 
 * @class
 * @classdesc controller
 
 * @extends ControllerObjServer
  
 * @requires core/extend.js
 * @requires core/ControllerObjServer.js
  
 * @param {Object} options
 * @param {Model} options.listModelClass
 * @param {Model} options.objModelClass
 */ 

function StudyDocumentAttachment_Controller(options){
	options = options || {};
	options.listModelClass = StudyDocumentAttachmentList_Model;
	options.objModelClass = StudyDocumentAttachmentList_Model;
	StudyDocumentAttachment_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.addGetObject();
	this.add_delete_file();
	this.add_get_file();
	this.add_add_file();
		
}
extend(StudyDocumentAttachment_Controller,ControllerObjServer);

			StudyDocumentAttachment_Controller.prototype.addGetList = function(){
	StudyDocumentAttachment_Controller.superclass.addGetList.call(this);
	
	
	
	var pm = this.getGetList();
	
	pm.addField(new FieldInt(this.PARAM_COUNT));
	pm.addField(new FieldInt(this.PARAM_FROM));
	pm.addField(new FieldString(this.PARAM_COND_FIELDS));
	pm.addField(new FieldString(this.PARAM_COND_SGNS));
	pm.addField(new FieldString(this.PARAM_COND_VALS));
	pm.addField(new FieldString(this.PARAM_COND_ICASE));
	pm.addField(new FieldString(this.PARAM_ORD_FIELDS));
	pm.addField(new FieldString(this.PARAM_ORD_DIRECTS));
	pm.addField(new FieldString(this.PARAM_FIELD_SEP));
	pm.addField(new FieldString(this.PARAM_FIELD_LSN));

	var f_opts = {};
	
	pm.addField(new FieldInt("id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("study_documents_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSONB("content_info",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("content_preview",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("date_time");
	
}

			StudyDocumentAttachment_Controller.prototype.addGetObject = function(){
	StudyDocumentAttachment_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			StudyDocumentAttachment_Controller.prototype.add_delete_file = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('delete_file',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("study_documents_ref",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("content_id",options));
	
			
	this.addPublicMethod(pm);
}

			StudyDocumentAttachment_Controller.prototype.add_get_file = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_file',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("study_documents_ref",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "36";
	
		pm.addField(new FieldString("content_id",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("inline",options));
	
			
	this.addPublicMethod(pm);
}

			StudyDocumentAttachment_Controller.prototype.add_add_file = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('add_file',opts);
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldString("study_documents_ref",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldText("content_data",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("content_info",options));
	
			
	this.addPublicMethod(pm);
}
			
		