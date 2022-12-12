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

function Event_Controller(options){
	options = options || {};
	Event_Controller.superclass.constructor.call(this,options);	
	
	//methods
	this.add_subscribe();
	this.add_unsubscribe();
	this.add_publish();
		
}
extend(Event_Controller,ControllerObjServer);

			Event_Controller.prototype.add_subscribe = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('subscribe',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldArray("events",options));
	
			
	this.addPublicMethod(pm);
}

			Event_Controller.prototype.add_unsubscribe = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('unsubscribe',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldArray("events",options));
	
			
	this.addPublicMethod(pm);
}

			Event_Controller.prototype.add_publish = function(){
	var opts = {"controller":this};	
	var pm = new PublicMethodServer('publish',opts);
	
				
	
	var options = {};
	
		options.required = true;
	
		pm.addField(new FieldArray("events",options));
	
			
	this.addPublicMethod(pm);
}

		