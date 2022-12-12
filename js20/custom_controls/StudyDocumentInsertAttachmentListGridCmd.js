/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>,2022

 * @class
 * @classdesc
 
 * @requires core/extend.js  
 * @requires controls/GridCmd.js

 * @param {string} id Object identifier
 * @param {namespace} options
*/
function StudyDocumentInsertAttachmentListGridCmd(id,options){
	options = options || {};	

	options.showCmdControl = (options.showCmdControl!=undefined)? options.showCmdControl:true;
	
	var self = this;
	this.m_btn = new StudyDocumentInsertAttachmentBtn(id+"btn",{
		"grid": options.grid,
		//"cmd":true,//????
		"getHeadId": options.getHeadId
	});
	
	options.controls = [
		this.m_btn
	]
	
	StudyDocumentInsertAttachmentListGridCmd.superclass.constructor.call(this,id,options);
		
}
extend(StudyDocumentInsertAttachmentListGridCmd, GridCmd);

/* Constants */


/* private members */

/* protected*/

StudyDocumentInsertAttachmentListGridCmd.prototype.setGrid = function(v){
	this.m_grid = v;
	this.m_btn.m_grid = v;
}

