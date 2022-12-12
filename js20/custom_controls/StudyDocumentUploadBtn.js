/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends Button
 * @requires core/extend.js
 * @requires controls/Button.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function StudyDocumentUploadBtn(id,options){
	options = options || {};	
		
	if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
		options.caption = " Загрузить документы из Excel ";
	}
	else{
		options.className = "btn btn-default";
	}

	this.m_controllerId = options.controllerId;

	options.glyph = "glyphicon-upload";
	options.title="Загрузить документы из файла Excel определенной структуры";
	options.caption = " Импорт из Excel ";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	this.m_refreshGrid = options.refreshGrid;
	
	this.m_cmd = options.cmd;
	
	StudyDocumentUploadBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(StudyDocumentUploadBtn, ButtonCmd);

/* Constants */


/* private members */

/* protected*/

/* public methods */
StudyDocumentUploadBtn.prototype.onClick = function(){
	//Открыть модальную форму DocumentUpload_View
	var self = this;
	this.m_form = new WindowFormModalBS("StudyDocumentUpload",{
		"contentHead": "Загрузка документов из файла Excel",
		"dialogWidth": "98%",
		"content": new DocumentUpload_View("StudyDocumentUpload:view",{"controllerId": this.m_controllerId}),
		"controlOk": false,
		"cmdCancel":true,
		"onClickCancel":function(){
			self.m_refreshGrid();
			self.m_form.close();
		}
	});
	this.m_form.toDOM(document.body);
	
}
