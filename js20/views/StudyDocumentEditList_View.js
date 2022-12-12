/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 *
 *	Форма используется для группового редактирования сертификатов из StudyDocumentList_View
 */
function StudyDocumentEditList_View(id,options){	

	options = options || {};
	this.m_keys = options.keys;
	this.m_onEditDone = options.onEditDone;
	
	options.addElement = function(){
		this.addElement(new ClientEdit(id+":companies_ref",{
			"cmdInsert": window.getApp().isAdmin(),
			"title":"Установить общую для всех сертификатов компанию",
			"labelCaption":"Компания:",
			"placeholder":"Введите наименование для поиска"
		}));	

		this.addElement(new StudyDocumentRegisterEdit(id+":study_document_registers_ref",{
			"placeholder":"Введите наименование для поиска",
			"title":"Установить общий для всех сертификатов протокол"
		}));
		
		/*
		this.addElement(new StudyTypeEdit(id+":study_type",{
			"title":"Установить общий для всех сертификатов вид документа"
		}));
					
		this.addElement(new EditString(id+":series",{
			"labelCaption": "Серия:",
			"title":"Установить общую для всех сертификатов серию"
		}));			
		
		
		this.addElement(new EditString(id+":study_prog_name",{
			"labelCaption": "Программа обучения:",
			"title":"Установить общую для всех сертификатов программу обучениния"
		}));			
		
		this.addElement(new ProfessionEdit(id+":profession"));			
		
		this.addElement(new EditNum(id+":study_period",{
			"labelCaption": "Период (часов):",
			"title": "Период обучения, часов",
			"title":"Установить общий для всех сертификатов период обучения в часах"
		}));

		this.addElement(new QualificationEdit(id+":qualification_name"),{
			"title":"Установить общее для всех сертификатов наименование квалификации"
		});
		
		*/
		
		
		this.addElement(new StudyFormEdit(id+":study_form"),{
			"title":"Установить общую для всех сертификатов форму обучения"
		});						
					
	}
	
	StudyDocumentEditList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.StudyDocumentList_Model)? options.models.StudyDocumentList_Model : new StudyDocumentList_Model();
	var contr = new StudyDocument_Controller();
	
	this.m_tdClass = "noPadding";
	
	var srv_events;
	var role = window.getApp().getServVar("role_id");
	if(role == "client_admin1"){
		//company
		var company_id = window.getApp().getServVar("company_id");
		srv_events = {		
			"events":[
				{"id": "StudyDocument.insert_comp_"+company_id}
				,{"id": "StudyDocument.update_comp_"+company_id}
				,{"id": "StudyDocument.delete_comp_"+company_id}
			]
		}
		
	}else if(role == "client_admin2"){
		//user
		var user_id = window.getApp().getServVar("user_id");
		srv_events = {
			"events":[
				{"id": "StudyDocument.insert_usr_"+user_id}
				,{"id": "StudyDocument.update_usr_"+user_id}
				,{"id": "StudyDocument.delete_usr_"+user_id}
			]
		};
	}
	
	var self = this;
	var grid = new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"onEventSetCellOptions": function(opts){
			opts.attrs = opts.attrs || {};
			opts.attrs["class"] = opts.attrs["class"] || "";
			opts.attrs["class"]+= (opts.attrs["class"]=="")? "":" ";
			opts.attrs["class"]+= self.m_tdClass;
			var col_id = opts.gridColumn.getId();
			if(col_id == "name_first" || col_id == "name_second" || col_id == "name_middle" || col_id == "snils"){
				opts.attrs["class"]+= " persist";
			}
		},
		"editViewOptions":{
			"containerClass":this.m_tdClass
		},
		"commands": null, //new GridCmdContainerAjx(id+":grid:cmd",{}),	
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:name_second",{
							"value":"Фамилия",
							"attrs":{"class":"persist"},
							"columns":[
								new GridColumn({
									"field":model.getField("name_second"),
									"ctrlClass": NameEdit,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"required":true,
										"cmdClear":false,
										"placeholder":"Фамилия",
										"title":"Фамилия физического лица",
										"events":{
											"paste":function(e){
												var names = window.getApp().splitNameOnPaste(e);
												if(names){
													var f = self.getElement("grid").m_editViewObj
													if(names[0]){
														f.getElement("name_first").setValue(names[0]);
													}
													if(names[1]){
														f.getElement("name_middle").setValue(names[1]);
													}
												}
											}
										}
									}
								})
							],
							"sortable":true							
						})
						,new GridCellHead(id+":grid:head:name_first",{
							"value":"Имя",
							"attrs":{"class":"persist"},
							"columns":[
								new GridColumn({
									"field":model.getField("name_first"),
									"ctrlClass": NameEdit,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"required":true,
										"cmdClear":false
									}									
								})
							]
						})
						,new GridCellHead(id+":grid:head:name_middle",{
							"value":"Отчество",
							"attrs":{"class":"persist"},
							"columns":[
								new GridColumn({
									"field":model.getField("name_middle"),
									"ctrlClass": NameEdit,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:snils",{
							"value":"СНИСЛ",
							"attrs":{"class":"persist"},
							"columns":[
								new GridColumn({
									"field":model.getField("snils"),
									"ctrlClass": EditSNILS,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"required":true,
										"cmdClear":false
									}
								})
							],
							"sortable":true
						})
					
						,new GridCellHead(id+":grid:head:issue_date",{
							"value":"Дата выдачи",
							//"visible":false,
							"columns":[
								new GridColumnDate({
									"field":model.getField("issue_date"),
									"ctrlClass":EditDateInlineValidation,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false,
										"cmdSelect": false
									}																		
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:end_date",{
							"value":"Дата окончания",
							//"visible":false,
							"columns":[
								new GridColumnDate({
									"field":model.getField("end_date"),
									"ctrlClass":EditDateInlineValidation,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false,
										"cmdSelect": false
									}																		
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:post",{
							"value":"Должность",
							"columns":[
								new GridColumn({
									"field":model.getField("post"),
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false
									}																		
									
								})
							],
							"sortable":true
						})
						/*
						= КОМПАНИЯ
						,new GridCellHead(id+":grid:head:work_place",{
							"value":"Место работы",
							//"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("work_place"),
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false
									}																		
									
								})
							],
							"sortable":true
						})
						*/
						,new GridCellHead(id+":grid:head:organization",{
							"value":"Организация",
							"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("organization"),
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false
									}																											
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:study_type",{
							"value":"Вид обучения",
							//"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("study_type"),
									"ctrlClass":StudyTypeEdit,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false,
										"cmdSelect":false
									}																		
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:series",{
							"value":"Серия",
							//"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("series"),
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false
									}																		
								})
							],
							"sortable":true
						})					
						,new GridCellHead(id+":grid:head:number",{
							"value":"Номер",							
							"columns":[
								new GridColumn({
									"field":model.getField("number"),
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false
									}																		
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:study_prog_name",{
							"value":"Программа обучения",
							//"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("study_prog_name"),
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false
									}																		
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:profession",{
							"value":"Профессия",
							//"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("profession"),
									"ctrlClass":ProfessionEdit,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false,
										"cmdSelect":false
									}																		
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:reg_number",{
							"value":"Рег.номер",
							"columns":[
								new GridColumn({
									"field":model.getField("reg_number"),
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false
									}																		
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:study_period",{
							"value":"Период",
							//"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("study_period"),
									"ctrlClass":EditNum,
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"maxLength":"10",
										"cmdClear":false
									}
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:qualification_name",{
							"value":"Квалификация",
							//"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("qualification_name"),
									"ctrlClass":QualificationEdit,
									"ctrlOptions":{
										"labelCaption":"",
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false,
										"cmdSelect":false
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
		"refreshInterval":null,
		"rowSelect":false,
		"focus":true,
		"srvEvents": srv_events
	});
	
	grid.closeEditView = function(res){
		self.m_onEditDone(res);
	}
	this.addElement(grid);
}
extend(StudyDocumentEditList_View,ViewAjxList);


StudyDocumentEditList_View.prototype.toDOM = function(p){
	StudyDocumentEditList_View.superclass.toDOM.call(this, p);
	
	var self = this;
	window.getApp().gridOnBatchEdit(this.getElement("grid"), "StudyDocument_Controller", "StudyDocumentList_Model", this.m_keys,
		["name_first","name_second","name_middle","snils"], function(grid){
			self.gridOnBatchEditSubmit(grid);
		});			
	
}

StudyDocumentEditList_View.prototype.gridOnBatchEditSubmit = function(grid){
	var ob = [];
	var old_keys = [];
	var errors = window.getApp().gridOnBatchEditFetchObjects(grid, ob, old_keys);
	
	if(errors==true){
		return;
	}
	var companies_ref = this.getElement("companies_ref").getValue();
	var company_id;
	if(companies_ref && !companies_ref.isNull()){
		company_id = companies_ref.getKey("id");
	}
	var study_document_registers_ref = this.getElement("study_document_registers_ref").getValue();
	var study_document_register_id;
	if(study_document_registers_ref && !study_document_registers_ref.isNull()){
		study_document_register_id = study_document_registers_ref.getKey("id");
	}
	
	var f_ind = 0;
	if(study_document_register_id || company_id && old_keys.length){
		for(var k = 0; k < ob.length; k++){
			if(ob[k].old_id == old_keys[0].old_id){
				f_ind = k;
				break;
			}
		}
		if(!f_ind){
			ob.push({"old_id": old_keys[0].old_id});
			f_ind = ob.length-1;
		}
		if(study_document_register_id){
			ob[f_ind].study_document_register_id = study_document_register_id;
		}
		if(company_id){
			ob[f_ind].company_id = company_id;
			//+
			ob[f_ind].work_place = companies_ref.getDescr();
			
		}
	}

	//
	var attrs = ["study_form"];
	for(var a = 0; a < attrs.length; a++){
		var v = this.getElement(attrs[a]).getValue();
		if(v && v.length){
			if(!f_ind){
				for(var k = 0; k < ob.length; k++){
					if(ob[k].old_id == old_keys[0].old_id){
						f_ind = k;
						break;
					}
				}
				if(!f_ind){
					ob.push({"old_id": old_keys[0].old_id});
					f_ind = ob.length-1;
				}
			}
			
			ob[f_ind][attrs[a]] = v;
		}
	}

	if(ob.length){
		var pm = grid.getReadPublicMethod().getController().getPublicMethod("batch_update");	
		pm.setFieldValue("objects", ob);
		pm.run({
			"ok":function(){
				grid.closeEditView({"updated":true});
			}
		});
	}else{
		//close
		grid.closeEditView({"updated":false});
	}
}

