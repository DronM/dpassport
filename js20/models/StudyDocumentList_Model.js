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

function StudyDocumentList_Model(options){
	var id = 'StudyDocumentList_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
				
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = false;	
	
	options.fields.id = new FieldInt("id",filed_options);
	
				
	
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
	
	filed_options.autoInc = false;	
	
	options.fields.client_id = new FieldInt("client_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.clients_ref = new FieldJSON("clients_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.study_document_register_id = new FieldInt("study_document_register_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.study_document_registers_ref = new FieldJSON("study_document_registers_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.user_id = new FieldInt("user_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.users_ref = new FieldJSON("users_ref",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.snils = new FieldString("snils",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.issue_date = new FieldDate("issue_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '???????? ??????????????????';
	filed_options.autoInc = false;	
	
	options.fields.end_date = new FieldDate("end_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????????????????????? ??????????????????';
	filed_options.autoInc = false;	
	
	options.fields.post = new FieldText("post",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????????? ????????????';
	filed_options.autoInc = false;	
	
	options.fields.work_place = new FieldText("work_place",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????????????????????? ??????????????????????';
	filed_options.autoInc = false;	
	
	options.fields.organization = new FieldText("organization",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????? ????????????????';
	filed_options.autoInc = false;	
	
	options.fields.study_type = new FieldText("study_type",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????????? ??????????????????';
	filed_options.autoInc = false;	
	
	options.fields.series = new FieldString("series",filed_options);
	options.fields.series.getValidator().setMaxLength('50');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????????? ??????????????????';
	filed_options.autoInc = false;	
	
	options.fields.number = new FieldString("number",filed_options);
	options.fields.number.getValidator().setMaxLength('50');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '???????????????????????? ?????????????????? ????????.????????????????';
	filed_options.autoInc = false;	
	
	options.fields.study_prog_name = new FieldText("study_prog_name",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '???????????????????????? ?????????????????? (?????? ???????????????????? ??????????????)';
	filed_options.autoInc = false;	
	
	options.fields.profession = new FieldText("profession",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????????????????????????????? ?????????? ??????????????????';
	filed_options.autoInc = false;	
	
	options.fields.reg_number = new FieldText("reg_number",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '???????? ????????????????';
	filed_options.autoInc = false;	
	
	options.fields.study_period = new FieldText("study_period",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????? ??????????????';
	filed_options.autoInc = false;	
	
	options.fields.name_first = new FieldText("name_first",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????????????? ??????????????';
	filed_options.autoInc = false;	
	
	options.fields.name_second = new FieldText("name_second",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '???????????????? ??????????????';
	filed_options.autoInc = false;	
	
	options.fields.name_middle = new FieldText("name_middle",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '???????????????????????? ????????????????????????';
	filed_options.autoInc = false;	
	
	options.fields.qualification_name = new FieldText("qualification_name",filed_options);
				
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????????? ????????????????';
	filed_options.autoInc = false;	
	
	options.fields.study_form = new FieldText("study_form",filed_options);
				
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.create_type = new FieldString("create_type",filed_options);
							
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '??????';
	filed_options.autoInc = false;	
	
	options.fields.digital_sig = new FieldJSONB("digital_sig",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.self_descr = new FieldString("self_descr",filed_options);
						
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.last_update = new FieldDateTimeTZ("last_update",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.last_update_user = new FieldString("last_update_user",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.overdue = new FieldBool("overdue",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.month_left = new FieldBool("month_left",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '??????????????';
	filed_options.autoInc = false;	
	
	options.fields.name_full = new FieldText("name_full",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = '?????? ???????????? ???? client_admin2';
	filed_options.autoInc = false;	
	
	options.fields.create_user_id = new FieldInt("create_user_id",filed_options);
	
			
		StudyDocumentList_Model.superclass.constructor.call(this,id,options);
}
extend(StudyDocumentList_Model,ModelXML);

