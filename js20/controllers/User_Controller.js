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

function User_Controller(options){
	options = options || {};
	options.listModelClass = UserList_Model;
	options.objModelClass = UserDialog_Model;
	User_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.addComplete();
	this.add_get_profile();
	this.add_reset_pwd();
	this.add_login();
	this.add_login_refresh();
	this.add_logout();
	this.add_logout_html();
	this.add_download_photo();
	this.add_delete_photo();
	this.add_password_recover();
	this.add_register();
	this.add_set_viewed();
	this.add_gen_qrcode();
	this.add_send_qrcode_email();
		
}
extend(User_Controller,ControllerObjServer);

			User_Controller.prototype.addInsert = function(){
	User_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Email";
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("name_full",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("post",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'male,female';
	var field = new FieldEnum("sex",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("birthdate",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("snils",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBytea("photo",options);
	
	pm.addField(field);
	
	var options = {};
	options.required = true;	
	options.enumValues = 'admin,client_admin1,client_admin2,person';
	var field = new FieldEnum("role_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldPassword("pwd",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("create_dt",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("banned",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("time_zone_locale_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("phone_cel",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'ru';
	var field = new FieldEnum("locale_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Адрес электр.почты подтвержден";
	var field = new FieldBool("email_confirmed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Поле убрать, тк есть компания, а площадка это родитель компании";
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Компания";
	var field = new FieldInt("company_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "URL личного кабинета";
	var field = new FieldString("person_url",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Представление пользователя, идексированное поле для полиска. Обновляется триггером";
	var field = new FieldText("descr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("viewed",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBytea("qr_code",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("qr_code_sent_date",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			User_Controller.prototype.addUpdate = function(){
	User_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	pm.setRequestType('post');
	
	pm.setEncType(ServConnector.prototype.ENCTYPES.MULTIPART);
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Email";
	var field = new FieldString("name",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("name_full",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldText("post",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'male,female';
	
	var field = new FieldEnum("sex",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDate("birthdate",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("snils",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBytea("photo",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'admin,client_admin1,client_admin2,person';
	options.enumValues+= (options.enumValues=='')? '':',';
	options.enumValues+= 'null';
	
	var field = new FieldEnum("role_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldPassword("pwd",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("create_dt",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("banned",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("time_zone_locale_id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldString("phone_cel",options);
	
	pm.addField(field);
	
	var options = {};
		
	options.enumValues = 'ru';
	
	var field = new FieldEnum("locale_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Адрес электр.почты подтвержден";
	var field = new FieldBool("email_confirmed",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Поле убрать, тк есть компания, а площадка это родитель компании";
	var field = new FieldInt("client_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Компания";
	var field = new FieldInt("company_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "URL личного кабинета";
	var field = new FieldString("person_url",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Представление пользователя, идексированное поле для полиска. Обновляется триггером";
	var field = new FieldText("descr",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBool("viewed",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldBytea("qr_code",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldDateTimeTZ("qr_code_sent_date",options);
	
	pm.addField(field);
	
	
}

			User_Controller.prototype.addDelete = function(){
	User_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			User_Controller.prototype.addGetList = function(){
	User_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldBool("viewed",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldText("name_full",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("snils",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("post",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("sex",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldEnum("role_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("phone_cel",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("tel_ext",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("clients_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("client_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("companies_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("company_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("person_url",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("descr",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("last_update",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("last_update_user",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDateTimeTZ("qr_code_sent_date",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("banned",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("viewed,name_full");
	
}

			User_Controller.prototype.addGetObject = function(){
	User_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
	f_opts.alias = "Код";	
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			User_Controller.prototype.addComplete = function(){
	User_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldString("descr",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("descr");	
}

			User_Controller.prototype.add_get_profile = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_profile',opts);
	
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_reset_pwd = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('reset_pwd',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("user_id",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login',opts);
	
				
	
	var options = {};
	
		options.alias = "Имя пользователя";
	
		options.required = true;
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("name",options));
	
				
	
	var options = {};
	
		options.alias = "Пароль";
	
		options.required = true;
	
		options.maxlength = "20";
	
		pm.addField(new FieldPassword("pwd",options));
	
				
	
	var options = {};
	
		options.maxlength = "2";
	
		pm.addField(new FieldString("width_type",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_login_refresh = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login_refresh',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("refresh_token",options));
	
			
	this.addPublicMethod(pm);
}
						
			User_Controller.prototype.add_logout = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('logout',opts);
	
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_logout_html = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('logout_html',opts);
	
	this.addPublicMethod(pm);
}
			
			User_Controller.prototype.add_download_photo = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('download_photo',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("user_id",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_delete_photo = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('delete_photo',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("user_id",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_password_recover = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('password_recover',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "100";
	
		pm.addField(new FieldString("email",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "10";
	
		pm.addField(new FieldString("captcha_key",options));
	
			
	this.addPublicMethod(pm);
}

			User_Controller.prototype.add_register = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('register',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "250";
	
		pm.addField(new FieldString("name",options));
	
				
	
	var options = {};
	
		options.maxlength = "250";
	
		pm.addField(new FieldText("name_full",options));
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("snils",options));
	
				
	
	var options = {};
	
		options.maxlength = "250";
	
		pm.addField(new FieldString("post",options));
	
				
	
	var options = {};
	
		options.maxlength = "50";
	
		pm.addField(new FieldString("sex",options));
	
				
	
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
	
			User_Controller.prototype.add_set_viewed = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('set_viewed',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("user_id",options));
	
			
	this.addPublicMethod(pm);
}
					
			User_Controller.prototype.add_gen_qrcode = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('gen_qrcode',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("user_id",options));
	
			
	this.addPublicMethod(pm);
}
					
			User_Controller.prototype.add_send_qrcode_email = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('send_qrcode_email',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("user_id",options));
	
			
	this.addPublicMethod(pm);
}
								
		