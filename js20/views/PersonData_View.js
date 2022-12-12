/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function PersonData_View(id,options){
	options = options || {};	
	
	var self = this;

console.log("options=", options)		
	options.addElement = function(){
	}
	
	PersonData_View.superclass.constructor.call(this, id, "DIV", options);
}
//ViewObjectAjx,ViewAjxList
extend(PersonData_View, ControlContainer);

/* Constants */


/* private members */

/* protected*/


/* public methods */

