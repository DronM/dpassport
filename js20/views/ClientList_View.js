/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Организации";

	ClientList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.ClientList_Model)? options.models.ClientList_Model : new ClientList_Model();
	var contr = new Client_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var filters;
	if(!options.detail){
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
				"legal_address":{
					"binding":new CommandBinding({
						"control":new EditNum(id+":filter-ctrl-legal_address",{
							"contClassName":"form-group-filter",
							"labelCaption":"Юридический адрес:"
						}),
					"field":new FieldString("legal_address")}),
					"sign": "lk",
					"icase": "1",
					"lwcards": true,
					"rwcards": true
				}
				,"post_address":{
					"binding":new CommandBinding({
						"control":new EditNum(id+":filter-ctrl-post_address",{
							"contClassName":"form-group-filter",
							"labelCaption":"Почтовый адрес:"
						}),
					"field":new FieldString("post_address")}),
					"sign": "lk",
					"icase": "1",
					"lwcards": true,
					"rwcards": true
				}
				,"viewed":{
					"binding":new CommandBinding({
						"control":new EditSelect(id+":filter-ctrl-viewed",{
							"contClassName":"form-group-filter",
							"labelCaption":"Новые организации:",
							"elements":[
								,new EditSelectOption(id+":filter-ctrl-viewed:false",{
									"value": false,
									"descr": "Только новые"
								})
							]
						}),
					"field":new FieldBool("viewed")}),
					"sign":"e"		
				}
				
				,"active":{
					"binding":new CommandBinding({
						"control":new EditSelect(id+":filter-ctrl-active",{
							"contClassName":"form-group-filter",
							"labelCaption":"Активные организации:",
							"elements":[
								new EditSelectOption(id+":filter-ctrl-active:true",{
									"value": true,
									"descr": "Только активные"
								})
								,new EditSelectOption(id+":filter-ctrl-active:false",{
									"value": false,
									"descr": "Только не активные"
								})						
							]
						}),
					"field":new FieldBool("active")}),
					"sign":"e"		
				}
			};
	
		if(window.getApp().getServVar("role_id") == "admin"){
			filters.no_parent = {
				"binding":new CommandBinding({
					"control":new EditSelect(id+":filter-ctrl-no_parent",{
						"contClassName":"form-group-filter",
						"labelCaption":"Площадка:",
						"elements":[
							new EditSelectOption(id+":filter-ctrl-no_parent:true",{
								"value": true,
								"descr": "Только площадки"
							})
							,new EditSelectOption(id+":filter-ctrl-no_parent:false",{
								"value": false,
								"descr": "Только не площадки"
							})						
						]
					}),
				"field":new FieldBool("no_parent")}),
				"sign":"e"		
			};			
		}
		
		window.getApp().addLastUpdateToGridFilter(id, filters);
	}
	var client_edit = window.getApp().clientEditAccess();
	
	var srv_events;
	var role = window.getApp().getServVar("role_id");
	if(role == "client_admin1" || role == "client_admin2"){
		//company
		var company_id = window.getApp().getServVar("company_id");
		srv_events = {		
			"events":[
				{"id": "Client.insert_comp_"+company_id}
				,{"id": "Client.update_comp_"+company_id}
				,{"id": "Client.delete_comp_"+company_id}
			]
		}				
	}
	
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":Client_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"exportFileName" :"Организации",
			"cmdExport": client_edit,
			"cmdInsert": !options.detail,
			"cmdEdit": !options.detail,
			"cmdDelete": true,
			"filters": filters
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name",{
							"value":"Наименование",
							"colAttrs":{
								"title":function(fields){
									if(!fields.viewed.getValue()){
										return "Непросмотренная организация";
										
									}else if(!fields.active.getValue()){
										return "Неоплаченный доступ (нактивная)";
									}else{
										return "Активня организация";
									}									
								},
								"unseen":function(fields){
									return fields.viewed.getValue()? "false":"true";
								},
								"not_active":function(fields){
									return fields.active.getValue()? "false":"true";
								}
								
							},			
							"columns":[
								new GridColumn({"field":model.getField("name")})
							]
							//"sortable":true,
							//"sort":"asc"							
						}),
						new GridCellHead(id+":grid:head:inn",{
							"value":"ИНН",
							"columns":[
								new GridColumn({"field":model.getField("inn")})
							]
							//"sortable":true
						}),
						new GridCellHead(id+":grid:head:ogrn",{
							"value":"ОГРН",
							"columns":[
								new GridColumn({"field":model.getField("ogrn")})
							]
							//"sortable":true
						})
						,new GridCellHead(id+":grid:head:parents_ref",{
							"value":"Площадка",
							"columns":[
								new GridColumnRef({
									"field":model.getField("parents_ref"),
									"ctrlClass":ClientEdit,
									"bindFieldId": "parent_id"
								})
							]
							//"sortable":true
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
extend(ClientList_View,ViewAjxList);
