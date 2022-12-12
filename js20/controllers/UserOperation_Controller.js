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

function UserOperation_Controller(options){
	options = options || {};
	options.objModelClass = UserOperationDialog_Model;
	UserOperation_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.addGetObject();
	this.addDelete();
		
}
extend(UserOperation_Controller,ControllerObjServer);

			UserOperation_Controller.prototype.addGetObject = function(){
	UserOperation_Controller.superclass.addGetObject.call(this);
	
	var pm = this.getGetObject();
	var f_opts = {};
		
	pm.addField(new FieldInt("user_id",f_opts));
	var f_opts = {};
		
	pm.addField(new FieldString("operation_id",f_opts));
	
	pm.addField(new FieldString("mode"));
	pm.addField(new FieldString("lsn"));
}

			UserOperation_Controller.prototype.addDelete = function(){
	UserOperation_Controller.superclass.addDelete.call(this);
	var pm = this.getDelete();
	var options = {"required":true};
		
	pm.addField(new FieldInt("user_id",options));
	var options = {"required":true};
		
	pm.addField(new FieldString("operation_id",options));
}

		