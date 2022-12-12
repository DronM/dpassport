/* Copyright (c) 2016, 2021
 *	Andrey Mikhalevich, Katren ltd.
 */
function UserProfile_View(id,options){	

	options = options || {};
	
	options.cmdOkAsync = false;
	options.cmdOk = false;
	options.cmdCancel = false;
	
	options.templateOptions = options.templateOptions || {};
	options.templateOptions.COMPANY_DESCR = window.getApp().getServVar("company_descr");
	
	if(options.models&&options.models.UserProfile_Model&&options.models.UserProfile_Model.getNextRow()){
		options.templateOptions.QR = options.models.UserProfile_Model.getFieldValue("qr_code");
	}
	
	var self = this;
	options.addElement = function(){
		this.addElement(new EditEmail(id+":name",{
			"labelCaption":"email:",
			"events":{
				"keyup":function(){
					self.getControlSave().setEnabled(true);
				}
			}
			
		}));	

		this.addElement(new EditPassword(id+":pwd",{
			"labelCaption":"Пароль:",
			"events":{
				"keyup":function(){
					self.checkPass();	
				}
			}
		}));	
		this.addElement(new EditPassword(id+":pwd_confirm",{
			"labelCaption":"Подтверждение пароля:",
			"events":{
				"keyup":function(){
					self.checkPass();	
				}
			}
		}));	

		this.addElement(new EditString(id+":name_full",{
			"maxLength":"500",
			"labelCaption":"ФИО:",
			"events":{
				"keyup":function(){
					self.getControlSave().setEnabled(true);	
				}
			}
		}));
		this.addElement(new EditString(id+":post",{
			"maxLength":"500",
			"labelCaption":"Должность:",
			"events":{
				"keyup":function(){
					self.getControlSave().setEnabled(true);
				}
			}
		}));
		this.addElement(new EditPhone(id+":phone_cel",{
			"labelCaption":"Телефон:",
			"events":{
				"keyup":function(){
					self.getControlSave().setEnabled(true);
				}
			}
		}));
		
		this.addElement(new EditNum(id+":snils",{
			"maxLength":"11",
			"labelCaption":"СНИЛС:",
			"events":{
				"keyup":function(){
					self.getControlSave().setEnabled(true);
				}
			}
			
		}));

		/*this.addElement(new Enum_locales(id+":locale_id",{
			"labelCaption":"Локаль:",
			"required":true,
			"events":{
				"keyup":function(){
					self.getControlSave().setEnabled(true);	
				}
			}			
		}));*/

		this.addElement(new TimeZoneLocaleEdit(id+":time_zone_locales_ref",{
			"events":{
				"change":function(){
					self.getControlSave().setEnabled(true);	
				}
			}			
		}));
		
		this.addElement(new Enum_sexes(id+":sex",{
			"labelCaption":"Пол:",
			"events":{
				"change":function(){
					self.getControlSave().setEnabled(true);	
				}
			}			
			
		}));	
		
	}
	
	UserProfile_View.superclass.constructor.call(this,id,options);

	//****************************************************
	var contr = new User_Controller();
	
	//read
	this.setReadPublicMethod(contr.getPublicMethod("get_profile"));
	this.m_model = options.models.UserProfile_Model;
	
	//read
	this.setDataBindings([
		new DataBinding({"control":this.getElement("id")})
		,new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("phone_cel")})
		//,new DataBinding({"control":this.getElement("locale_id")})
		,new DataBinding({"control":this.getElement("time_zone_locales_ref")})
		,new DataBinding({"control":this.getElement("sex")})
		,new DataBinding({"control":this.getElement("name_full")})
		,new DataBinding({"control":this.getElement("post")})
		,new DataBinding({"control":this.getElement("snils")})
	]);

	//write
	this.setController(contr);
	this.getCommand(this.CMD_OK).setBindings([
		new CommandBinding({"control":this.getElement("id")})
		,new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("phone_cel")})
		//,new CommandBinding({"control":this.getElement("locale_id")})
		,new CommandBinding({"control":this.getElement("time_zone_locales_ref"),"fieldId":"time_zone_locale_id"})
		,new CommandBinding({"control":this.getElement("sex")})
		,new CommandBinding({"control":this.getElement("name_full")})
		,new CommandBinding({"control":this.getElement("post")})
		,new CommandBinding({"control":this.getElement("snils")})
	]);
	
	this.getControlSave().setEnabled(false);
}
extend(UserProfile_View,ViewObjectAjx);


UserProfile_View.prototype.TXT_PWD_ER = "Пароли не совпадают";


UserProfile_View.prototype.checkPass = function(){
	var pwd = this.getElement("pwd").getValue();
	if (pwd && pwd.length){
		var pwd_conf = this.getElement("pwd_confirm").getValue();
		if (pwd_conf && pwd_conf.length && pwd!=pwd_conf){
			this.getElement("pwd_confirm").setNotValid(this.TXT_PWD_ER);
			this.getControlSave().setEnabled(false);
		}
		else if (pwd_conf && pwd_conf.length){
			this.getElement("pwd_confirm").setValid();
			if (!this.getControlSave().getEnabled()){
				this.getControlSave().setEnabled(true);
			}
		}
		else if ((!pwd_conf || !pwd_conf.length) && this.getControlSave().getEnabled()){
			this.getControlSave().setEnabled(false);
		}
	}
}

/*
UserProfile_View.prototype.onSaveOk = function(resp){
	UserProfile_View.superclass.onSaveOk.call(this,resp);
	
	window.showNote(this.NOTE_DATA_SAVED,null,3000);
}
*/
