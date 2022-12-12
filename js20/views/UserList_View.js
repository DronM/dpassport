/** Copyright (c) 2016
 *	Andrey Mikhalevich, Katren ltd.
 */
function UserList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Пользователи";

	var client_edit = window.getApp().clientEditAccess();

	UserList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.UserList_Model)? options.models.UserList_Model : new UserList_Model();
	var contr = new User_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var filters;
	if (!options.detail){
		filters = {
			/*"id":{
				"binding":new CommandBinding({
					"control":new EditNum(id+":filter-ctrl-id",{
						"contClassName":"form-group-filter",
						"labelCaption":"Идентификатор:"
					}),
				"field":new FieldInt("id")}),
				"sign":"e"		
			}*/
			"organization":{
				"binding":new CommandBinding({
					"control":new ClientEdit(id+":filter-ctrl-organization",{
						"contClassName":"form-group-filter",
						"labelCaption":"Организация:",
						"cmdInsert":false
					}),
				"field":new FieldInt("organization")}),
				"sign":"e"		
			}
			,"name":{
				"binding":new CommandBinding({
					"control":new EditString(id+":filter-ctrl-name",{
						"contClassName":"form-group-filter",
						"labelCaption":"Адрес электронной почты:"
					}),
				"field":new FieldString("name")}),
				"sign":"lk",
				"icase": "1",
				"lwcards": true,
				"rwcards": true					
			}
			
			,"person_url":{
				"binding":new CommandBinding({
					"control":new EditString(id+":filter-ctrl-person_url",{
						"contClassName":"form-group-filter",
						"labelCaption":"QR код:"
					}),
				"field":new FieldString("person_url")}),
				"sign":"e"		
			}
			
			,"birthdate":{
				"binding":new CommandBinding({
					"control":new EditString(id+":filter-ctrl-birthdate",{
						"contClassName":"form-group-filter",
						"labelCaption":"Дата рождения:"
					}),
				"field":new FieldDate("birthdate")}),
				"sign":"e"		
			}
			,"sex":{
				"binding":new CommandBinding({
					"control":new Enum_sexes(id+":filter-ctrl-sex",{
						"contClassName":"form-group-filter",
						"labelCaption":"Пол:"
					}),
				"field":new FieldString("sex")}),
				"sign":"e"		
			}
			,"viewed":{
				"binding":new CommandBinding({
					"control":new EditSelect(id+":filter-ctrl-viewed",{
						"contClassName":"form-group-filter",
						"labelCaption":"Новые пользователи:",
						"elements":[
							,new EditSelectOption(id+":filter-ctrl-active:null",{
								"value": null,
								"descr": "Все"
							})						
							,new EditSelectOption(id+":filter-ctrl-active:false",{
								"value": false,
								"descr": "Только новые"
							})
						]
					}),
				"field":new FieldBool("viewed")}),
				"sign":"e"		
			}
			
			,"banned":{
				"binding":new CommandBinding({
					"control":new EditSelect(id+":filter-ctrl-banned",{
						"contClassName":"form-group-filter",
						"labelCaption":"Доступ закрыт:",
						"elements":[
							new EditSelectOption(id+":filter-ctrl-banned:true",{
								"value": true,
								"descr": "Только с закрытым доступом"
							})
							,new EditSelectOption(id+":filter-ctrl-banned:false",{
								"value": false,
								"descr": "Только с откртым доступом"
							})						
						]
					}),
				"field":new FieldBool("banned")}),
				"sign":"e"		
			}
		}
		window.getApp().addLastUpdateToGridFilter(id, filters);
	}
		
	var srv_events;
	var role = window.getApp().getServVar("role_id");
	if(role == "client_admin1" || role == "client_admin2"){
		//company
		var company_id = window.getApp().getServVar("company_id");
		srv_events = {		
			"events":[
				{"id": "User.insert_comp_"+company_id}
				,{"id": "User.update_comp_"+company_id}
				,{"id": "User.delete_comp_"+company_id}
			]
		}		
	}
		
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":User_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert": options.detail? false:client_edit,
			"cmdDelete": options.detail? false:client_edit,
			"filters": filters,
			"cmdExport": options.detail? false:client_edit,
			"exportFileName":"Пользователи"
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name_full",{
							"value":"ФИО",
							"colAttrs":{
								"title":function(fields){
									if(!fields.viewed.getValue()){
										return "Непросмотренный пользователь";
										
									}else if(fields.banned.getValue()){
										return "Доступ закрыт";
									}
								},
								"unseen":function(fields){
									return fields.viewed.getValue()? "false":"true";
								},
								"banned":function(fields){
									return fields.banned.getValue();
								}
							},			
							"columns":[
								new (options.detail? GridColumnRef : GridColumn) ({
									"field":model.getField("name_full"),
									"form": User_Form,
									"formatFunction":  options.detail? function(fields){
										return fields.name_full.getValue();
									} : null,
									"onClickRef": options.detail? function(keys, e){
										var td = DOMHelper.getParentByTagName(e.target,"TD");
										if (!td){
											return;
										}
										var tr = DOMHelper.getParentByTagName(td,"TR");
										if(!tr){
											return;
										}
										keys = CommonHelper.unserialize(tr.getAttribute("keys"));
										this.openRef(keys);
									}: null
								})
							],
							"sortable":true,
							"sort":"asc"							
						})						
						,new GridCellHead(id+":grid:head:role_id",{
							"value":"Роль",
							"columns":[
								new EnumGridColumn_role_types({
									"field":model.getField("role_id")
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:post",{
							"value":"Должность",
							"columns":[
								new GridColumn({"field":model.getField("post")})
							]
						})
						,options.detail? null : new GridCellHead(id+":grid:head:companies_ref",{
							"value":"Организация",
							"columns":[
								new GridColumnRef({
									"field":model.getField("companies_ref"),
									"ctrlClass":ClientEdit,
									"searchOptions":{
										"field":new FieldInt("company_id"),
										"searchType":"on_match",
										"typeChange":false
									},
									"form":Client_Form
									/*
									"formatFunction":function(f){
										var res = "";
										if(f.companies_ref && !f.companies_ref.isNull()){
											res = f.companies_ref.getValue().getDescr();
											//client
											if(f.clients_ref && !f.clients_ref.isNull()){
												res+= " ("+
													f.clients_ref.getValue().getDescr()+
													")";
											}
										}
										return res;
									}
									*/
								})
							]
						})
						,new GridCellHead(id+":grid:head:qr_code_sent_date",{
							"value":"Дата отправки QR",
							"columns":[
								new GridColumnDate({
									"field":model.getField("qr_code_sent_date")
								})
							]
						})
						
					]
				})
			]
		}),
		"pagination":new pagClass(id+"_page",
			{"countPerPage":constants.doc_per_page_count.getValue()}),		
		
		"autoRefresh":false,
		"refreshInterval":constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true,
		"srvEvents": srv_events
	}));	
}
extend(UserList_View,ViewAjxList);
