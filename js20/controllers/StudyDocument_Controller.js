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

function StudyDocument_Controller(options){
	options = options || {};
	options.listModelClass = StudyDocumentList_Model;
	options.objModelClass = StudyDocumentDialog_Model;
	StudyDocument_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.add_batch_update();
	this.add_batch_delete();
	this.addDelete();
	this.addGetList();
	this.add_get_with_pict_list();
	this.addGetObject();
	this.addComplete();
	this.add_get_preview();
	this.add_analyze_excel();
	this.add_get_analyze_count();
	this.add_upload_excel();
	this.add_get_excel_template();
	this.add_save_field_order();
	this.add_get_excel_error();
		
}
extend(StudyDocument_Controller,ControllerObjServer);

			StudyDocument_Controller.prototype.addInsert = function(){
	StudyDocument_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Площадка";
	var field = new FieldInt("company_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Реестр";
	var field = new FieldInt("study_document_register_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пользователь";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "СНИЛС";options.required = true;
	var field = new FieldString("snils",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата выдачи";
	var field = new FieldDate("issue_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата окончания";
	var field = new FieldDate("end_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Аттестуемая должность";
	var field = new FieldText("post",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Место работы";
	var field = new FieldText("work_place",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Аттестуемая организация";
	var field = new FieldText("organization",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вид обучения";
	var field = new FieldText("study_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Серия документа";
	var field = new FieldText("series",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер документа";
	var field = new FieldText("number",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование программы проф.обучения";
	var field = new FieldText("study_prog_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование профессии (для заполнения ФИСФРДО)";
	var field = new FieldText("profession",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Регистрационный номер документа";
	var field = new FieldText("reg_number",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Срок обучения";
	var field = new FieldText("study_period",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Имя физлица";
	var field = new FieldText("name_first",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Фамилия физлица";
	var field = new FieldText("name_second",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Отчество физлица";
	var field = new FieldText("name_middle",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование квалификации";
	var field = new FieldText("qualification_name",options);
	
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
	options.alias = "ФИО для индекса, заполняется триггером";
	var field = new FieldText("name_full",options);
	
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

			StudyDocument_Controller.prototype.addUpdate = function(){
	StudyDocument_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Площадка";
	var field = new FieldInt("company_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Реестр";
	var field = new FieldInt("study_document_register_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пользователь";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "СНИЛС";
	var field = new FieldString("snils",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата выдачи";
	var field = new FieldDate("issue_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата окончания";
	var field = new FieldDate("end_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Аттестуемая должность";
	var field = new FieldText("post",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Место работы";
	var field = new FieldText("work_place",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Аттестуемая организация";
	var field = new FieldText("organization",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вид обучения";
	var field = new FieldText("study_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Серия документа";
	var field = new FieldText("series",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер документа";
	var field = new FieldText("number",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование программы проф.обучения";
	var field = new FieldText("study_prog_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование профессии (для заполнения ФИСФРДО)";
	var field = new FieldText("profession",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Регистрационный номер документа";
	var field = new FieldText("reg_number",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Срок обучения";
	var field = new FieldText("study_period",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Имя физлица";
	var field = new FieldText("name_first",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Фамилия физлица";
	var field = new FieldText("name_second",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Отчество физлица";
	var field = new FieldText("name_middle",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование квалификации";
	var field = new FieldText("qualification_name",options);
	
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
	options.alias = "ФИО для индекса, заполняется триггером";
	var field = new FieldText("name_full",options);
	
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

			StudyDocument_Controller.prototype.add_batch_update = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('batch_update',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		pm.addField(new FieldJSON("objects",options));
	
			
	this.addPublicMethod(pm);
}

			StudyDocument_Controller.prototype.add_batch_delete = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('batch_delete',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		pm.addField(new FieldJSON("keys",options));
	
			
	this.addPublicMethod(pm);
}
			
			StudyDocument_Controller.prototype.addDelete = function(){
	StudyDocument_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			StudyDocument_Controller.prototype.addGetList = function(){
	StudyDocument_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("company_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("companies_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("client_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("clients_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("study_document_register_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("study_document_registers_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("user_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("users_ref",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldString("snils",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldDate("issue_date",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата окончания";
	pm.addField(new FieldDate("end_date",f_opts));
	var f_opts = {};
	f_opts.alias = "Аттестуемая должность";
	pm.addField(new FieldText("post",f_opts));
	var f_opts = {};
	f_opts.alias = "Место работы";
	pm.addField(new FieldText("work_place",f_opts));
	var f_opts = {};
	f_opts.alias = "Аттестуемая организация";
	pm.addField(new FieldText("organization",f_opts));
	var f_opts = {};
	f_opts.alias = "Вид обучения";
	pm.addField(new FieldText("study_type",f_opts));
	var f_opts = {};
	f_opts.alias = "Серия документа";
	pm.addField(new FieldString("series",f_opts));
	var f_opts = {};
	f_opts.alias = "Номер документа";
	pm.addField(new FieldString("number",f_opts));
	var f_opts = {};
	f_opts.alias = "Наименование программы проф.обучения";
	pm.addField(new FieldText("study_prog_name",f_opts));
	var f_opts = {};
	f_opts.alias = "Наименование профессии (для заполнения ФИСФРДО)";
	pm.addField(new FieldText("profession",f_opts));
	var f_opts = {};
	f_opts.alias = "Регистрационный номер документа";
	pm.addField(new FieldText("reg_number",f_opts));
	var f_opts = {};
	f_opts.alias = "Срок обучения";
	pm.addField(new FieldText("study_period",f_opts));
	var f_opts = {};
	f_opts.alias = "Имя физлица";
	pm.addField(new FieldText("name_first",f_opts));
	var f_opts = {};
	f_opts.alias = "Фамилия физлица";
	pm.addField(new FieldText("name_second",f_opts));
	var f_opts = {};
	f_opts.alias = "Отчество физлица";
	pm.addField(new FieldText("name_middle",f_opts));
	var f_opts = {};
	f_opts.alias = "Наименование квалификации";
	pm.addField(new FieldText("qualification_name",f_opts));
	var f_opts = {};
	f_opts.alias = "Форма обучения";
	pm.addField(new FieldText("study_form",f_opts));
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
	
	pm.addField(new FieldBool("overdue",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldBool("month_left",f_opts));
	var f_opts = {};
	f_opts.alias = "Физлицо";
	pm.addField(new FieldText("name_full",f_opts));
	var f_opts = {};
	f_opts.alias = "Для отбора по client_admin2";
	pm.addField(new FieldInt("create_user_id",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("issue_date");
	
}

			StudyDocument_Controller.prototype.add_get_with_pict_list = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_with_pict_list',opts);
	
				
	
	var options = {};
	
		pm.addField(new FieldString("cond_fields",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldString("cond_vals",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldString("cond_sgns",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldString("cond_ic",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("from",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldInt("count",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldString("ord_fields",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldString("ord_directs",options));
	
				
	
	var options = {};
	
		pm.addField(new FieldString("field_sep",options));
	
			
	this.addPublicMethod(pm);
}

			StudyDocument_Controller.prototype.addGetObject = function(){
	StudyDocument_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			StudyDocument_Controller.prototype.addComplete = function(){
	StudyDocument_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	f_opts.alias = "";
	var pm = this.getComplete();
	pm.addField(new FieldString("number",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("number");	
}

			StudyDocument_Controller.prototype.add_get_preview = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_preview',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("study_document_id",options));
	
			
	this.addPublicMethod(pm);
}

			StudyDocument_Controller.prototype.add_analyze_excel = function(){
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
			
			StudyDocument_Controller.prototype.add_get_analyze_count = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_analyze_count',opts);
	
			
	this.addPublicMethod(pm);
}
			
			StudyDocument_Controller.prototype.add_upload_excel = function(){
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
			
			StudyDocument_Controller.prototype.add_get_excel_template = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_excel_template',opts);
	
	this.addPublicMethod(pm);
}

			StudyDocument_Controller.prototype.add_save_field_order = function(){
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
			
			StudyDocument_Controller.prototype.add_get_excel_error = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('get_excel_error',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "32";
	
		pm.addField(new FieldString("operation_id",options));
							
			
	this.addPublicMethod(pm);
}
			
			
		