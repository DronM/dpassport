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

function MailTemplate_Controller(options){
	options = options || {};
	options.listModelClass = MailTemplateList_Model;
	options.objModelClass = MailTemplate_Model;
	MailTemplate_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addGetList();
	this.addGetObject();
		
}
extend(MailTemplate_Controller,ControllerObjServer);

			MailTemplate_Controller.prototype.addInsert = function(){
	MailTemplate_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Тип email";options.required = true;	
	options.enumValues = 'person_register,password_recover,admin_1_register,client_activation,client_registration,client_expiration,person_url,user_activation,client_order';
	var field = new FieldEnum("mail_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Шаблон";options.required = true;
	var field = new FieldText("template",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Комментарий";options.required = true;
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Тема";options.required = true;
	var field = new FieldText("mes_subject",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Поля";options.required = true;
	var field = new FieldJSON("fields",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			MailTemplate_Controller.prototype.addUpdate = function(){
	MailTemplate_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Тип email";	
	options.enumValues = 'person_register,password_recover,admin_1_register,client_activation,client_registration,client_expiration,person_url,user_activation,client_order';
	options.enumValues+= (options.enumValues=='')? '':',';
	options.enumValues+= 'null';
	
	var field = new FieldEnum("mail_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Шаблон";
	var field = new FieldText("template",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Комментарий";
	var field = new FieldText("comment_text",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Тема";
	var field = new FieldText("mes_subject",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Поля";
	var field = new FieldJSON("fields",options);
	
	pm.addField(field);
	
	
}

			MailTemplate_Controller.prototype.addGetList = function(){
	MailTemplate_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldString("mail_type",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("template",f_opts));
}

			MailTemplate_Controller.prototype.addGetObject = function(){
	MailTemplate_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		