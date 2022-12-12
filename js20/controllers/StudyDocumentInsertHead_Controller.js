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

function StudyDocumentInsertHead_Controller(options){
	options = options || {};
	options.listModelClass = StudyDocumentInsertHeadList_Model;
	options.objModelClass = StudyDocumentInsertHeadList_Model;
	StudyDocumentInsertHead_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetObject();
	this.addGetList();
	this.add_close();
		
}
extend(StudyDocumentInsertHead_Controller,ControllerObjServer);

			StudyDocumentInsertHead_Controller.prototype.addInsert = function(){
	StudyDocumentInsertHead_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Пользователь";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Компания";
	var field = new FieldInt("company_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата протокола";
	var field = new FieldDate("register_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование протокола";
	var field = new FieldText("register_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата выдачи";
	var field = new FieldDate("common_issue_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата окончания";
	var field = new FieldDate("common_end_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Аттестуемая должность";
	var field = new FieldText("common_post",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Место работы";
	var field = new FieldText("common_work_place",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Аттестуемая организация";
	var field = new FieldText("common_organization",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вид обучения";
	var field = new FieldText("common_study_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Серия документа";
	var field = new FieldString("common_series",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование программы проф.обучения";
	var field = new FieldText("common_study_prog_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование профессии (для заполнения ФИСФРДО)";
	var field = new FieldText("common_profession",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Срок обучения";
	var field = new FieldText("common_study_period",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование квалификации";
	var field = new FieldText("common_qualification_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Форма обучения";
	var field = new FieldText("common_study_form",options);
	
	pm.addField(field);
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			StudyDocumentInsertHead_Controller.prototype.addUpdate = function(){
	StudyDocumentInsertHead_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	options.alias = "Пользователь";
	var field = new FieldInt("user_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Компания";
	var field = new FieldInt("company_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата протокола";
	var field = new FieldDate("register_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование протокола";
	var field = new FieldText("register_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата выдачи";
	var field = new FieldDate("common_issue_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Дата окончания";
	var field = new FieldDate("common_end_date",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Аттестуемая должность";
	var field = new FieldText("common_post",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Место работы";
	var field = new FieldText("common_work_place",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Аттестуемая организация";
	var field = new FieldText("common_organization",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Вид обучения";
	var field = new FieldText("common_study_type",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Серия документа";
	var field = new FieldString("common_series",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование программы проф.обучения";
	var field = new FieldText("common_study_prog_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование профессии (для заполнения ФИСФРДО)";
	var field = new FieldText("common_profession",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Срок обучения";
	var field = new FieldText("common_study_period",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Наименование квалификации";
	var field = new FieldText("common_qualification_name",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Форма обучения";
	var field = new FieldText("common_study_form",options);
	
	pm.addField(field);
	
	
}

			StudyDocumentInsertHead_Controller.prototype.addDelete = function(){
	StudyDocumentInsertHead_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			StudyDocumentInsertHead_Controller.prototype.addGetObject = function(){
	StudyDocumentInsertHead_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			StudyDocumentInsertHead_Controller.prototype.addGetList = function(){
	StudyDocumentInsertHead_Controller.superclass.addGetList.call(this);
	
	
	
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
	
	pm.addField(new FieldInt("company_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("companies_ref",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата протокола";
	pm.addField(new FieldDate("register_date",f_opts));
	var f_opts = {};
	f_opts.alias = "Наименование протокола";
	pm.addField(new FieldText("register_name",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldJSON("register_attachment",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("study_document_count",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата выдачи";
	pm.addField(new FieldDate("common_issue_date",f_opts));
	var f_opts = {};
	f_opts.alias = "Дата окончания";
	pm.addField(new FieldDate("common_end_date",f_opts));
	var f_opts = {};
	f_opts.alias = "Аттестуемая должность";
	pm.addField(new FieldText("common_post",f_opts));
	var f_opts = {};
	f_opts.alias = "Место работы";
	pm.addField(new FieldText("common_work_place",f_opts));
	var f_opts = {};
	f_opts.alias = "Аттестуемая организация";
	pm.addField(new FieldText("common_organization",f_opts));
	var f_opts = {};
	f_opts.alias = "Вид обучения";
	pm.addField(new FieldText("common_study_type",f_opts));
	var f_opts = {};
	f_opts.alias = "Серия документа";
	pm.addField(new FieldText("common_series",f_opts));
	var f_opts = {};
	f_opts.alias = "Наименование программы проф.обучения";
	pm.addField(new FieldText("common_study_prog_name",f_opts));
	var f_opts = {};
	f_opts.alias = "Наименование профессии (для заполнения ФИСФРДО)";
	pm.addField(new FieldText("common_profession",f_opts));
	var f_opts = {};
	f_opts.alias = "Срок обучения";
	pm.addField(new FieldText("common_study_period",f_opts));
	var f_opts = {};
	f_opts.alias = "Наименование квалификации";
	pm.addField(new FieldText("common_qualification_name",f_opts));
	var f_opts = {};
	f_opts.alias = "Форма обучения";
	pm.addField(new FieldText("common_study_form",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("register_date");
	
}

			StudyDocumentInsertHead_Controller.prototype.add_close = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('close',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldInt("study_document_insert_head_id",options));
	
			
	this.addPublicMethod(pm);
}
	
		