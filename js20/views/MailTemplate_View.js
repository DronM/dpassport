/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2017

 * @extends ViewObjectAjx
 * @requires js20/core/extend.js
 * @requires js20/controls/ViewObjectAjx.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function MailTemplate_View(id,options){	

	options = options || {};
	
	options.cmdSave = false;
	options.model = (options && options.models && options.models.MailTemplate_Model)? options.models.MailTemplate_Model : new MailTemplate_Model();
	options.controller = options.controller || new MailTemplate_Controller();
	
	var self = this;
	
	var is_admin = (window.getApp().getServVar("role_id")=="admin");
	
	options.addElement = function(){
		this.addElement(new Enum_mail_types(id+":mail_type",{			
			"labelCaption":"Тип письма:",
			"enabled":is_admin,
			"required":true
		}));	
	
		this.addElement(new EditText(id+":template",{
			"labelCaption":"Шаблон:",
			"required":true,
			"focus":true
		}));	

		this.addElement(new EditText(id+":comment_text",{
			"labelCaption": "Комментарий:",
			"required":true,
			"enabled":is_admin
		}));	

		this.addElement(new EditString(id+":mes_subject",{
			"labelCaption":"Тема:",
			"enabled":is_admin,
			"required":true,
			"maxLength":250
		}));	

		//********* fields grid ***********************
		var model = new ReportTemplateField_Model();
	
		this.addElement(new GridAjx(id+":fields",{
			"model":model,
			"keyIds":["id"],
			"controller":new ReportTemplateField_Controller({"clientModel":model}),
			"editInline":true,
			"editWinClass":null,
			"popUpMenu":new PopUpMenu(),
			"commands":new GridCmdContainerAjx(id+":fields:cmd",{
				"cmdSearch":false,
				"cmdExport":false
			}),
			"head":new GridHead(id+":fields:head",{
				"elements":[
					new GridRow(id+":fields:head:row0",{
						"elements":[
							new GridCellHead(id+":fields:head:id",{
								"value":"Идентификатор",
								"columns":[
									new GridColumn({
										"field":model.getField("id"),
										"ctrlClass":EditString,
										"maxLength":"50",
										"ctrlOptions":{
											"required":true
										}
																										
									})
								]
							}),					
							new GridCellHead(id+":fields:head:descr",{
								"value":"Описание",
								"columns":[
									new GridColumn({
										"field":model.getField("descr"),
										"ctrlClass":EditString,
										"maxLength":"250",
										"ctrlOptions":{
											"required":true
										}
																										
									})
								]
							})				
						]
					})
				]
			}),
			"pagination":null,				
			"autoRefresh":false,
			"refreshInterval":0,
			"rowSelect":true,
			"focus":true		
		}));
	}
	
	MailTemplate_View.superclass.constructor.call(this,id,options);
	
	
	//****************************************************	
	
	//read
	var read_b = [
		new DataBinding({"control":this.getElement("mail_type"),"fieldId":"mail_type"})
		,new DataBinding({"control":this.getElement("template")})
		,new DataBinding({"control":this.getElement("comment_text")})
		,new DataBinding({"control":this.getElement("mes_subject")})
		,new DataBinding({"control":this.getElement("fields"),"fieldId":"fields"})
	];
	this.setDataBindings(read_b);
	
	//write
	var write_b = [
		new CommandBinding({"control":this.getElement("mail_type"),"fieldId":"mail_type"})
		,new CommandBinding({"control":this.getElement("template")})
		,new CommandBinding({"control":this.getElement("comment_text")})
		,new CommandBinding({"control":this.getElement("mes_subject")})
		,new CommandBinding({"control":this.getElement("fields"),"fieldId":"fields"})
	];
	this.setWriteBindings(write_b);
	
}
extend(MailTemplate_View,ViewObjectAjx);

