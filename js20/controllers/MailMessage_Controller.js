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

function MailMessage_Controller(options){
	options = options || {};
	options.listModelClass = MailMessageList_Model;
	options.objModelClass = MailMessageList_Model;
	MailMessage_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
		
}
extend(MailMessage_Controller,ControllerObjServer);

			MailMessage_Controller.prototype.addInsert = function(){
	MailMessage_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTime("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("from_addr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("from_name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("to_addr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("to_name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("reply_addr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("reply_name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("body",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("sender_addr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("subject",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("sent",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTime("sent_date_time",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'person_register,password_recover,admin_1_register,client_activation,client_registration,client_expiration,person_url,user_activation,client_order';
	var field = new FieldEnum("mail_type",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("error_str",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			MailMessage_Controller.prototype.addUpdate = function(){
	MailMessage_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTime("date_time",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("from_addr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("from_name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("to_addr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("to_name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("reply_addr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("reply_name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("body",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("sender_addr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("subject",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("sent",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTime("sent_date_time",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'person_register,password_recover,admin_1_register,client_activation,client_registration,client_expiration,person_url,user_activation,client_order';
	
	var field = new FieldEnum("mail_type",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("error_str",options);
	
	pm.addField(field);
	
	
}

			MailMessage_Controller.prototype.addDelete = function(){
	MailMessage_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			MailMessage_Controller.prototype.addGetList = function(){
	MailMessage_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldDateTime("date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("from_addr",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("from_name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("to_addr",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("to_name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("reply_addr",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("reply_name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("body_begin",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("sender_addr",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("subject",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("sent",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTime("sent_date_time",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldEnum("mail_type",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("error_str",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("attachment_count",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("date_time");
	
}

			MailMessage_Controller.prototype.addGetObject = function(){
	MailMessage_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

		