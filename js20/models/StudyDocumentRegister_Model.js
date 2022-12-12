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

function StudyDocumentRegister_Model(options){
	var id = 'StudyDocumentRegister_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
				
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.name = new FieldText("name",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата';
	filed_options.autoInc = false;	
	
	options.fields.issue_date = new FieldDate("issue_date",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Площадка';
	filed_options.autoInc = false;	
	
	options.fields.company_id = new FieldInt("company_id",filed_options);
	
				
	
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
	filed_options.alias = 'Для отбора по client_admin2';
	filed_options.autoInc = false;	
	
	options.fields.create_user_id = new FieldInt("create_user_id",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Форма обучения';
	filed_options.autoInc = false;	
	
	options.fields.study_form = new FieldText("study_form",filed_options);
	
			
			
			
						
						
			
		StudyDocumentRegister_Model.superclass.constructor.call(this,id,options);
}
extend(StudyDocumentRegister_Model,ModelXML);

