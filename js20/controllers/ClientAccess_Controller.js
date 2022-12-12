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

function ClientAccess_Controller(options){
	options = options || {};
	options.listModelClass = ClientAccessList_Model;
	options.objModelClass = ClientAccessList_Model;
	ClientAccess_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.add_make_order();
	this.add_get_order_print();
		
}
extend(ClientAccess_Controller,ControllerObjServer);

			ClientAccess_Controller.prototype.addInsert = function(){
	ClientAccess_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Площадка";
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата начала действия";
	var field = new FieldDateTimeTZ("date_from",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата окончания действия";
	var field = new FieldDateTimeTZ("date_to",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Ссылка на документ 1с";
	var field = new FieldJSONB("doc_1c_ref",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			ClientAccess_Controller.prototype.addUpdate = function(){
	ClientAccess_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Площадка";
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата начала действия";
	var field = new FieldDateTimeTZ("date_from",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата окончания действия";
	var field = new FieldDateTimeTZ("date_to",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Ссылка на документ 1с";
	var field = new FieldJSONB("doc_1c_ref",options);
	
	pm.addField(field);
	
	
}

			ClientAccess_Controller.prototype.addDelete = function(){
	ClientAccess_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			ClientAccess_Controller.prototype.addGetList = function(){
	ClientAccess_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldJSON("clients_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("client_id",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата начала действия";
	pm.addField(new FieldDateTimeTZ("date_from",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата окончания действия";
	pm.addField(new FieldDateTimeTZ("date_to",f_opts));
	var f_opts = {};
	f_opts.alias = "Данные 1с";
	pm.addField(new FieldJSONB("doc_1c_ref",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("date_to");
	
}

			ClientAccess_Controller.prototype.addGetObject = function(){
	ClientAccess_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			ClientAccess_Controller.prototype.add_make_order = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('make_order',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("client_access_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "36";
	
		pm.addField(new FieldString("q_id",options));
	
			
	this.addPublicMethod(pm);
}
					
			ClientAccess_Controller.prototype.add_get_order_print = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_order_print',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("client_access_id",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "36";
	
		pm.addField(new FieldString("q_id",options));
	
			
	this.addPublicMethod(pm);
}
								
		