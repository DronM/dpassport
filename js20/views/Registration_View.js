/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 
 * @class
 * @classdesc
	
 * @param {string} id view identifier
 * @param {namespace} options
 * @param {namespace} options.models All data models
 * @param {namespace} options.variantStorage {name,model}
 */	
function Registration_View(id,options){	

	options = options || {};
	
	var self = this;
	options.addElement = function(){
		this.addElement(new EditINN(id+":inn",{
			"required":true,
			"maxLength":12,			
			"events":{
				"input": function(){
					DOMHelper.hide("Registration:org_error");
					self.checkInnInput();					
				}
			}
		}));	

		this.addElement(new Captcha(id+":captchaCheckInn",{
			"errorControl": new ErrorControl(id+":captcha:error"),
			"captchaId": "check_inn",
			"templateOptions":{
				"IMG_CONT_CLASS": ""
			},
			"keyEvents":{
				"input": function(){
					self.getElement("captchaCheckInn").setValid();
					self.checkInnInput();					
				}
			}
		}));	
		
		this.addElement(new EditString(id+":name",{
			"labelCaption":"Наименование:"
			,"required":true
			,"focus":true
			,"maxLength":"250"
			,"placeholder":"Краткое наименование контрагента"
			,"title":"Краткое наименование контрагента для поиска"
			,"enabled":false
			,"cmdClear":false
			/*,"events":{
				"input": function(){
					self.m_orgAttrModified.name = true;
					self.m_orgModified = true;
				}
			}*/			
		}));	

		this.addElement(new EditString(id+":name_full",{
			"labelCaption":"Полное наименование:"
			,"required":true
			,"focus":true
			,"maxLength":"1000"
			,"placeholder":"Официальное наименование контрагента"
			,"title":"Полное наименование контрагента в соответствии с учредительными документами"
			,"enabled":false			
			,"cmdClear":false
			/*,"events":{
				"input": function(){
					self.m_orgAttrModified.name_full = true;
					self.m_orgModified = true;
				}
			}*/
		}));	
		
		this.addElement(new EditNum(id+":kpp",{
			"required":false
			,"maxLength":10
			,"labelCaption":"КПП:"
			,"enabled":false
			,"cmdClear":false
			/*,"events":{
				"input": function(){
					self.m_orgAttrModified.kpp = true;
					self.m_orgModified = true;
				}
			}*/
		}));	

		this.addElement(new EditString(id+":post_address",{		
			"maxLength":1000
			,"labelCaption":"Почтовый адрес:"
			,"placeholder":"Почтовый адрес"
			,"title":"Почтовый адрес организации"
			,"enabled":false
			,"cmdClear":false
			/*,"events":{
				"input": function(){
					self.m_orgAttrModified.post_address = true;
					self.m_orgModified = true;
				}
			}*/
		}));	

		this.addElement(new EditString(id+":legal_address",{		
			"maxLength":1000
			,"labelCaption":"Юридический адрес:"
			,"placeholder":"Юридический адрес"
			,"title":"Адрес организации в соответствии с учредительыми документами"
			,"enabled":false
			,"cmdClear":false
			/*,"events":{
				"input": function(){
					self.m_orgAttrModified.legal_address = true;
					self.m_orgModified = true;
				}
			}*/
		}));	

		this.addElement(new EditNum(id+":ogrn",{		
			"maxLength":15
			,"labelCaption":"ОГРН:"
			,"title":"Регистрационный номер организации"
			,"enabled":false
			,"cmdClear":false
			/*,"events":{
				"input": function(){
					self.m_orgAttrModified.ogrn = true;
					self.m_orgModified = true;
				}
			}*/
		}));	
		
		this.addElement(new EditNum(id+":okpo",{		
			"maxLength":20,
			"labelCaption":"ОКПО:",
			"title":"ОКПО организации"
			,"enabled":false
			,"cmdClear":false
			/*,"events":{
				"input": function(){
					self.m_orgAttrModified.okpo = true;
					self.m_orgModified = true;
				}
			}*/
		}));	
		
		this.addElement(new EditString(id+":okved",{
			"maxLength":50
			,"labelCaption":"ОКВЭД:"
			,"title":"Код ОКВЭД организации"
			,"enabled":false
			,"cmdClear":false
			/*,"events":{
				"input": function(){
					self.m_orgAttrModified.okved = true;
					self.m_orgModified = true;
				}
			}*/
		}));

		//ОФЕРТА
		this.addElement(new Control(id+":offer_file", "TEMPLATE", {
			"enabled": false,
			"events":{
				"click":function(){
					self.onOpenOffer();
				}
			}
		}));
		
		//Персональные данные
		this.addElement(new EditEmailInlineValidation(id+":user_name",{
			"labelCaption":"Электронная почта*:",
			"required": true,
			"placeholder":"Электронная почта",
			"title":"Адрес электронной почты пользователя. Обязательное для заполнения поле."
		}));	

		this.addElement(new EditString(id+":user_name_full",{
			"maxLength":"500",
			"labelCaption":"ФИО:",
			"placeholder":"Фамилия имя отчество",
			"title":"Фамилия, имя, отчество пользователя. Необязательное для заполнения поле."
		}));
		this.addElement(new EditString(id+":user_post",{
			"maxLength":"500",
			"labelCaption":"Должность:",
			"placeholder":"Должность пользователя",
			"title":"Должность пользователя. Необязательное для заполнения поле."
		}));
		
		this.addElement(new EditSNILS(id+":user_snils",{
			"labelCaption":"СНИЛС*:",
			"required": true,
			"placeholder":"СНИЛС ХХХ-ХХХ-ХХХ XX",
			"title":"СНИЛС пользователя в формате ХХХ-ХХХ-ХХХ XX. Обязательное для заполнения поле.",
			"events":{
				"input": function(){
					if(DOMHelper.hasClass(this.getNode(), this.INCORRECT_VAL_CLASS)){
						this.setValid();
					}
				}
			}
		}));

		this.addElement(new Enum_sexes(id+":user_sex",{
			"labelCaption":"Пол:",
			"title":"Пол пользователя. Необязательное для заполнения поле."
		}));	
		
		this.addElement(new Captcha(id+":captchaRegister",{
			"errorControl": new ErrorControl(id+":captchaRegister:error"),
			"required":true,
			"captchaId": "register",
			"templateOptions":{
				"IMG_CONT_CLASS": ""
			}
		}));	
		
	}
	
	Registration_View.superclass.constructor.call(this, id, options);
	
}
extend(Registration_View, View);

Registration_View.prototype.m_orgModified;
Registration_View.prototype.m_saveOrgInt;
Registration_View.prototype.m_orgAttrModified = {};
Registration_View.prototype.m_userAttrModified = {};
Registration_View.prototype.m_orgFound = false;
Registration_View.prototype.m_orgExists = false;

Registration_View.prototype.SAVE_INT_DELAY = 5000;

Registration_View.prototype.toDOM = function(p){	
	Registration_View.superclass.toDOM.call(this, p)

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
	
	DOMHelper.show('Registration:form');
	this.getElement("inn").focus();
}

Registration_View.prototype.checkInnInput = function(){	
	var v = document.getElementById("Registration:inn").value;
	var vc = document.getElementById("Registration:captchaCheckInn:key").value;
	if(v&&(v.length==10||v.length==12)
	&&vc&&vc.length==6){
		this.checkOrg(v, vc);
	}
}

Registration_View.prototype.checkOrg = function(inn, captchaKey){		
	var pm = (new Client_Controller()).getPublicMethod("check_for_register");
	pm.setFieldValue("inn", inn);
	pm.setFieldValue("captcha_key", captchaKey);
	var self = this;
	pm.run({
		"ok":function(resp){
			var m = resp.getModel("ClientDialog_Model");
			if(!m || !m.getNextRow()){
				return;
			}
			//hide captcha && show all attributes
			var cols = ["name","name_full","kpp","ogrn","okpo","okved","legal_address","post_address"];
			for(var i=0; i<cols.length; i++){
				self.getElement(cols[i]).setValue(m.getFieldValue(cols[i]));
			}
			self.getElement("captchaCheckInn").hide();
			DOMHelper.show("Registration:org_registered");
			DOMHelper.show("Registration:attrs");			
			
			self.m_orgFound = true;
			
			//old/new
			var m = resp.getModel("ClientExists_Model");
			if(m && m.getNextRow()){
				self.m_orgExists = (m.getFieldValue("val")=="true");
				if(self.m_orgExists){
					DOMHelper.show("Registration:org_exists");
					
					//Access
					var m = resp.getModel("ClientAccess_Model");
					if(m && m.getNextRow()){
						var f = DateHelper.strtotime(m.getFieldValue("date_from"));
						var t = DateHelper.strtotime(m.getFieldValue("date_to"));
						var period = DateHelper.format(f, "d/m/Y") + " - " + DateHelper.format(t, "d/m/Y");
						DOMHelper.setText("Registration:org_exists:period", period);
						DOMHelper.show("Registration:org_exists:payed");						
						//doc_1c_ref
						self.m_orgPayed = true;
					}else{
						DOMHelper.show("Registration:org_exists:not_payed");
					}
				
				}else{
					//Agreement
					var m = resp.getModel("ClientContract_Model");
					if(m && m.getNextRow()){
						document.getElementById("Registration:org_offer:text").value = m.getFieldValue("text");
					}							
					DOMHelper.show("Registration:org_offer");
				}
			}			
						
			//close for edit
			self.getElement("inn").setEnabled(false);
			
			//Не используется1
			//self.startSaveOrgAttrs();
		}
		,"fail":function(resp,errCode,errStr){
			if(resp.modelExists("Captcha_Model")){
				//new captcha
				self.getElement("captchaCheckInn").setFromResp(resp);				
			}
			
			if(errCode == 1001){
				self.getElement("captchaCheckInn").setNotValid(errStr);

			}else if(errCode == 1010){
				self.getElement("captchaCheckInn").setNotValid("Организация с данным ИНН не найдена");
			
			
			}else{
				window.getApp().addTextToCont(self.getId(), "org_error", errStr);
			}
		}
	});
}

//*** Сохранение атрибутов организации - не используется ***
Registration_View.prototype.saveOrgAttrsCont = function(callBack){
	this.m_orgModified = false;
	for(var id in this.m_orgAttrModified){
		delete this.m_orgAttrModified[id];
	}
	if(callBack){
		callBack();
	}
}

Registration_View.prototype.saveOrgAttrs = function(callBack){
	if(this.m_orgModified){
		var pm = (new Client_Controller()).getPublicMethod("update_attrs");
		for(var id in this.m_orgAttrModified){
			pm.setFieldValue(id, this.getElement(id).getValue());
		}
		var self = this;
		pm.run({
			"ok":function(resp){
				self.saveOrgAttrsCont(callBack);
			}
		});
	}else if (callBack){
		callBack();
	}
}
Registration_View.prototype.startSaveOrgAttrs = function(){
	if(this.m_saveOrgInt){
		clearInterval(this.m_saveOrgInt);
	}
	var self = this;
	this.m_saveOrgInt = setInterval(function(){
		self.saveOrgAttrs();
	}, this.SAVE_INT_DELAY)
}

//**** USER

//**** Offer
Registration_View.prototype.onOpenOffer = function(){
	alert("Registration_View.prototype.onOpenOffer")
}


//****STEP
Registration_View.prototype.onNextStep = function(nextStep){
	if(nextStep == 2){
		if(!this.m_orgFound){
			this.getElement("captchaCheckInn").setNotValid("Найдите организацию!");
			return false;
		}
		if(this.m_saveOrgInt){
			clearInterval(this.m_saveOrgInt);			
		}
		this.saveOrgAttrs(function(){
			return true;
		});
		
	}else if(nextStep == 3){
		//check oferta
		if (!this.m_orgExists && !document.getElementById("Registration:org_offer:agreed").checked){
			window.showTempError("Установите галочку согласен.", null, 5000);
			return false;
		}
		return true;
	}
}

Registration_View.prototype.onSubmit = function(nextStep){
	//validation
	//field - control
	var fields = {
		"inn" : "inn",
		"name_full" : "user_name_full",
		"name" : "user_name",
		"snils" : "user_snils",
		"post" : "user_post",
		"sex" : "user_sex",
		"captcha_key" : "captchaRegister"
	}
	var pm = (new User_Controller()).getPublicMethod("register");
	var res = true;
	for(f_id in fields){
		var ctrl = this.getElement(fields[f_id]);		
		if(ctrl.setValid){
			ctrl.setValid();
		}
		if(ctrl.validate && !ctrl.validate()){
			res = false;
		}
		var val = ctrl.getValue();
		if(ctrl.getRequired() && (!val || !val.length)){
			ctrl.setNotValid("Не заполнено");
			res = false;
		}
		if(res){
			pm.setFieldValue(f_id, val);
		}
	}
	if(!res){
		return;
	}
	
	var self = this;
	pm.run({
		"ok":function(resp){
			DOMHelper.hide("Registration:form");
			DOMHelper.show("Registration:user_registered");
		}
		,"fail":function(resp,errCode,errStr){
			if(resp.modelExists("Captcha_Model")){
				//new captcha
				self.getElement("captchaRegister").setFromResp(resp);
			}
			
			if(errCode == 1001){
				var ctrl = self.getElement("captchaRegister");
				ctrl.setNotValid(errStr);
				ctrl.setValue("");

			}else{
				window.getApp().addTextToCont(self.getId(), "user_error", errStr);
			}
		}
	})
	
}

//****

