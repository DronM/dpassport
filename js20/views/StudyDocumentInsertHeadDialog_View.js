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
	
	options.HEAD_TITLE = "Черновик";
	options.cmdSave = false;
	options.model = (options.models&&options.models.StudyDocumentInsertHeadList_Model)? options.models.StudyDocumentInsertHeadList_Model : new StudyDocumentInsertHeadList_Model();
	options.controller = options.controller || new StudyDocumentInsertHead_Controller();
	
	var app = window.getApp();
	var adm = app.clientEditAccess();
	var role = app.getServVar("role_id");
	var is_admin = (role=="admin");
	
	constants = {"allowed_attachment_extesions":null};
	window.getApp().getConstantManager().get(constants);
	
	options.model.getNextRow();
	
	var self = this;
	options.addElement = function(){
		this.addElement(new ClientEdit(id+":companies_ref",{
			"labelCaption":"*Компания:",
			"title":"Аттестующая организация, обязательное для заполнения поле.",
			"cmdInsert": true,
			"cmdOpen": false,
			"onSelect":function(){
				var v = this.getValue();
				if(v && !v.isNull()){
					self.getElement("common_work_place").setValue(v.getDescr());
				}
			}
		}));	
		
		//Register
		this.addElement(new EditDateInlineValidation(id+":register_date",{
			"labelCaption": "Дата:",
			"events":{
				"input":function(){
					var v = this.getValue();
					if(!isNaN(v)){
						self.getElement("common_issue_date").setValue(v);
					}
				}
			},
			"value":DateHelper.time()
		}));	
		this.addElement(new EditString(id+":register_name",{
			"labelCaption": "Наименование:",
			"placeholder": "Наименование протокола",
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
		this.addElement(new StudyDocumentInsertList_View(id+":document_list",{
			"headView": this,
			"commonIds":["issue_date","end_date","post","work_place","organization","study_type", "series",
				"study_prog_name", "profession", "study_period", "qualification_name", "study_form"]
		}));	

		//Attachments
		this.addElement(new StudyDocumentInsertAttachmentList_View(id+":attachment_list",{
			"headView": this,
			"headId": options.model.getFieldValue("id")
		}));	

		//Submit
		this.addElement(new ButtonCmd(id+":submit",{
			"caption":"Завершить",
			"title":"Создать документы (Протокол, Сертификаты) вместо черновика",
			"onClick":function(){
				self.onSubmit();
			}
		}));	

		//Common
		this.addElement(new EditDateInlineValidation(id+":common_issue_date",{
			"labelCaption": "Дата выдачи:"
		}));			
		this.addElement(new EditDateInlineValidation(id+":common_end_date",{
			"labelCaption": "Дата окончания:"
		}));			
		this.addElement(new EditString(id+":common_post",{
			"labelCaption": "Должность:",
			"maxLength":"500"
		}));			
		this.addElement(new ClientEditStr(id+":common_work_place",{
			"labelCaption": "Место работы:"
		}));			
		this.addElement(new ClientEditStr(id+":common_organization",{
			"labelCaption": "Аттестующая организация:",
			"value": app.getServVar("company_descr"),
			"visible": is_admin
		}));			
		this.addElement(new StudyTypeEdit(id+":common_study_type"));			
		
		this.addElement(new EditString(id+":common_series",{
			"labelCaption": "Серия:"
		}));			
		this.addElement(new EditString(id+":common_study_prog_name",{
			"labelCaption": "Программа обучения:"
		}));			
		this.addElement(new ProfessionEdit(id+":common_profession"));			
		
		this.addElement(new EditNum(id+":common_study_period",{
			"labelCaption": "Период (часов):",
			"title": "Период обучения, часов"
		}));			
		this.addElement(new QualificationEdit(id+":common_qualification_name"));
		this.addElement(new StudyFormEdit(id+":common_study_form"));						
		
	}
	
	StudyDocumentInsertHeadDialog_View.superclass.constructor.call(this, id, options);
	
	this.m_attachManager = new AttachmentManager({
		"view": this,
		"dataType": "study_document_insert_heads",
		"attachmentViewName": "register_attachment"
	});
	
	//****************************************************	
	
	//read
	var read_b = [
		new DataBinding({"control":this.getElement("register_date")})
		,new DataBinding({"control":this.getElement("register_name")})
		,new DataBinding({"control":this.getElement("companies_ref")})
		,new DataBinding({"control":this.getElement("register_attachment")})
		//common
		,new DataBinding({"control":this.getElement("common_issue_date")})
		,new DataBinding({"control":this.getElement("common_end_date")})
		,new DataBinding({"control":this.getElement("common_post")})
		,new DataBinding({"control":this.getElement("common_work_place")})
		,new DataBinding({"control":this.getElement("common_organization")})
		,new DataBinding({"control":this.getElement("common_study_type")})
		,new DataBinding({"control":this.getElement("common_series")})
		,new DataBinding({"control":this.getElement("common_study_prog_name")})
		,new DataBinding({"control":this.getElement("common_profession")})
		,new DataBinding({"control":this.getElement("common_study_period")})
		,new DataBinding({"control":this.getElement("common_qualification_name")})
		,new DataBinding({"control":this.getElement("common_study_form")})
	];
	this.setDataBindings(read_b);
	
	//write
	var write_b = [
		new CommandBinding({"control":this.getElement("register_date")})
		,new CommandBinding({"control":this.getElement("register_name")})
		,new CommandBinding({"control":this.getElement("companies_ref"), "fieldId":"company_id"})
		//common
		,new CommandBinding({"control":this.getElement("common_issue_date")})
		,new CommandBinding({"control":this.getElement("common_end_date")})
		,new CommandBinding({"control":this.getElement("common_post")})
		,new CommandBinding({"control":this.getElement("common_work_place"),"fieldId":"common_work_place"})
		,new CommandBinding({"control":this.getElement("common_organization"),"fieldId":"common_organization"})
		//insert problem id = null
		,new CommandBinding({"control":this.getElement("common_study_type"),"fieldId":"common_study_type"})
		,new CommandBinding({"control":this.getElement("common_series")})
		,new CommandBinding({"control":this.getElement("common_study_prog_name")})
		,new CommandBinding({"control":this.getElement("common_profession"),"fieldId":"common_profession"})
		,new CommandBinding({"control":this.getElement("common_study_period")})
		,new CommandBinding({"control":this.getElement("common_qualification_name"),"fieldId":"common_qualification_name"})
		,new CommandBinding({"control":this.getElement("common_study_form"),"fieldId":"common_study_form"})
	];
	this.setWriteBindings(write_b);	

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

	
}
extend(StudyDocumentInsertHeadDialog_View, ViewObjectAjx);

StudyDocumentInsertHeadDialog_View.prototype.SAVE_INT_DELAY = 5000;
StudyDocumentInsertHeadDialog_View.prototype.m_saveInt;

StudyDocumentInsertHeadDialog_View.prototype.getModified = function(cmd){
	if(this.getCmd() == "insert"){
		//чтобы записать даже без изменений для вложения!!!
		return true;
	}
	
	return StudyDocumentInsertHeadDialog_View.superclass.getModified.call(this,(cmd)? cmd:this.CMD_OK);
}

StudyDocumentInsertHeadDialog_View.prototype.onSubmitCont = function(){
	var pm = (new StudyDocumentInsertHead_Controller()).getPublicMethod("close");
	pm.setFieldValue("study_document_insert_head_id", this.getElement("id").getValue());
	this.setEnabled(false);
	window.setGlobalWait(true);
	var self = this;
	pm.run({
		"ok":function(){
			self.close({"updated": true});
		}
		,"all":function(){
			self.setEnabled(true);
			window.setGlobalWait(false);
		}
	});
}

StudyDocumentInsertHeadDialog_View.prototype.onSubmit = function(){
	//Проверить количество сертов
	var self = this;
	if(this.m_saveInt){
		clearInterval(this.m_saveInt);
	}
	//checking
	var c = this.getElement("companies_ref").getValue();
	if(!c || c.isNull()){
		this.getElement("companies_ref").setNotValid("Не заполнено");
		throw new Error("Не задана компания");
	}
	this.saveAttrs(function(){
		WindowQuestion.show({
			"cancel": false,
			"text":"Будут созданы протокол и все сертификаты, продолжить?",
			"callBack":function(res){
				if(res == WindowQuestion.RES_YES){
					self.onSubmitCont();
				}
			}
		})		
	})
}
/*
StudyDocumentInsertHeadDialog_View.prototype.getId = function(callBack){
	var id = this.getElement("id").getValue();
	if(!id){
		var self = this;
		this.onSave(function(){
			callBack(self.getElement("id").getValue());
		});
	}else{
		callBack(id);
	}	
}
*/
//*****************
StudyDocumentInsertHeadDialog_View.prototype.saveAttrs = function(callBack){
	if(this.getModified()){
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

StudyDocumentInsertHeadDialog_View.prototype.onGetData = function(resp,cmd){
	StudyDocumentInsertHeadDialog_View.superclass.onGetData.call(this, resp, cmd);
	if(cmd=="insert"||cmd=="copy"){
		DOMHelper.show(this.getId()+":protocol_help_t");
		DOMHelper.show(this.getId()+":cert_help_t");
		DOMHelper.show(this.getId()+":scan_help_t");
	}else{
		this.commonFieldsToggle(document.getElementById(this.getId()+":cmdCommonFieldsToggle"));
	}
}

StudyDocumentInsertHeadDialog_View.prototype.toDOM = function(p){
	StudyDocumentInsertHeadDialog_View.superclass.toDOM.call(this, p);
	
	var self = this;
	var l = DOMHelper.getElementsByAttr("tab", this.getNode(), "data-toggle", false, "A");

	if(l && l.length){
		for(var i = 0; i < l.length; i++)
			EventHelper.add(l[i], "click", function(e){
				if(self.getModified()){
					self.onSave();	
				}
				if(e.target.getAttribute("href")=="#attachments"){
					self.getElement("attachment_list").getElement("grid").onRefresh();
				}
			});
	}
	   $('.panel [data-action=collapse]').click(function (e) {
		e.preventDefault();
		self.commonFieldsToggle(this);
	    });	
}
StudyDocumentInsertHeadDialog_View.prototype.commonFieldsToggle = function(panel){
	var $panelCollapse = $(panel).parent().parent().parent().parent().nextAll();
	$(panel).parents('.panel').toggleClass('panel-collapsed');
	$(panel).toggleClass('rotate-180');

	//containerHeight(); // recalculate page height
	var availableHeight = $(window).height() - $('.page-container').offset().top - $('.navbar-fixed-bottom').outerHeight();

	$('.page-container').attr('style', 'min-height:' + availableHeight + 'px');
	$panelCollapse.slideToggle(150);
}


