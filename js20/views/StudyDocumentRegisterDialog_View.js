/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends ViewObjectAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function StudyDocumentRegisterDialog_View(id,options){	

	options = options || {};
	
	options.HEAD_TITLE = "Протокол";
	options.cmdSave = false;
	options.model = (options.models&&options.models.StudyDocumentRegisterDialog_Model)? options.models.StudyDocumentRegisterDialog_Model : new StudyDocumentRegisterDialog_Model();
	options.controller = options.controller || new StudyDocumentRegister_Controller();
	
	var self = this;
	
	var app =  window.getApp();
	var role_id = app.getServVar("role_id");
	var is_admin = (role_id=="admin");
	
	var constants = {"allowed_attachment_extesions":null};
	window.getApp().getConstantManager().get(constants);
	
	options.addElement = function(){
		this.addElement(new EditString(id+":name",{
			"labelCaption": "Наименование:",
			"maxLength":1000,
			"cmdClear":false,
			"enabled":true,
			"required":true
		}));	
	
		this.addElement(new EditDateInlineValidation(id+":issue_date",{
			"labelCaption": "Дата:",
			"cmdClear":false,
			"enabled":true,
			"required":true,
			"value":DateHelper.time()
		}));	

		this.addElement(new ClientEdit(id+":companies_ref",{
			"labelCaption":"Компания:",
			"value": is_admin? null : app.getCompanyRef(),
			"cmdInsert": (is_admin || role_id=="client_admin1"),
			"required":true			
		}));	

		this.addElement(new Enum_doc_create_types(id+":create_type",{
			"labelCaption":"Тип создания:",
			"value":"manual",
			"enabled":is_admin,
			"required":true
		}));			

		this.addElement(new StudyFormEdit(id+":study_form",{
		}));			
		
		this.addElement(new EditFile(id+":attachments",{
			"multipleFiles":true
			//,"labelCaption":"Схемы к заказу:"
			,"showHref":true
			,"showPic":true
			,"onDeleteFile":function(fileId,callBack){
				self.m_attachManager.deleteAttachment(fileId,callBack);
			}
			,"onFileAdded":function(fileId){
				self.m_attachManager.addAttachment(fileId);
			}
			,"onDownload":function(fileId){
				self.m_attachManager.downloadAttachment(fileId);
			}
			,"allowedFileExtList":constants.allowed_attachment_extesions.getValue().split(",")
		}));	
		
		this.addElement(new ObjectModLog_View(id+":object_mod_log",{
			"detail":true
		}));

		this.addElement(new StudyDocumentList_View(id+":cert_list",{
			"detail":true
		}));
		
	}
	
	ClientDialog_View.superclass.constructor.call(this,id,options);
	
	this.m_attachManager = new AttachmentManager({"view": this, "dataType": "study_document_registers"});
	
	//****************************************************	
	
	//read
	var read_b = [
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("issue_date")})
		,new DataBinding({"control":this.getElement("create_type")})
		,new DataBinding({"control":this.getElement("companies_ref")})
		,new DataBinding({"control":this.getElement("attachments")})
		,new DataBinding({"control":this.getElement("study_form")})
	];
	this.setDataBindings(read_b);
	
	//write
	var write_b = [
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("issue_date")})
		,new CommandBinding({"control":this.getElement("create_type")})
		,new CommandBinding({"control":this.getElement("companies_ref"),"fieldId":"company_id"})
		,new CommandBinding({"control":this.getElement("study_form"),"fieldId":"study_form"})
	];
	this.setWriteBindings(write_b);	

	this.addDetailDataSet({
		"control":this.getElement("object_mod_log").getElement("grid"),
		"controlFieldId": ["object_type", "object_id"],
		"value": ["study_document_registers", function(){
			return self.m_model.getFieldValue("id");
		}]
	});	

	this.addDetailDataSet({
		"control":this.getElement("cert_list").getElement("grid"),
		"controlFieldId": "study_document_register_id",
		"value": function(){
			return self.m_model.getFieldValue("id");
		}
	});	
		
}
extend(StudyDocumentRegisterDialog_View, ViewObjectAjx);

