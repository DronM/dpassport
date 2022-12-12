/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/Controller_js20.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 
 * @class
 * @classdesc controller
 
 * @extends ControllerObjClient
  
 * @requires core/extend.js
 * @requires core/ControllerObjClient.js
  
 * @param {Object} options
 * @param {Model} options.listModelClass
 * @param {Model} options.objModelClass
 */ 

function Constant_study_document_register_fields_Controller(options){
	options = options || {};
	options.listModelClass = Constant_study_document_register_fields_Model;
	options.objModelClass = Constant_study_document_register_fields_Model;
	Constant_study_document_register_fields_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(Constant_study_document_register_fields_Controller,ControllerObjClient);

			Constant_study_document_register_fields_Controller.prototype.addInsert = function(){
	Constant_study_document_register_fields_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("descr",options);
	
	pm.addField(field);
	
	
}

			Constant_study_document_register_fields_Controller.prototype.addUpdate = function(){
	Constant_study_document_register_fields_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	field = new FieldString("old_name",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("descr",options);
	
	pm.addField(field);
	
	
}

			Constant_study_document_register_fields_Controller.prototype.addDelete = function(){
	Constant_study_document_register_fields_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldString("name",options));
}

			Constant_study_document_register_fields_Controller.prototype.addGetList = function(){
	Constant_study_document_register_fields_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("descr",f_opts));
}

			Constant_study_document_register_fields_Controller.prototype.addGetObject = function(){
	Constant_study_document_register_fields_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldString("name",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		