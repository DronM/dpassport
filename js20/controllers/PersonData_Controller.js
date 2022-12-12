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

function PersonData_Controller(options){
	options = options || {};
	PersonData_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_login();
		
}
extend(PersonData_Controller,ControllerObjServer);

			PersonData_Controller.prototype.add_login = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('login',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		options.maxlength = "32";
	
		pm.addField(new FieldString("url",options));
	
				
	
	var options = {};
	
		options.maxlength = "2";
	
		pm.addField(new FieldString("width_type",options));
	
			
	this.addPublicMethod(pm);
}

		