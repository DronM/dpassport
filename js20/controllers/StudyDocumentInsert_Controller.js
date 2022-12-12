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

function StudyDocumentInsert_Controller(options){
	options = options || {};
	options.listModelClass = StudyDocumentInsertList_Model;
	options.objModelClass = StudyDocumentInsertList_Model;
	StudyDocumentInsert_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addInsert();
	this.addUpdate();
	this.addDelete();
	this.addGetList();
	this.addGetObject();
	this.addComplete();
	this.add_batch_update();
	this.add_batch_delete();
		
}
extend(StudyDocumentInsert_Controller,ControllerObjServer);

			StudyDocumentInsert_Controller.prototype.addInsert = function(){
	StudyDocumentInsert_Controller.superclass.addInsert.call(this);
	
	var pm = this.getInsert();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("study_document_insert_head_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "SNILS";
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
	var field = new FieldString("series",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер документа";
	var field = new FieldString("number",options);
	
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
	
	pm.addField(new FieldInt("ret_id",{}));
	
	
}

			StudyDocumentInsert_Controller.prototype.addUpdate = function(){
	StudyDocumentInsert_Controller.superclass.addUpdate.call(this);
	var pm = this.getUpdate();
	
	var options = {};
	options.primaryKey = true;options.autoInc = true;
	var field = new FieldInt("id",options);
	
	pm.addField(field);
	
	field = new FieldInt("old_id",{});
	pm.addField(field);
	
	var options = {};
	
	var field = new FieldInt("study_document_insert_head_id",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "SNILS";
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
	var field = new FieldString("series",options);
	
	pm.addField(field);
	
	var options = {};
	options.alias = "Номер документа";
	var field = new FieldString("number",options);
	
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
	
	
}

			StudyDocumentInsert_Controller.prototype.addDelete = function(){
	StudyDocumentInsert_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("id",options));
}

			StudyDocumentInsert_Controller.prototype.addGetList = function(){
	StudyDocumentInsert_Controller.superclass.addGetList.call(this);
	
	
	
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

	var f_opts = {};
	
	pm.addField(new FieldInt("id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("study_document_insert_head_id",f_opts));
	var f_opts = {};
	
	pm.addField(new FieldInt("user_id",f_opts));
	var f_opts = {};
	f_opts.alias = "SNILS";
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
	f_opts.alias = "ФИО";
	pm.addField(new FieldText("name_full",f_opts));
}

			StudyDocumentInsert_Controller.prototype.addGetObject = function(){
	StudyDocumentInsert_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			StudyDocumentInsert_Controller.prototype.addComplete = function(){
	StudyDocumentInsert_Controller.superclass.addComplete.call(this);
	
	var f_opts = {};
	
	var pm = this.getComplete();
	pm.addField(new FieldString("name_full",f_opts));
	pm.getField(this.PARAM_ORD_FIELDS).setValue("name_full");	
}

			StudyDocumentInsert_Controller.prototype.add_batch_update = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('batch_update',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		pm.addField(new FieldJSON("objects",options));
	
			
	this.addPublicMethod(pm);
}

			StudyDocumentInsert_Controller.prototype.add_batch_delete = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('batch_delete',opts);
	
	pm.setRequestType('post');
	
				
	
	var options = {};
	
		pm.addField(new FieldJSON("keys",options));
	
			
	this.addPublicMethod(pm);
}
			
		