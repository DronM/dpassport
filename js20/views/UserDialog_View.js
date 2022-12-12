/* Copyright (c) 2016
 *	Andrey Mikhalevich, Katren ltd.
 */
function UserDialog_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Карточка пользователя";
	options.cmdSave = false;
	options.controller = new User_Controller();
	options.model = (options.models&&options.models.UserDialog_Model)? options.models.UserDialog_Model : new UserDialog_Model();

	var app = window.getApp();
	var adm = app.clientEditAccess();
	var role = app.getServVar("role_id");
	var is_admin = (role=="admin");
	var user_id, user_role, qr_code;
	if(options.model && options.model.getNextRow()){
		user_id = options.model.getFieldValue("id");
		user_role = options.model.getFieldValue("role_id");
		qr_code = options.model.getFieldValue("qr_code");
	}
	options.templateOptions = options.templateOptions || {};
	options.templateOptions.EDIT_ALLOWED = adm;
	options.templateOptions.IS_ADMIN = is_admin;
	options.templateOptions.BAN_ALLOWED = (
		is_admin
		||(role == "client_admin1" && user_role=="client_admin2")
		||(role == "client_admin1" && user_role=="person")
		||(role == "client_admin2" && user_role=="person")
	) && app.getServVar("user_id")!=user_id;
	options.templateOptions.QR = qr_code;
	
	var self = this;
	options.addElement = function(){
		this.addElement(new EditEmailInlineValidation(id+":name"),{
			"required":true
		});

		this.addElement(new Enum_role_types(id+":role",{
			"labelCaption":"Роль:",
			"required":true,
			"enabled":is_admin,
			"value":is_admin? undefined : "client_admin2"
		}));	

		this.addElement(new Enum_sexes(id+":sex",{
			"labelCaption":"Пол:"
		}));	
		
		this.addElement(new EditPhone(id+":phone_cel",{
			"labelCaption":"Моб.телефон:"
		}));
		
		this.addElement(new NameEdit(id+":name_full",{
			"maxLength":"500",
			"labelCaption":"ФИО:",
			"placeholder":"Фамилия Имя Отчество"
		}));
		this.addElement(new EditString(id+":post",{
			"maxLength":"500",
			"labelCaption":"Должность:"
		}));
		
		this.addElement(new EditSNILS(id+":snils"));

		this.addElement(new UserPhotoEdit(id+":photo",{
			"view": this
		}));		

		this.addElement(new EditPhone(id+":phone_cel",{
			"labelCaption":"Телефон:",
			"title":"Мобильный телефон пользователя"
		}));

		if(options.templateOptions.IS_ADMIN){
			this.addElement(new ClientEdit(id+":companies_ref"),{
				"labelCaption": "Организация:",
				"cmdInsert": false,
				"required": !is_admin,
				"enabled": is_admin,
				"value": (is_admin)? null: app.getCompanyRef()
			});
		}
		if(options.templateOptions.BAN_ALLOWED){
			this.addElement(new EditCheckBox(id+":banned",{
				"labelCaption":"Доступ запрещен:",
				"title":"При установленной галочке пользователь не сможет заходить в программу"
			}));
		}

		
		this.addElement(new ButtonCmd(id+":cmdGenQR",{
			"caption":" Создать QR код ",
			"glyph":"glyphicon glyphicon-qrcode",
			"title":"QR код для доступа к личному кабинету",
			"visible": (qr_code==undefined),
			"onClick":function(){
				self.cmdGenQR();
			}
		}));
		this.addElement(new ButtonCmd(id+":cmdSendQRmail",{
			"caption":" Отправить приглашение со ссылкой ",
			"glyph":"glyphicon glyphicon-send",
			"title":"Отправить по электронной почте приглашение со ссылкой к личному кабинету",
			"visible": (qr_code!=undefined),
			"onClick":function(){
				self.cmdSendQRmail();
			}			
		}));

		if(adm){
			this.addElement(new ButtonCmd(id+":cmdResetPwd",{
				"onClick":function(){
					self.resetPwd();
				}
			}));								
			//mac grid
			//this.addElement(new UserMacAddressList_View(id+":mac_list"));

			//Login grid
			this.addElement(new LoginList_View(id+":login_list",{"detail":true}));

			//Login device grid
			this.addElement(new LoginDeviceList_View(id+":login_device_list",{
				"detail":true
				,"onBanSession":function(){
					//refresh session list
					self.getElement("login_list").getElement("grid").onRefresh();
				}
			}));

			this.addElement(new ObjectModLog_View(id+":object_mod_log",{"detail":true}));
		}
	}	
	
	UserDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************	
	
	//read
	var r_bd = [
		new DataBinding({"control":this.getElement("name")})
		,new DataBinding({"control":this.getElement("name_full")})
		,new DataBinding({"control":this.getElement("post")})
		,new DataBinding({"control":this.getElement("snils")})
		,new DataBinding({"control":this.getElement("role"), "field":this.m_model.getField("role_id")})
		,new DataBinding({"control":this.getElement("phone_cel")})
		,new DataBinding({"control":this.getElement("sex")})
		,new DataBinding({"control":this.getElement("photo")})
	];
	if(options.templateOptions.BAN_ALLOWED){
		r_bd.push(new DataBinding({"control":this.getElement("banned")}));
	}
	if(options.templateOptions.IS_ADMIN){
		r_bd.push(new DataBinding({"control":this.getElement("companies_ref")}));
	}
	this.setDataBindings(r_bd);
	
	//write
	var wr_b = [
		new CommandBinding({"control":this.getElement("name")})
		,new CommandBinding({"control":this.getElement("name_full")})
		,new CommandBinding({"control":this.getElement("post")})
		,new CommandBinding({"control":this.getElement("snils")})
		,new CommandBinding({"control":this.getElement("role"),"fieldId":"role_id"})
		,new CommandBinding({"control":this.getElement("phone_cel")})
		,new CommandBinding({"control":this.getElement("sex")})
		,new CommandBinding({"control":this.getElement("photo")})
	];
	if(options.templateOptions.BAN_ALLOWED){
		wr_b.push(new CommandBinding({"control":this.getElement("banned")}));		
	}
	if(options.templateOptions.IS_ADMIN){
		wr_b.push(new CommandBinding({"control":this.getElement("companies_ref"), "fieldId":"company_id"}));
	}	
	this.setWriteBindings(wr_b);
	
	if(adm){
		/*this.addDetailDataSet({
			"control":this.getElement("mac_list").getElement("grid"),
			"controlFieldId":"user_id",
			"field":this.m_model.getField("id")
		});*/
		
		this.addDetailDataSet({
			"control":this.getElement("login_list").getElement("grid"),
			"controlFieldId":"user_id",
			"field":this.m_model.getField("id")
		});

		this.addDetailDataSet({
			"control":this.getElement("login_device_list").getElement("grid"),
			"controlFieldId":"user_id",
			"field":this.m_model.getField("id")
		});
		
		this.addDetailDataSet({
			"control":this.getElement("object_mod_log").getElement("grid"),
			"controlFieldId": ["object_type", "object_id"],
			"value": ["users", function(){
				return self.m_model.getFieldValue("id");
			}]
		});
	}	
}
extend(UserDialog_View,ViewObjectAjx);

UserDialog_View.prototype.resetPwdCont = function(){
	var pm = this.getController().getPublicMethod("reset_pwd");
	pm.setFieldValue("user_id",this.getElement("id").getValue());
	var self = this;
	this.getElement("cmdResetPwd").setEnabled(false);		
	pm.run({
		"ok":function(resp){
			window.showTempNote("Пароль сброшен. Пользователю отправлено письмо с новым паролем.",null,5000);
			//self.close({"updated":true});
		}
		,"all":function(){
			self.getElement("cmdResetPwd").setEnabled(true);		
		}
	});
}

UserDialog_View.prototype.saveAndCall = function(callBack){
	if (this.getCmd() != "insert" && !this.getModified()){
		callBack();
	}
	else{	
		var self = this;
		this.getControlOK().setEnabled(false);		
		this.onSave(
			function(){
				callBack();
			},
			null,
			function(){
				self.getControlOK().setEnabled(true);		
			}
		);			
	}
}

UserDialog_View.prototype.resetPwd = function(){
	var self = this;
	this.saveAndCall(function(){
		self.resetPwdCont();
	});
	/*
	if (this.getCmd() != "insert" && !this.getModified()){
		this.resetPwdCont();
	}
	else{	
		var self = this;
		this.getControlOK().setEnabled(false);		
		this.onSave(
			function(){
				self.resetPwdCont();
			},
			null,
			function(){
				self.getControlOK().setEnabled(true);		
			}
		);			
	}
	*/
}

UserDialog_View.prototype.onGetData = function(resp,cmd){
	UserDialog_View.superclass.onGetData.call(this,resp,cmd);
	
	var m = this.getModel();
	var viewed = m.getFieldValue("viewed");
	var id = m.getFieldValue("id");
	if(!viewed && id && window.getApp().getServVar("role_id")=="admin"){
		var pm = (new User_Controller()).getPublicMethod("set_viewed");
		pm.setFieldValue("user_id", id);
		pm.run({
			"ok":function(){
				window.showTempNote("Установлена отметка об открытии",null,5000);
			}
		});
	}	
}

UserDialog_View.prototype.cmdSendQRmailCont = function(){
	var id = this.getElement("id").getValue();
	if(!id){
		throw new Error("id is not defined");
	}
	var pm = (new User_Controller()).getPublicMethod("send_qrcode_email");
	pm.setFieldValue("user_id", id);
	var self = this;
	pm.run({
		"ok":function(){
			window.showTempNote("Письмо с персональной ссылкой и QR кодом  отправлено",null,5000);
		}
	})
}

UserDialog_View.prototype.cmdSendQRmail = function(){
	var self = this;
	this.saveAndCall(function(){
		self.cmdSendQRmailCont();
	});
}

UserDialog_View.prototype.cmdGenQRCont = function(){
	var id = this.getElement("id").getValue();
	if(!id){
		throw new Error("id is not defined");
	}
	var pm = (new User_Controller()).getPublicMethod("gen_qrcode");
	window.setGlobalWait(true);
	pm.setFieldValue("user_id", id);
	var self = this;
	pm.run({
		"ok":function(){
			var pm = (new User_Controller()).getPublicMethod("get_object");
			pm.setFieldValue("id", id);
			pm.run({
				"ok":function(resp){
					var m = resp.getModel("UserDialog_Model");
					if(m && m.getNextRow()){
						document.getElementById("UserDialog:qr_code").src = "data:image/png;base64, "+m.getFieldValue("qr_code");						
						self.getElement("cmdGenQR").setVisible(false);
						self.getElement("cmdSendQRmail").setVisible(true);
						window.showTempNote("Создан QR код",null,5000);
					}
				}
				,"all":function(){
					window.setGlobalWait(false);
				}
			});
		}
		,"fail":function(resp,errCode,errStr){
			window.setGlobalWait(false);
			throw new Error(errStr);
		}
	});
}
UserDialog_View.prototype.cmdGenQR = function(){
	var self = this;
	this.saveAndCall(function(){
		self.cmdGenQRCont();
	});
}
