/**	
 *
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/models/Model_js.xsl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 *
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017
 * @class
 * @classdesc Model class. Created from template build/templates/models/Model_js.xsl. !!!DO NOT MODEFY!!!
 
 * @extends ModelXML
 
 * @requires core/extend.js
 * @requires core/ModelXML.js
 
 * @param {string} id 
 * @param {Object} options
 */

function StudyDocument_Model(options){
	var id = 'StudyDocument_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Площадка';
	filed_options.autoInc = false;	
	
	options.fields.company_id = new FieldInt("company_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Реестр';
	filed_options.autoInc = false;	
	
	options.fields.study_document_register_id = new FieldInt("study_document_register_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Пользователь';
	filed_options.autoInc = false;	
	
	options.fields.user_id = new FieldInt("user_id",filed_options);
				
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'СНИЛС';
	filed_options.autoInc = false;	
	
	options.fields.snils = new FieldString("snils",filed_options);
	options.fields.snils.getValidator().setRequired(true);
	options.fields.snils.getValidator().setMaxLength('11');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата выдачи';
	filed_options.autoInc = false;	
	
	options.fields.issue_date = new FieldDate("issue_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата окончания';
	filed_options.autoInc = false;	
	
	options.fields.end_date = new FieldDate("end_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Аттестуемая должность';
	filed_options.autoInc = false;	
	
	options.fields.post = new FieldText("post",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Место работы';
	filed_options.autoInc = false;	
	
	options.fields.work_place = new FieldText("work_place",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Аттестуемая организация';
	filed_options.autoInc = false;	
	
	options.fields.organization = new FieldText("organization",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вид обучения';
	filed_options.autoInc = false;	
	
	options.fields.study_type = new FieldText("study_type",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Серия документа';
	filed_options.autoInc = false;	
	
	options.fields.series = new FieldText("series",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Номер документа';
	filed_options.autoInc = false;	
	
	options.fields.number = new FieldText("number",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Наименование программы проф.обучения';
	filed_options.autoInc = false;	
	
	options.fields.study_prog_name = new FieldText("study_prog_name",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Наименование профессии (для заполнения ФИСФРДО)';
	filed_options.autoInc = false;	
	
	options.fields.profession = new FieldText("profession",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Регистрационный номер документа';
	filed_options.autoInc = false;	
	
	options.fields.reg_number = new FieldText("reg_number",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Срок обучения';
	filed_options.autoInc = false;	
	
	options.fields.study_period = new FieldText("study_period",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Имя физлица';
	filed_options.autoInc = false;	
	
	options.fields.name_first = new FieldText("name_first",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Фамилия физлица';
	filed_options.autoInc = false;	
	
	options.fields.name_second = new FieldText("name_second",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Отчество физлица';
	filed_options.autoInc = false;	
	
	options.fields.name_middle = new FieldText("name_middle",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Наименование квалификации';
	filed_options.autoInc = false;	
	
	options.fields.qualification_name = new FieldText("qualification_name",filed_options);
				
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вид создания';
	filed_options.autoInc = false;	
	
	options.fields.create_type = new FieldEnum("create_type",filed_options);
	filed_options.enumValues = 'manual,upload,api';
							
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'ПЭП';
	filed_options.autoInc = false;	
	
	options.fields.digital_sig = new FieldJSONB("digital_sig",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'ФИО для индекса, заполняется триггером';
	filed_options.autoInc = false;	
	
	options.fields.name_full = new FieldText("name_full",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Для отбора по client_admin2';
	filed_options.autoInc = false;	
	
	options.fields.create_user_id = new FieldInt("create_user_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Форма обучения';
	filed_options.autoInc = false;	
	
	options.fields.study_form = new FieldText("study_form",filed_options);
				
			
			
			
						
						
						
			
						
						
						
						
						
						
						
						
						
						
			
		StudyDocument_Model.superclass.constructor.call(this,id,options);
}
extend(StudyDocument_Model,ModelXML);

