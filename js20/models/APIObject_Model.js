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

function APIObject_Model(options){
	var id = 'APIObject_Model';
	options = options || {};
	
	options.fields = {};
	
				
	
	var filed_options = {};
	filed_options.primaryKey = true;	
	
	filed_options.autoInc = false;	
	
	options.fields.uuid = new FieldString("uuid",filed_options);
	options.fields.uuid.getValidator().setRequired(true);
	options.fields.uuid.getValidator().setMaxLength('32');
	
				
	
	var filed_options = {};
	filed_options.primaryKey = false;	
	
	filed_options.autoInc = false;	
	
	options.fields.obj = new FieldJSON("obj",filed_options);
	options.fields.obj.getValidator().setRequired(true);
	
		APIObject_Model.superclass.constructor.call(this,id,options);
}
extend(APIObject_Model,ModelXML);

