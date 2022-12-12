/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentInsertList_View(id,options){	

	options = options || {};
	this.m_headView = options.headView;
	this.m_commonIds = options.commonIds;

	StudyDocumentInsertList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.StudyDocumentInsertList_Model)? options.models.StudyDocumentInsertList_Model : new StudyDocumentInsertList_Model();
	var contr = new StudyDocumentInsert_Controller();
	//contr.getPublicMethod("insert").setFieldValue("study_document_insert_head_id", options.headId);
	//contr.getPublicMethod("update").setFieldValue("study_document_insert_head_id", options.headId);
	//contr.getPublicMethod("get_list").setFieldValue("study_document_insert_head_id", options.headId);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	this.m_tdClass = "noPadding";
	
	var self = this;
	var grid = new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,//StudyDocumentInsert_Form,
		"insertViewOptions": function(){
			//save main form to get id!!!
			if (self.m_headView.getCmd() == "insert"){
				self.m_headView.onSave();
			}
			return {"containerClass":self.m_tdClass};
		},
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
		"commands": new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdExport": false,
			"cmdCopy":false
		}),	
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHeadMark(id+":grid:head:mark")
						,new GridCellHead(id+":grid:head:name_second",{
							"value":"Фамилия",
							"attrs":{"class":"persist"},
							"columns":[
								new GridColumn({
									"field":model.getField("name_second"),
									"ctrlClass":NameEdit,
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"required":true,
										"cmdClear":false,
										"placeholder":"Фамилия",
										"title":"Фамилия физического лица",
										"events":{
											"paste":function(e){
												var v = (e.clipboardData || window.clipboardData).getData('text');
												if(v && v.length>=5){
													e.preventDefault();
													//a a a
													v_parts = v.split(" ");
													if(v_parts.length > 1){
														var f = self.getElement("grid").m_editViewObj;
														e.target.value = (v_parts[0].length>1)?
															v_parts[0][0].toUpperCase()+v_parts[0].substring(1) : v_parts[0];
													}
													if(v_parts.length >= 2){
														f.getElement("name_first").setValue(
															(v_parts[1].length>1)?
															v_parts[1][0].toUpperCase()+v_parts[1].substring(1) : v_parts[1]
														);
													}
													if(v_parts.length >= 3){
														f.getElement("name_middle").setValue(
															(v_parts[2].length>1)?
															v_parts[2][0].toUpperCase()+v_parts[2].substring(1) : v_parts[2]
														);														
														f.getElement("snils").focus();
													}													
												}
											}
										}
									}
								})
							],
							"sortable":true,
							"sort":"asc"
						})
						,new GridCellHead(id+":grid:head:name_first",{
							"value":"Имя",
							"attrs":{"class":"persist"},
							"columns":[
								new GridColumn({
									"field":model.getField("name_first"),
									"ctrlClass":NameEdit,
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"required":true,
										"cmdClear":false,
										"placeholder":"Имя",
										"title":"Имя физического лица"
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
									"ctrlClass":NameEdit,
									"ctrlOptions":{
										"contClassName":"",
										"editContClassName":"",
										"cmdClear":false,
										"placeholder":"Отчество",
										"title":"Отчество физического лица"
									}
								})
							]
						})
						,new GridCellHead(id+":grid:head:snils",{
							"value":"СНИСЛ",
							"attrs":{"class":"persist"},
							"columns":[
								new GridColumnSNILS({
									"field":model.getField("snils"),
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
							"visible":false,
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
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:end_date",{
							"value":"Дата окончания",
							"visible":false,
							"columns":[
								new GridColumnDate({
									"field": model.getField("end_date"),
									"ctrlClass": EditDateInlineValidation,
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
						,new GridCellHead(id+":grid:head:work_place",{
							"value":"Место работы",
							"visible":false,
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
						,new GridCellHead(id+":grid:head:organization",{
							"value":"Атт.орг-ия",
							"title":"Аттестующая организация",
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
							"visible":false,
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
							"visible":false,
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
							"visible":false,
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
							"visible":false,
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
						,new GridCellHead(id+":grid:head:study_form",{
							"value":"Форма обучения",
							"visible":false,
							"columns":[
								new GridColumn({
									"field":model.getField("study_form"),
									"ctrlClass":StudyFormEdit,
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
		"focus":true
	});
	
	//batch uptate 
	this.m_gridEdit = grid.edit;
	grid.edit = function(cmd, editOptions){
		//multyselection?				
		var keys = this.getHead().getElement("row0").getElement("mark").getSelectedKeys();
		if(keys.length>1){
			//custom edit
			window.getApp().gridOnBatchEdit(this, "StudyDocumentInsert_Controller", "StudyDocumentInsertList_Model", keys,
				["name_first","name_second","name_middle","snils"]);			
		}else{
			//parent call
			self.m_gridEdit.call(this, cmd, editOptions);
		}
	}
	
	this.m_gridFillEditView = grid.fillEditView;
	grid.fillEditView = function(cmd){
		self.m_gridFillEditView.call(this, cmd);
		//common attributes
		for(var i = 0; i < self.m_commonIds.length; i++){
			var d = this.m_editViewObj.getElement(self.m_commonIds[i]);
			if(d){
				var s = self.m_headView.getElement("common_"+self.m_commonIds[i]);
				if(s){
					d.setValue(s.getValue());
				}
			}
		}		
	}
		
	//batch delete
	this.m_gridOnDelete = grid.onDelete;
	grid.onDelete = function(callBack){
		//multyselection?		
		var keys = this.getHead().getElement("row0").getElement("mark").getSelectedKeys();
		if(keys.length>1){
			window.getApp().gridOnBatchDelete(this, keys, callBack);			
		}else{
			self.m_gridOnDelete.call(this, callBack);
		}
	}
	
	this.addElement(grid);


}
extend(StudyDocumentInsertList_View,ViewAjxList);


