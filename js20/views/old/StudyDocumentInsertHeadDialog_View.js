/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 * @param {namespace} options.models All data models
 * @param {namespace} options.variantStorage {name,model}
 */	
function StudyDocumentInsertHeadDialog_View(id,options){	

	options = options || {};
	
	options.model = (options.models&&options.models.StudyDocumentInsertHeadList_Model)? options.models.StudyDocumentInsertHeadList_Model : new StudyDocumentInsertHeadList_Model();
	options.controller = options.controller || new StudyDocumentInsertHead_Controller();
	
	constants = {"allowed_attachment_extesions":null};
	window.getApp().getConstantManager().get(constants);
	
	var self = this;
	options.addElement = function(){
		this.addElement(new ClientEdit(id+":companies_ref",{
			"labelCaption":"Компания:",
			"cmdInsert": true
		}));	
		
		//Register
		this.addElement(new EditDate(id+":register_date",{
			"labelCaption": "Дата:"
		}));	
		this.addElement(new EditString(id+":register_name",{
			"labelCaption": "Наименование:",
			"maxLength":"1000"
		}));	

		this.addElement(new EditFile(id+":register_attachment",{
			"multipleFiles":false
			,"showHref":true
			,"showPic":true
			,"onDeleteFile": function(fileId,callBack){
				self.m_attachManager.deleteAttachment(fileId,callBack);
			}
			,"onFileAdded": function(fileId){
				self.m_attachManager.addAttachment(fileId);
			}
			,"onDownload": function(fileId){
				self.m_attachManager.downloadAttachment(fileId);
			}
			,"allowedFileExtList":constants.allowed_attachment_extesions.getValue().split(",")
		}));	
		
		
		//Documents
		this.addElement(new StudyDocumentInsertList_View(id+":document_list"));	

		//Documents
		this.addElement(new StudyDocumentInsertAttachmentList_View(id+":attachment_list",{
			"headView": this
		}));	
		
	}
	
	StudyDocumentInsertHeadDialog_View.superclass.constructor.call(this, id, options);
	
	this.m_attachManager = new AttachmentManager({
		"view": this,
		"dataType": "study_document_insert_heads",
		"attachmentViewName": "register_attachment"
	});

	this.addDetailDataSet({
		"control":this.getElement("document_list").getElement("grid"),
		"controlFieldId":"study_document_insert_head_id",
		"field": this.m_model.getField("id")
	});

	this.addDetailDataSet({
		"control":this.getElement("attachment_list").getElement("grid"),
		"controlFieldId":"study_document_insert_head_id",
		"field": this.m_model.getField("id")
	});
	
	//****************************************************	
	
	//read
	var read_b = [
		new DataBinding({"control":this.getElement("register_date")})
		,new DataBinding({"control":this.getElement("register_name")})
		,new DataBinding({"control":this.getElement("companies_ref")})
		,new DataBinding({"control":this.getElement("register_attachment")})
	];
	this.setDataBindings(read_b);
	
	//write
	var write_b = [
		new CommandBinding({"control":this.getElement("register_date")})
		,new CommandBinding({"control":this.getElement("register_name")})
		,new CommandBinding({"control":this.getElement("companies_ref"), "fieldId":"company_id"})
	];
	this.setWriteBindings(write_b);	
	
}
extend(StudyDocumentInsertHeadDialog_View, ViewObjectAjx);

StudyDocumentInsertHeadDialog_View.prototype.SAVE_INT_DELAY = 5000;
StudyDocumentInsertHeadDialog_View.prototype.m_saveInt;


StudyDocumentInsertHeadDialog_View.prototype.toDOM = function(p){	
	StudyDocumentInsertHeadDialog_View.superclass.toDOM.call(this, p)

	var self = this;
	$(".stepy-basic").stepy({
		backLabel: '<i class="icon-arrow-left13 position-left"></i> Предыдущая'
		/*,back: function(index) {
		    console.log('Returning to step: ' + index);
		}*/
		,next: function(index) {
			return self.onNextStep(index)
		}
		,nextLabel: 'Следующая <i class="icon-arrow-right14 position-right"></i>'
		,transition: 'fade'
		,finish: function(index) {
			self.onSubmit();
			return false; 
		}
		
	});
	
	$('.stepy-step').find('.button-next').addClass('btn btn-primary');
	$('.stepy-step').find('.button-back').addClass('btn btn-default');
	
	DOMHelper.show("StudyDocumentInsert");
	
	//this.startSaveAttrs();
}

StudyDocumentInsertHeadDialog_View.prototype.onSubmitCont = function(){
	var pm = (new StudyDocumentInsertHead_Controller()).getPublicMethod("close");
	pm.setFieldValue("study_document_insert_head_id", this.getElement("id").getValue());
	this.setEnabled(false);
	window.setGlobalWait(true);
	var self = this;
	pm.run({
		"ok":function(){
			self.close({"updated": false});
		}
		,"all":function(){
			self.setEnabled(true);
			window.setGlobalWait(false);
		}
	});
}

StudyDocumentInsertHeadDialog_View.prototype.onSubmit = function(){
	//alert("onSubmit");
	//Проверить количество сертов
	var self = this;
	if(this.m_saveInt){
		clearInterval(this.m_saveInt);
	}
	this.saveAttrs(function(){
		self.onSubmitCont();
	})
}

StudyDocumentInsertHeadDialog_View.prototype.onNextStep = function(ind){
	//alert("onNextStep");
}

//*****************
StudyDocumentInsertHeadDialog_View.prototype.saveAttrs = function(callBack){
console.log("saveAttrs")
	if(this.getModified()){
		console.log("calling onSave()")
		this.onSave(callBack);				
		
	}else if (callBack){
		callBack();
	}
}

StudyDocumentInsertHeadDialog_View.prototype.startSaveAttrs = function(){
	if(this.m_saveInt){
		clearInterval(this.m_saveInt);
	}
	var self = this;
	this.m_saveInt = setInterval(function(){
		self.saveAttrs();
	}, this.SAVE_INT_DELAY)
}

