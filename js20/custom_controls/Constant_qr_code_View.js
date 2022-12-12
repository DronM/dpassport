/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends EditJSON
 * @requires core/extend.js
 * @requires controls/EditJSON.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function Constant_qr_code_View(id,options){

	options = options || {};
	
	options.className = options.className || "form-group";
	
	var self = this;

	options.addElement = function(){
		var id = this.getId();

		this.addElement(new EditString(id+":url",{
			"maxLength":"200",
			"labelCaption":"URL ссылки QR кода:"
		}));
		this.addElement(new EditNum(id+":size",{
			"labelCaption":"Размер:",
			"title":"Размер картинки в пикселах, например, 256"
		}));
		this.addElement(new EditNum(id+":recovery_level",{
			"labelCaption":"Уровень обнаружения ошибок (0-3):",
			"title":"0 - 7% error recovery, 1 - 15% error recovery, 2- 25% error recovery, 3- 30% error recovery"
		}));

	}	
	Constant_qr_code_View.superclass.constructor.call(this,id,options);
	
}
extend(Constant_qr_code_View, EditJSON);

/* Constants */


/* private members */

/* protected*/


/* public methods */

