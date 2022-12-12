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
function Constant_study_document_fields_View(id,options){

	options = options || {};
	
	options.className = options.className || "form-group";
	
	var self = this;

	options.addElement = function(){
		var id = this.getId();

		this.addElement(new EditNum(id+":analyze_count",{
			"labelCaption":"Количество анализируемых строк по-умолчанию:"
		}));

		this.addElement(new Constant_study_document_fields_Grid(id+":rows",{
			"keyIds":["rows"]
			//""
		}));
	
	}	
	Constant_study_document_fields_View.superclass.constructor.call(this,id,options);
	
}
extend(Constant_study_document_fields_View, EditJSON);

/* Constants */


/* private members */

/* protected*/


/* public methods */

