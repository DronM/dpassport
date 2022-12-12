/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends ViewObjectAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function StudyDocumentDialog_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Сертификат";
	options.cmdSave = false;
	options.model = (options.models&&options.models.StudyDocumentDialog_Model)? options.models.StudyDocumentDialog_Model : new StudyDocumentDialog_Model();
	options.controller = options.controller || new StudyDocument_Controller();
	
	var self = this;
	var constants;
	
	var app =  window.getApp();
	var role_id = app.getServVar("role_id");
	var is_person = (is_person == "person");
	if(!is_person){
		constants = {"allowed_attachment_extesions":null};
		app.getConstantManager().get(constants);
	}	
	var is_admin = (role_id=="admin");
	
	options.templateOptions = options.templateOptions || {};
	options.templateOptions.USER_EDIT = is_admin;
	
	options.addElement = function(){
	
		this.addElement(new EditDateInlineValidation(id+":issue_date",{
			"labelCaption": "Дата выдачи",
			"cmdClear":false
		}));	
		this.addElement(new EditDateInlineValidation(id+":end_date",{
			"labelCaption": "Дата окончания",
			"cmdClear":false
		}));	

		this.addElement(new ClientEdit(id+":companies_ref",{
			"required": true,
			"value": is_admin? null : app.getCompanyRef(),
			"cmdInsert": (is_admin || role_id=="client_admin1"),
			"onSelect":function(){
				var v = this.getValue();
				if(v && !v.isNull()){
					self.getElement("work_place").setValue(v.getDescr());
				}
			},			
			"enabled":true
		}));	

		if(is_admin){
			this.addElement(new UserEditRef(id+":users_ref"));	
		}

		this.addElement(new StudyDocumentRegisterEdit(id+":study_document_registers_ref",{
			"cmdOpen": true
		}));	

		//person_data
		this.addElement(new Enum_doc_create_types(id+":create_type",{
			"required":false,
			"labelCaption":"Тип создания:",
			"value":"manual",
			"enabled":is_admin
		}));			
		this.addElement(new EditSNILS(id+":snils",{
			"required":false
		}));			
		
		this.addElement(new EditString(id+":series",{
			"required":false,
			"labelCaption":"Серия:",
			"maxLength":"50"
		}));			
		this.addElement(new EditString(id+":number",{
			"labelCaption": "Регистрационный номер:",
			"maxLength":50,
			"cmdClear":false,
			"maxLength":"50"
		}));	
		
		this.addElement(new EditString(id+":study_prog_name",{
			"required":false,
			"labelCaption":"Наименование программы:",
			"maxLength":"1000"
		}));		

		this.addElement(new EditNum(id+":study_period",{
			"required":false,
			"labelCaption":"Период обучения (часов):"
		}));		

		this.addElement(new EditString(id+":post",{
			"required":false,
			"labelCaption":"Аттестуемая должность:"
		}));		
		this.addElement(new ClientEditStr(id+":work_place",{
			"required":false,
			"labelCaption":"Место работы:",
			"value": is_admin? undefined : app.getServVar("company_descr"),
			"enabled":is_admin
		}));		
		this.addElement(new ClientEditStr(id+":organization",{
			"required":false,
			"labelCaption":"Аттестующая организация:",
			"value": is_admin? undefined : app.getServVar("company_descr"),
			"enabled":is_admin
		}));		
		
		this.addElement(new StudyTypeEdit(id+":study_type",{
			"required":false,
			"labelCaption":"Вид обучения:"
		}));		
		
		this.addElement(new ProfessionEdit(id+":profession",{
			"required":false,
			"labelCaption":"Наименование профессии (для заполнения ФИСФРДО):"
		}));
				
		this.addElement(new EditString(id+":reg_number",{
			"required":false,
			"labelCaption":"Регистрационный номер документа:"
		}));
				
		this.addElement(new QualificationEdit(id+":qualification_name",{
			"required":false,
			"labelCaption":"Наименование квалификации:"
		}));		
		
		this.addElement(new StudyFormEdit(id+":study_form",{
			"required":false
		}));		
		
		this.addElement(new NameEdit(id+":name_first",{
			"required":false,
			"labelCaption":"Имя:",
			"placeholder":"Имя",
			"title":"Имя физического лица"
		}));
				
		this.addElement(new NameEdit(id+":name_second",{
			"required":false,
			"labelCaption":"Фамилия:",
			"placeholder":"Фамилия",
			"title":"Фамилия физического лица",
			"events":{
				"paste":function(e){
					var names = window.getApp().splitNameOnPaste(e);
					if(names){
						if(names.length){
							self.getElement("name_first").setValue(names[0]);
						}
						if(names.length>=2){
							self.getElement("name_middle").setValue(names[0]);
						}
					}
				}
			}
		}));
				
		this.addElement(new NameEdit(id+":name_middle",{
			"required":false,
			"labelCaption":"Отчество:",
			"placeholder":"Отчество",
			"title":"Отчество физического лица"
		}));		
			
		//digital_sig ПЭП
		
		this.addElement(new EditFile(id+":attachments",{
			"multipleFiles":true
			,"showHref":true
			,"showPic":true
			,"onDeleteFile":is_person? null : function(fileId,callBack){
				self.m_attachManager.deleteAttachment(fileId,callBack);
			}
			,"onFileAdded":is_person? null : function(fileId){
				self.m_attachManager.addAttachment(fileId);
			}
			,"onDownload":is_person? null : function(fileId){
				self.m_attachManager.downloadAttachment(fileId);
			}
			,"allowedFileExtList":is_person? null : constants.allowed_attachment_extesions.getValue().split(",")
		}));	
		
		this.addElement(new ObjectModLog_View(id+":object_mod_log",{"detail":true}));
	}
	
	ClientDialog_View.superclass.constructor.call(this,id,options);
	
	this.m_attachManager = new AttachmentManager({"view": this, "dataType": "study_documents"});
	//****************************************************	
	
	//read
	var read_b = [
		new DataBinding({"control":this.getElement("snils")})
		,new DataBinding({"control":this.getElement("issue_date")})
		,new DataBinding({"control":this.getElement("end_date")})
		,new DataBinding({"control":this.getElement("companies_ref")})
		,new DataBinding({"control":this.getElement("study_document_registers_ref")})
		,new DataBinding({"control":this.getElement("create_type")})
		,new DataBinding({"control":this.getElement("series")})
		,new DataBinding({"control":this.getElement("number")})
		,new DataBinding({"control":this.getElement("study_prog_name")})
		,new DataBinding({"control":this.getElement("study_period")})
		,new DataBinding({"control":this.getElement("post")})
		,new DataBinding({"control":this.getElement("work_place")})
		,new DataBinding({"control":this.getElement("organization")})
		,new DataBinding({"control":this.getElement("study_type")})
		,new DataBinding({"control":this.getElement("profession")})
		,new DataBinding({"control":this.getElement("reg_number")})
		,new DataBinding({"control":this.getElement("qualification_name")})
		,new DataBinding({"control":this.getElement("study_form")})
		,new DataBinding({"control":this.getElement("name_first")})
		,new DataBinding({"control":this.getElement("name_second")})
		,new DataBinding({"control":this.getElement("name_middle")})
		//,new DataBinding({"control":this.getElement("digital_sig")})
		,new DataBinding({"control":this.getElement("attachments")})
	];
	if(is_admin){
		read_b.push(new DataBinding({"control":this.getElement("users_ref")}));
	}
	this.setDataBindings(read_b);
	
	//write
	var write_b = [
		new CommandBinding({"control":this.getElement("snils")})
		,new CommandBinding({"control":this.getElement("issue_date")})
		,new CommandBinding({"control":this.getElement("end_date")})
		,new CommandBinding({"control":this.getElement("companies_ref"), "fieldId":"company_id"})
		,new CommandBinding({"control":this.getElement("study_document_registers_ref"),"fieldId":"study_document_register_id"})
		,new CommandBinding({"control":this.getElement("create_type")})
		,new CommandBinding({"control":this.getElement("series")})
		,new CommandBinding({"control":this.getElement("number")})
		,new CommandBinding({"control":this.getElement("study_prog_name")})
		,new CommandBinding({"control":this.getElement("study_period")})
		,new CommandBinding({"control":this.getElement("post")})
		,new CommandBinding({"control":this.getElement("work_place"), "fieldId":"work_place"})
		,new CommandBinding({"control":this.getElement("organization"), "fieldId":"organization"})
		,new CommandBinding({"control":this.getElement("study_type"), "fieldId":"study_type"})
		,new CommandBinding({"control":this.getElement("profession"), "fieldId":"profession"})
		,new CommandBinding({"control":this.getElement("reg_number")})
		,new CommandBinding({"control":this.getElement("qualification_name"), "fieldId":"qualification_name"})
		,new CommandBinding({"control":this.getElement("study_form"), "fieldId":"study_form"})
		,new CommandBinding({"control":this.getElement("name_first")})
		,new CommandBinding({"control":this.getElement("name_second")})
		,new CommandBinding({"control":this.getElement("name_middle")})
	];
	if(is_admin){
		write_b.push(new CommandBinding({"control":this.getElement("users_ref"),"fieldId":"user_id"}));
	}	
	this.setWriteBindings(write_b);

	this.addDetailDataSet({
		"control":this.getElement("object_mod_log").getElement("grid"),
		"controlFieldId": ["object_type", "object_id"],
		"value": ["study_documents", function(){
			return self.m_model.getFieldValue("id");
		}]
	});
	
}
extend(StudyDocumentDialog_View, ViewObjectAjx);

//********************

