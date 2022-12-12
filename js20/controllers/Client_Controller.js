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

function Client_Controller(options){
	options = options || {};
	options.listModelClass = ClientList_Model;
	options.objModelClass = ClientDialog_Model;
	//options.ws = true;
	Client_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.addComplete();
	this.add_check_for_register();
	this.add_update_attrs();
	this.add_select_company();
	this.add_set_viewed();
		
}
extend(Client_Controller,ControllerObjServer);

			Client_Controller.prototype.addInsert = function(){
	Client_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;
	var field = new FieldText("name",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;
	var field = new FieldString("inn",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Полное наименование";
	var field = new FieldText("name_full",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Адрес юридический";
	var field = new FieldText("legal_address",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Адрес почтовый";
	var field = new FieldText("post_address",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "КПП";
	var field = new FieldString("kpp",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("ogrn",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("okpo",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("okved",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("email",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("tel",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Площадка";
	var field = new FieldInt("parent_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("viewed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Для отбора по client_admin2";
	var field = new FieldInt("create_user_id",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			Client_Controller.prototype.addUpdate = function(){
	Client_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	//pm.setWS(true);
	
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
	
	var field = new FieldString("inn",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Полное наименование";
	var field = new FieldText("name_full",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Адрес юридический";
	var field = new FieldText("legal_address",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Адрес почтовый";
	var field = new FieldText("post_address",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "КПП";
	var field = new FieldString("kpp",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("ogrn",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("okpo",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("okved",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("email",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("tel",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Площадка";
	var field = new FieldInt("parent_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("viewed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Для отбора по client_admin2";
	var field = new FieldInt("create_user_id",options);
	
	pm.addField(field);
	
	
}

			Client_Controller.prototype.addDelete = function(){
	Client_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	//pm.setWS(true);
	var options = {"required":true};	
		
	pm.addField(new FieldInt("id",options));
}

			Client_Controller.prototype.addGetList = function(){
	Client_Controller.superclass.addGetList.call(this);
	
	
	
	var pm = this.getGetList();
	pm.setWS(true);
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
	
	pm.addField(new FieldBool("viewed",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("active",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("inn",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("ogrn",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("parent_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("parents_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("last_update",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("last_update_user",f_opts));
	var f_opts = {};
	f_opts.alias = "Для отбора по client_admin2";
	pm.addField(new FieldInt("create_user_id",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("viewed,active,name");
	
}

			Client_Controller.prototype.addGetObject = function(){
	Client_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			Client_Controller.prototype.addComplete = function(){
	Client_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldText("name",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("name");	
}

			Client_Controller.prototype.add_check_for_register = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('check_for_register',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "12";
	
		pm.addField(new FieldString("inn",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "10";
	
		pm.addField(new FieldString("captcha_key",options));
	
			
	this.addPublicMethod(pm);
}
			
			Client_Controller.prototype.add_update_attrs = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('update_attrs',opts);
	
				
	
	var options = {};
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("name",options));
	
				
	
	var options = {};
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("name_full",options));
	
				
	
	var options = {};
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("legal_address",options));
	
				
	
	var options = {};
	
		options.maxlength = "1000";
	
		pm.addField(new FieldString("post_address",options));
	
				
	
	var options = {};
	
		options.alias = "КПП";
	
		options.maxlength = "10";
	
		pm.addField(new FieldString("kpp",options));
	
				
	
	var options = {};
	
		options.maxlength = "15";
	
		pm.addField(new FieldString("ogrn",options));
	
				
	
	var options = {};
	
		options.maxlength = "20";
	
		pm.addField(new FieldString("okpo",options));
	
				
	
	var options = {};
	
		options.maxlength = "500";
	
		pm.addField(new FieldString("okved",options));
					
			
	this.addPublicMethod(pm);
}
			
			Client_Controller.prototype.add_select_company = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('select_company',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("parent_id",options));
	
			
	this.addPublicMethod(pm);
}
			
			Client_Controller.prototype.add_set_viewed = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('set_viewed',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("client_id",options));
	
			
	this.addPublicMethod(pm);
}
					
Client_Controller.prototype.getWS = function(){
	return false;
}
