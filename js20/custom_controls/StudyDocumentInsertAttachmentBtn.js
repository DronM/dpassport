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
function StudyDocumentInsertAttachmentBtn(id,options){
	options = options || {};	
		
	/*if(options.cmd){
		options.colorClass = "bg-"+window.getApp().getColorClass();//"bg-blue-400";
		options.className = "btn "+options.colorClass+" btn-cmd";
		options.caption = " Загрузить сертификаты из файлов ";
	}
	else{
		options.className = "btn btn-default";
		options.caption = " Загрузить сертификаты из файлов ";
	}*/

	this.m_grid = options.grid;
	this.m_getHeadId = options.getHeadId;

	this.m_controllerId = options.controllerId;

	options.glyph = "glyphicon-upload";
	options.title="Загрузить сертификаты из файлов";
	options.className = "btn btn-default";
	options.caption = " Загрузить сертификаты из файлов ";

	var self = this;
	options.onClick = function(){
		self.onClick();
	}
	
	var constants = {"allowed_attachment_extesions":null};
	window.getApp().getConstantManager().get(constants);
	this.m_allowedFileExtList = constants.allowed_attachment_extesions.getValue().split(",");
	
	this.m_cmd = options.cmd;
	
	StudyDocumentInsertAttachmentBtn.superclass.constructor.call(this,id,options);
}
//ViewObjectAjx,ViewAjxList
extend(StudyDocumentInsertAttachmentBtn, ButtonCmd);

/* Constants */


/* private members */

/* protected*/

/* public methods */
StudyDocumentInsertAttachmentBtn.prototype.uploadFiles = function(files){
	var files_info = [];
	for(var i=0; i< files.length; i++){
		if(this.m_allowedFileExtList){
			var ext_ar = files[i].name.split(".");
			if(!ext_ar.length || ext_ar.length<2){
				throw new Error("Файла: "+files[i].name+" "+EditFile.prototype.ER_EXT_NOT_DEFINED);
			}
			if(CommonHelper.inArray(ext_ar[ext_ar.length-1].toLowerCase(),this.m_allowedFileExtList)==-1){
				throw new Error("Файла: "+files[i].name+" "+CommonHelper.format(EditFile.prototype.ER_EXT_NOT_ALLOWED,ext_ar[ext_ar.length-1]));
			}
		}
		files_info.push({"id": CommonHelper.uniqid(), "name": files[i].name, "size": 0});
	}
	
	var pm = (new StudyDocumentInsertAttachment_Controller).getPublicMethod("add_files");
	
	pm.setFieldValue("study_document_insert_head_id", this.m_getHeadId());
	pm.setFieldValue("content_data", files);
	pm.setFieldValue("content_info", CommonHelper.serialize(files_info));//
	window.setGlobalWait(true);
	this.setEnabled(false);
	var self = this;
	pm.run({
		"ok":function(){
			self.m_grid.onRefresh();
			window.showTempNote("Сканы сертификатов загружены", null, 3000);
		},
		"all":function(){
			window.setGlobalWait(false);
			self.setEnabled(true);
		}
	});
	
}

StudyDocumentInsertAttachmentBtn.prototype.onClick = function(){
	var self = this;
	var fl = $('<input type="file" multiple="multiple"/>');
	fl.change(function(e) { 
		self.uploadFiles(e.target.files)
	});
	fl.click();
}
