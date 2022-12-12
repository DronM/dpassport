/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Журнал сертификатов";

	StudyDocumentList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.StudyDocumentList_Model)? options.models.StudyDocumentList_Model : new StudyDocumentList_Model();
	var contr = new StudyDocument_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var issue_period_control = new EditPeriodDate(id+":filter-ctrl-issue_period",{
		"labelCaption":"Период выпуска:",
		"cmdDownFast": false,
		"cmdDown": false,
		"cmdUp": false,
		"cmdUpFast": false,
		"controlCmdClear": false,
		"field":new FieldDate("issue_date")			
	});
	var end_period_control = new EditPeriodDate(id+":filter-ctrl-end_period",{
		"labelCaption":"Период окончания:",
		"cmdDownFast": false,
		"cmdDown": false,
		"cmdUp": false,
		"cmdUpFast": false,
		"controlCmdClear": false,
		"field":new FieldDate("end_date")			
	});
	
	var filters = {
		"issue_period":{
			"binding":new CommandBinding({
				"control":issue_period_control,
				"field":issue_period_control.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":issue_period_control.getControlFrom(),
					"field":issue_period_control.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":issue_period_control.getControlTo(),
					"field":issue_period_control.getField()
					}),
				"sign":"le"
				}
			]
		}
		,"end_period":{
			"binding":new CommandBinding({
				"control":end_period_control,
				"field":end_period_control.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":end_period_control.getControlFrom(),
					"field":end_period_control.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":end_period_control.getControlTo(),
					"field":end_period_control.getField()
					}),
				"sign":"le"
				}
			]
		}
		
		/*,"id":{
			"binding":new CommandBinding({
				"control":new EditNum(id+":filter-ctrl-id",{
					"contClassName":"form-group-filter",
					"labelCaption":"Идентификатор:"
				}),
			"field":new FieldInt("id")}),
			"sign":"e"		
		}*/
		,"snils":{
			"binding":new CommandBinding({
				"control":new EditSNILS(id+":filter-ctrl-snils",{
					"contClassName":"form-group-filter"
				}),
			"field":new FieldString("snils")}),
			"sign":"e"		
		}
		,"post":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-post",{
					"contClassName":"form-group-filter",
					"labelCaption":"Должность:"
				}),
			"field":new FieldString("post")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		,"work_place":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-work_place",{
					"contClassName":"form-group-filter",
					"labelCaption":"Место работы:"
				}),
			"field":new FieldString("work_place")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		,"study_type":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-study_type",{
					"contClassName":"form-group-filter",
					"labelCaption":"Вид обучения:"
				}),
			"field":new FieldString("study_type")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		,"series":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-series",{
					"contClassName":"form-group-filter",
					"labelCaption":"Серия:"
				}),
			"field":new FieldString("series")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		,"number":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-number",{
					"contClassName":"form-group-filter",
					"labelCaption":"Серия:"
				}),
			"field":new FieldString("number")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		,"study_prog_name":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-study_prog_name",{
					"contClassName":"form-group-filter",
					"labelCaption":"Программа обучения:"
				}),
			"field":new FieldString("study_prog_name")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		,"profession":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-profession",{
					"contClassName":"form-group-filter",
					"labelCaption":"Профессия:"
				}),
			"field":new FieldString("profession")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		,"reg_number":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-reg_number",{
					"contClassName":"form-group-filter",
					"labelCaption":"Рег.номер:"
				}),
			"field":new FieldString("reg_number")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		,"study_period":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-study_period",{
					"contClassName":"form-group-filter",
					"labelCaption":"Период обучения:"
				}),
			"field":new FieldString("study_period")}),
			"sign":"e"
		}
		,"qualification_name":{
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-qualification_name",{
					"contClassName":"form-group-filter",
					"labelCaption":"Квалификация:"
				}),
			"field":new FieldString("qualification_name")}),
			"sign":"lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
		}
		
	};
	
	window.getApp().addLastUpdateToGridFilter(id, filters);
	
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
	var grid = new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":StudyDocument_Form,
		"commands": new GridCmdContainerAjx(id+":grid:cmd",{
			"exportFileName" :"Сертификаты",
			"addCustomCommandsAfter":function(commands){
				commands.push(new StudyDocumentUploadGridCmd(id+":grid:cmd:upload",
						{"showCmdControl":true,
						"controllerId": "StudyDocument_Controller"
						})
				);
			},
			"filters": filters
		}),	
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHeadMark(id+":grid:head:mark")
						
						/*,new GridCellHead(id+":grid:head:clients_ref",{
							"value":"Организация",
							"columns":[
								new GridColumnRef({
									"field":model.getField("clients_ref"),
									"ctrlClass":ClientEdit,
									"ctrlBindFieldId":"client_id",
									"ctrlOptions":{
										"cmdInsert":false,
										"labelCaption":"",
									}									
								})
							],
							"sortable":true							
						})*/
						,new GridCellHead(id+":grid:head:companies_ref",{
							"value":"Компания",
							"columns":[
								new GridColumnRef({
									"field":model.getField("companies_ref"),
									"ctrlClass":ClientEdit
								})
							],
							"sortable":true							
						})
						,new GridCellHead(id+":grid:head:organization",{
							"value":"Аттест.организация",
							"columns":[
								new GridColumn({
									"field":model.getField("organization")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:study_document_registers_ref",{
							"value":"Протокол",
							"columns":[
								new GridColumnRef({
									"field":model.getField("study_document_registers_ref"),
									"ctrlClass":StudyDocumentRegisterEdit
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:issue_date",{
							"value":"Дата выдачи",
							"columns":[
								new GridColumnDate({
									"field":model.getField("issue_date")
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:name_full",{
							"value":"Физ.лицо",
							"columns":[
								new GridColumn({
									"field":model.getField("name_full")
								})
							],
							"sortable":true
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
	});	
	
	var self = this;
	//batch uptate 
	this.m_gridEdit = grid.edit;
	grid.edit = function(cmd, editOptions){
		//multyselection?				
		var keys = this.getHead().getElement("row0").getElement("mark").getSelectedKeys();
		if(keys.length>1){
			//custom edit
			self.gridOnBatchEdit(this, keys);			
		}else{
			//parent call
			self.m_gridEdit.call(this, cmd, editOptions);
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
extend(StudyDocumentList_View,ViewAjxList);

StudyDocumentList_View.prototype.gridOnBatchEdit = function(grid, keys){
//"StudyDocumentRegister_Controller", "StudyDocumentRegisterList_Model", 
	//console.log(keys)
	//открыть модальную форму списки со всеми колонками
	var self = this;
	this.m_form = new WindowFormModalBS(this.getId()+":form",{
		"cmdCancel": false,
		"cmdOk": false,
		"content": new StudyDocumentEditList_View(this.getId()+":form:body:view",{
			"keys": keys,
			"onEditDone":function(res){
				if(res && res.updated){
					self.getElement("grid").onRefresh();
				}
				self.m_form.close();
			}
		}),
		"contentHead":"Групповое редактирование сертификатов",
		"dialogWidth":"95%"
	});

	this.m_form.open();
}
