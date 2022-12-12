/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2022

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function StudyDocumentUploadGridCmd(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	var self = this;
	this.m_btn = new StudyDocumentUploadBtn(id+"btn",{
		"controllerId": options.controllerId,
		"refreshGrid": function(){
			self.getGrid().onRefresh();			
		}
	});
	
	options.controls = [
		this.m_btn
	]
	
	StudyDocumentUploadGridCmd.superclass.constructor.call(this,id,options);
		
}
extend(StudyDocumentUploadGridCmd, GridCmd);

/* Constants */


/* private members */

/* protected*/


