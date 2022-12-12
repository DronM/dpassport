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

function ObjectModLog_Model(options){
	var id = 'ObjectModLog_Model';
	options = options || {};
	
	options.fields = {};
	
			
				
				
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = true;	
	
	options.fields.id = new FieldInt("id",filed_options);
							
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Вид объекта';
	filed_options.autoInc = false;	
	
	options.fields.object_type = new FieldEnum("object_type",filed_options);
	filed_options.enumValues = 'users,study_document_types,client_accesses,clients,study_document_registers,study_documents,study_document_attachments';
	options.fields.object_type.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Идентификатор объекта';
	filed_options.autoInc = false;	
	
	options.fields.object_id = new FieldInt("object_id",filed_options);
	options.fields.object_id.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Представление объекта';
	filed_options.autoInc = false;	
	
	options.fields.object_descr = new FieldText("object_descr",filed_options);
	options.fields.object_descr.getValidator().setRequired(true);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Пользователь';
	filed_options.autoInc = false;	
	
	options.fields.user_descr = new FieldText("user_descr",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Дата';
	filed_options.autoInc = false;	
	
	options.fields.date_time = new FieldDateTimeTZ("date_time",filed_options);
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Действие';
	filed_options.autoInc = false;	
	
	options.fields.action = new FieldEnum("action",filed_options);
	filed_options.enumValues = 'insert,update,delete';
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	filed_options.alias = 'Подробности';
	filed_options.autoInc = false;	
	
	options.fields.details = new FieldText("details",filed_options);
	
			
						
						
						
			
		ObjectModLog_Model.superclass.constructor.call(this,id,options);
}
extend(ObjectModLog_Model,ModelXML);

