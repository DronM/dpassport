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

function StudyDocumentInsertHeadList_Model(options){
	var id = 'StudyDocumentInsertHeadList_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
					
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
				
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.user_id = new FieldInt("user_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.company_id = new FieldInt("company_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.companies_ref = new FieldJSON("companies_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата протокола';
	filed_options.autoInc = false;	
	
	options.fields.register_date = new FieldDate("register_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Наименование протокола';
	filed_options.autoInc = false;	
	
	options.fields.register_name = new FieldText("register_name",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.register_attachment = new FieldJSON("register_attachment",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.study_document_count = new FieldInt("study_document_count",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата выдачи';
	filed_options.autoInc = false;	
	
	options.fields.common_issue_date = new FieldDate("common_issue_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата окончания';
	filed_options.autoInc = false;	
	
	options.fields.common_end_date = new FieldDate("common_end_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Аттестуемая должность';
	filed_options.autoInc = false;	
	
	options.fields.common_post = new FieldText("common_post",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Место работы';
	filed_options.autoInc = false;	
	
	options.fields.common_work_place = new FieldText("common_work_place",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Аттестуемая организация';
	filed_options.autoInc = false;	
	
	options.fields.common_organization = new FieldText("common_organization",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вид обучения';
	filed_options.autoInc = false;	
	
	options.fields.common_study_type = new FieldText("common_study_type",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Серия документа';
	filed_options.autoInc = false;	
	
	options.fields.common_series = new FieldText("common_series",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Наименование программы проф.обучения';
	filed_options.autoInc = false;	
	
	options.fields.common_study_prog_name = new FieldText("common_study_prog_name",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Наименование профессии (для заполнения ФИСФРДО)';
	filed_options.autoInc = false;	
	
	options.fields.common_profession = new FieldText("common_profession",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Срок обучения';
	filed_options.autoInc = false;	
	
	options.fields.common_study_period = new FieldText("common_study_period",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Наименование квалификации';
	filed_options.autoInc = false;	
	
	options.fields.common_qualification_name = new FieldText("common_qualification_name",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Форма обучения';
	filed_options.autoInc = false;	
	
	options.fields.common_study_form = new FieldText("common_study_form",filed_options);
	
						
		StudyDocumentInsertHeadList_Model.superclass.constructor.call(this,id,options);
}
extend(StudyDocumentInsertHeadList_Model,ModelXML);

