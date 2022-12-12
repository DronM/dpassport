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

function StudyDocumentRegister_Controller(options){
	options = options || {};
	options.listModelClass = StudyDocumentRegisterList_Model;
	options.objModelClass = StudyDocumentRegisterDialog_Model;
	StudyDocumentRegister_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_batch_update();
	this.add_batch_delete();
	this.addComplete();
	this.add_analyze_excel();
	this.add_get_analyze_count();
	this.add_upload_excel();
	this.add_get_excel_template();
	this.add_save_field_order();
	this.add_get_excel_error();
		
}
extend(StudyDocumentRegister_Controller,ControllerObjServer);

			StudyDocumentRegister_Controller.prototype.addInsert = function(){
	StudyDocumentRegister_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDate("issue_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Площадка";
	var field = new FieldInt("company_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вид создания";	
	options.enumValues = 'manual,upload,api';
	var field = new FieldEnum("create_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "ПЭП";
	var field = new FieldJSONB("digital_sig",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Для отбора по client_admin2";
	var field = new FieldInt("create_user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Форма обучения";
	var field = new FieldText("study_form",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			StudyDocumentRegister_Controller.prototype.addUpdate = function(){
	StudyDocumentRegister_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата";
	var field = new FieldDate("issue_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Площадка";
	var field = new FieldInt("company_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вид создания";	
	options.enumValues = 'manual,upload,api';
	
	var field = new FieldEnum("create_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "ПЭП";
	var field = new FieldJSONB("digital_sig",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Для отбора по client_admin2";
	var field = new FieldInt("create_user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Форма обучения";
	var field = new FieldText("study_form",options);
	
	pm.addField(field);
	
	
}

			StudyDocumentRegister_Controller.prototype.addDelete = function(){
	StudyDocumentRegister_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			StudyDocumentRegister_Controller.prototype.addGetList = function(){
	StudyDocumentRegister_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("name",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата";
	pm.addField(new FieldDate("issue_date",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("company_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("companies_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("client_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("clients_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("create_type",f_opts));
	var f_opts = {};
	f_opts.alias = "ПЭП";
	pm.addField(new FieldJSONB("digital_sig",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("self_descr",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("last_update",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("last_update_user",f_opts));
	var f_opts = {};
	f_opts.alias = "Для отбора по client_admin2";
	pm.addField(new FieldInt("create_user_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("study_document_count",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("organization",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("study_form",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("issue_date");
	
}

			StudyDocumentRegister_Controller.prototype.addGetObject = function(){
	StudyDocumentRegister_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			StudyDocumentRegister_Controller.prototype.add_batch_update = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('batch_update',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		pm.addField(new FieldJSON("objects",options));
	
			
	this.addPublicMethod(pm);
}
	
			StudyDocumentRegister_Controller.prototype.add_batch_delete = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('batch_delete',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		pm.addField(new FieldJSON("keys",options));
	
			
	this.addPublicMethod(pm);
}
			
			StudyDocumentRegister_Controller.prototype.addComplete = function(){
	StudyDocumentRegister_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldString("name",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("name");	
}

			StudyDocumentRegister_Controller.prototype.add_analyze_excel = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('analyze_excel',opts);
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("analyze_count",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldText("content_data",options));
	
			
	this.addPublicMethod(pm);
}
			
			StudyDocumentRegister_Controller.prototype.add_get_analyze_count = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_analyze_count',opts);
	
			
	this.addPublicMethod(pm);
}
			
			StudyDocumentRegister_Controller.prototype.add_upload_excel = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('upload_excel',opts);
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("analyze_count",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("field_order",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldText("content_data",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("company_id",options));
	
			
	this.addPublicMethod(pm);
}
	
			StudyDocumentRegister_Controller.prototype.add_get_excel_template = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_excel_template',opts);
	
	this.addPublicMethod(pm);
}
		
			StudyDocumentRegister_Controller.prototype.add_save_field_order = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('save_field_order',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("analyze_count",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "3000";
	
		pm.addField(new FieldString("field_order",options));
	
			
	this.addPublicMethod(pm);
}
			
			StudyDocumentRegister_Controller.prototype.add_get_excel_error = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_excel_error',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "32";
	
		pm.addField(new FieldString("operation_id",options));
							
			
	this.addPublicMethod(pm);
}
			
			
		