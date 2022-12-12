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

function StudyDocumentInsertAttachment_Controller(options){
	options = options || {};
	options.listModelClass = StudyDocumentInsertAttachmentList_Model;
	StudyDocumentInsertAttachment_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetList();
	this.add_add_files();
		
}
extend(StudyDocumentInsertAttachment_Controller,ControllerObjServer);

			StudyDocumentInsertAttachment_Controller.prototype.addGetList = function(){
	StudyDocumentInsertAttachment_Controller.superclass.addGetList.call(this);
	
	
	
	var pm = this.getGetList();
	
	pm.addField(new FieldInt(this.PARAM_COUNT));
	pm.addField(new FieldInt(this.PARAM_FROM));
	pm.addField(new FieldString(this.PARAM_COND_FIELDS));
	pm.addField(new FieldString(this.PARAM_COND_SGNS));
	pm.addField(new FieldString(this.PARAM_COND_VALS));
	pm.addField(new FieldString(this.PARAM_COND_JOINS));
	pm.addField(new FieldString(this.PARAM_COND_ICASE));
	pm.addField(new FieldString(this.PARAM_ORD_FIELDS));
	pm.addField(new FieldString(this.PARAM_ORD_DIRECTS));
	pm.addField(new FieldString(this.PARAM_FIELD_SEP));
	pm.addField(new FieldString(this.PARAM_FIELD_LSN));
	pm.addField(new FieldString(this.PARAM_EXP_FNAME));

	var f_opts = {};
	
	pm.addField(new FieldInt("id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("user_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("study_document_insert_head_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Имя физлица";
	pm.addField(new FieldText("name_full",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("attachment",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("name_full");
	
}

			StudyDocumentInsertAttachment_Controller.prototype.add_add_files = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('add_files',opts);
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("study_document_insert_head_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldText("content_info",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldText("content_data",options));
	
			
	this.addPublicMethod(pm);
}
						
		