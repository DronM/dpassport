/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentRegisterList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Журнал протоколов";

	StudyDocumentRegisterList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.StudyDocumentRegisterList_Model)? options.models.StudyDocumentRegisterList_Model : new StudyDocumentRegisterList_Model();
	var contr = new StudyDocumentRegister_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var period_control = new EditPeriodDate(id+":filter-ctrl-period",{
		"labelCaption":"Период:",
		"cmdDownFast": false,
		"cmdDown": false,
		"cmdUp": false,
		"cmdUpFast": false,
		"controlCmdClear": false,
		"field":new FieldDate("issue_date")			
	});
	
	var filters = {
		"period":{
			"binding":new CommandBinding({
				"control":period_control,
				"field":period_control.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":period_control.getControlFrom(),
					"field":period_control.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":period_control.getControlTo(),
					"field":period_control.getField()
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
	};

	window.getApp().addLastUpdateToGridFilter(id, filters);
	
	var srv_events;
	var role = window.getApp().getServVar("role_id");
	if(role == "client_admin1"){
		//company
		var company_id = window.getApp().getServVar("company_id");
		srv_events = {		
			"events":[
				{"id": "StudyDocumentRegister.insert_comp_"+company_id}
				,{"id": "StudyDocumentRegister.update_comp_"+company_id}
				,{"id": "StudyDocumentRegister.delete_comp_"+company_id}
			]
		}
		
	}else if(role == "client_admin2"){
		//user
		var user_id = window.getApp().getServVar("user_id");
		srv_events = {
			"events":[
				{"id": "StudyDocumentRegister.insert_usr_"+user_id}
				,{"id": "StudyDocumentRegister.update_usr_"+user_id}
				,{"id": "StudyDocumentRegister.delete_usr_"+user_id}
			]
		};
	}
	
	var grid = new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":StudyDocumentRegister_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"exportFileName" :"Протоколы",
			"addCustomCommandsAfter":function(commands){
				commands.push(new StudyDocumentUploadGridCmd(id+":grid:cmd:rowUp",{"showCmdControl":true,"controllerId":"StudyDocumentRegister_Controller"}));
			},
			"filters": filters
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHeadMark(id+":grid:head:mark")
						,new GridCellHead(id+":grid:head:issue_date",{
							"value":"Дата",
							"columns":[
								new GridColumnDate({
									"field":model.getField("issue_date"),
									"ctrClass":EditDateInlineValidation,
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
					
						,new GridCellHead(id+":grid:head:name",{
							"value":"Наименование",
							"columns":[
								new GridColumn({
									"field":model.getField("name")
								})
							],
							"sortable":true
						}),
						new GridCellHead(id+":grid:head:organization",{
							"value":"Аттестующая орг-ия",
							"columns":[
								new GridColumn({
									"field":model.getField("organization"),
									"ctrlClass":ClientEditStr,
									"ctrlEdit":false,
									//"ctrlBindFieldId":"client_id",
									"ctrlOptions":{
										"cmdInsert":false,
										"labelCaption":"",
									}									
								})
							],
							"sortable":true
						}),
						new GridCellHead(id+":grid:head:companies_ref",{
							"value":"Компания",
							"columns":[
								new GridColumnRef({
									"field":model.getField("companies_ref"),
									"ctrlClass":ClientEdit,
									"ctrlBindFieldId":"company_id",
									"ctrlOptions":{
										"cmdInsert":false,
										"labelCaption":"",
										"cmdOpen":false,
										"cmdClear":false,
										"cmdSelect":false,
										"cmdAutoComplete":false
										//"inputEnabled":false
									}
								})
							],
							"sortable":true
						}),
						new GridCellHead(id+":grid:head:study_document_count",{
							"value":"Кол-во сертификатов",
							"columns":[
								new GridColumn({
									"field":model.getField("study_document_count"),
									"ctrlEdit":false
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
	});	
	
	var self = this;
	//batch uptate 
	this.m_gridEdit = grid.edit;
	grid.edit = function(cmd, editOptions){
		//multyselection?				
		var keys = this.getHead().getElement("row0").getElement("mark").getSelectedKeys();
		if(keys.length>1){
			//custom edit
			window.getApp().gridOnBatchEdit(this, "StudyDocumentRegister_Controller", "StudyDocumentRegisterList_Model", keys);			
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
extend(StudyDocumentRegisterList_View,ViewAjxList);


