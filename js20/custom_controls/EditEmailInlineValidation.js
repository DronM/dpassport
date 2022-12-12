/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends EditEmail
 * @requires core/extend.js
 * @requires controls/EditEmail.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function EditEmailInlineValidation(id,options){
	options = options || {};	
	
	options.required = (options.required==undefined)? options.required : true;
	options.labelCaption = options.labelCaption || "Электронная почта:";
	options.placeholder = options.placeholder || "Электронная почта";
	options.events = options.events || {
		"focus":function(){
			this.setValid();
		}
		,"blur": function(){
		
			var v = this.getValue();
			if(v && v.length){
				if(!this.m_reg){
					this.m_reg = new RegExp(/\S+@\S+\.\S+/)
				}
				if(!this.m_reg.test(v)){
					this.setNotValid("Неверный формат");
				}else{
					this.setValid();
				}
			}else{
				this.setValid();
			}
		}
	};
	
	EditEmailInlineValidation.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(EditEmailInlineValidation, EditEmail);

/* Constants */


/* private members */

/* protected*/


/* public methods */

