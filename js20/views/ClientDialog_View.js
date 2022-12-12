/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends ViewObjectAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function ClientDialog_View(id,options){	

	options = options || {};
	
	options.HEAD_TITLE = "Организация";
	options.cmdSave = false;
	options.model = (options.models&&options.models.ClientDialog_Model)? options.models.ClientDialog_Model : new ClientDialog_Model();
	options.controller = options.controller || new Client_Controller();
	
	var app = window.getApp();
	var role = app.getServVar("role_id");
	options.templateOptions = options.templateOptions || {}
	options.templateOptions.IS_ADMIN = (role=="admin");
	
	var self = this;
	options.addElement = function(){
		this.addElement(new EditString(id+":name",{
			"labelCaption":"Наименование:",
			"required":true,
			"focus":true,
			"maxLength":"250",
			"placeholder":"Краткое наименование контрагента",
			"title":"Краткое наименование контрагента для поиска"
		}));	

		this.addElement(new EditString(id+":name_full",{
			"labelCaption":"Полное наименование:",
			"required":true,
			"focus":true,
			"maxLength":"1000",
			"placeholder":"Официальное наименование контрагента",
			"title":"Полное наименование контрагента в соответствии с учредительными документами",
			"events":{
				"focus": function(){
					var v = self.getElement("name_full").getValue();
					if(!v || !v.length){
						self.getElement("name_full").setValue(self.getElement("name").getValue());
					}
				}
			}
		}));	

		this.addElement(new EditNum(id+":inn",{
			"required":false,
			"maxLength":12,
			"labelCaption":"ИНН:",
			"buttonSelect": new ButtonOrgSearch(id+":btnOrgSearch",{
				"viewContext":this,
				"onGetAttrs": function(){
					var attrs = this.DEF_ATTRS;
					attrs["Адрес"] = "legal_address"
					return attrs;
				}
			}),
			"required":true			
		}));	

		this.addElement(new EditNum(id+":kpp",{
			"required":false,
			"maxLength":10,
			"labelCaption":"КПП:"
		}));	

		this.addElement(new EditString(id+":post_address",{		
			"maxLength":1000,
			"labelCaption":"Почтовый адрес:",
			"placeholder":"Почтовый адрес",
			"title":"Почтовый адрес организации"
		}));	

		this.addElement(new EditString(id+":legal_address",{		
			"maxLength":1000,
			"labelCaption":"Юридический адрес:",
			"placeholder":"Юридический адрес",
			"title":"Адрес организации в соответствии с учредительыми документами"
		}));	

		this.addElement(new EditNum(id+":ogrn",{		
			"maxLength":15,
			"labelCaption":"ОГРН:",
			"title":"Регистрационный номер организации",
			"required":true
		}));	
		
		this.addElement(new EditNum(id+":okpo",{		
			"maxLength":20,
			"labelCaption":"ОКПО:",
			"title":"ОКПО организации"
		}));	
		
		this.addElement(new EditString(id+":okved",{
			"maxLength":50,
			"labelCaption":"ОКВЭД:",
			"title":"Код ОКВЭД организации"
		}));

		if(options.templateOptions.IS_ADMIN){
			this.addElement(new ClientEdit(id+":parents_ref",{
				"labelCaption":"Основная организация:",
				"cmdInsert":false
			}));
			
			//grid
			this.addElement(new ClientAccessList_View(id+":client_access_list",{"detail":true}));
			
			//grid
			this.addElement(new ClientList_View(id+":company_list",{"detail":true}));

			//grid
			this.addElement(new UserList_View(id+":user_list",{"detail":true}));			
		}
		
		this.addElement(new EditEmail(id+":email",{
			"labelCaption":"Адрес электронной почты:"
		}));
		this.addElement(new EditString(id+":tel",{
			"labelCaption":"Телефоны:"
		}));


		//grid
		this.addElement(new ObjectModLog_View(id+":object_mod_log",{"detail":true}));
		
	}
	
	ClientDialog_View.superclass.constructor.call(this,id,options);
	
	
	//****************************************************	
	
	//read
	var read_b = [
		new DataBinding({"control":this.getElement("name")}),
		new DataBinding({"control":this.getElement("name_full")}),
		new DataBinding({"control":this.getElement("inn")}),
		new DataBinding({"control":this.getElement("kpp")}),
		new DataBinding({"control":this.getElement("legal_address")}),
		new DataBinding({"control":this.getElement("post_address")}),
		new DataBinding({"control":this.getElement("ogrn")}),
		new DataBinding({"control":this.getElement("okved")}),		
		new DataBinding({"control":this.getElement("okpo")}),
		new DataBinding({"control":this.getElement("email")}),
		new DataBinding({"control":this.getElement("tel")}),				
	];
	if(options.templateOptions.IS_ADMIN){
		read_b.push(new DataBinding({"control":this.getElement("parents_ref")}));
	}
	this.setDataBindings(read_b);
	
	//write
	var write_b = [
		new CommandBinding({"control":this.getElement("name")}),
		new CommandBinding({"control":this.getElement("name_full")}),
		new CommandBinding({"control":this.getElement("inn")}),
		new CommandBinding({"control":this.getElement("kpp")}),
		new CommandBinding({"control":this.getElement("legal_address")}),
		new CommandBinding({"control":this.getElement("post_address")}),
		new CommandBinding({"control":this.getElement("ogrn")}),
		new CommandBinding({"control":this.getElement("okved")}),		
		new CommandBinding({"control":this.getElement("okpo")}),
		new CommandBinding({"control":this.getElement("email")}),
		new CommandBinding({"control":this.getElement("tel")}),
	];
	if(options.templateOptions.IS_ADMIN){
		write_b.push(new CommandBinding({"control":this.getElement("parents_ref"),"fieldId":"parent_id"}));
	}
	this.setWriteBindings(write_b);
	
	if(options.templateOptions.IS_ADMIN){
		this.addDetailDataSet({
			"control":this.getElement("client_access_list").getElement("grid"),
			"controlFieldId":"client_id",
			"field":this.m_model.getField("id")
		});

		this.addDetailDataSet({
			"control":this.getElement("company_list").getElement("grid"),
			"controlFieldId":"parent_id",
			"field":this.m_model.getField("id")
		});
		
		this.addDetailDataSet({
			"control":this.getElement("user_list").getElement("grid"),
			"controlFieldId":"company_id",
			"field":this.m_model.getField("id")
		});
	}	
	this.addDetailDataSet({
		"control":this.getElement("object_mod_log").getElement("grid"),
		"controlFieldId": ["object_type", "object_id"],
		"value": ["clients", function(){
			return self.m_model.getFieldValue("id");
		}]
	});
	
}
extend(ClientDialog_View,ViewObjectAjx);

ClientDialog_View.prototype.onGetData = function(resp,cmd){
	ClientDialog_View.superclass.onGetData.call(this,resp,cmd);
	
	var m = this.getModel();
	var viewed = m.getFieldValue("viewed");
	var id = m.getFieldValue("id");
	if(!viewed && id){
		var pm = (new Client_Controller()).getPublicMethod("set_viewed");
		pm.setFieldValue("client_id", id);
		pm.run({
			"ok":function(){
				window.showTempNote("Установлена отметка об открытии",null,5000);
			}
		});
	}
	
	if (window.getApp().getServVar("role_id")=="client_admin2"){
		//разрешено редактировать, только самим созданные
	}
}

