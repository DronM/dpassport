/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function ObjectModLog_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Журнал изменения объектов";

	ObjectModLog_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.ObjectModLog_Model)? options.models.ObjectModLog_Model : new ObjectModLog_Model();
	var contr = new ObjectModLog_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert":false,
			"cmdEdit":false
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({"field":model.getField("date_time")})
							],
							"sortable":true,
							"sort":"desc"							
						})
						,options.detail? null : new GridCellHead(id+":grid:head:object_type",{
							"value":"Вид объекта",
							"columns":[
								new EnumGridColumn_data_types({
									"field":model.getField("object_type")
								})
							],
							"sortable":true
						})						
						,options.detail? null : new GridCellHead(id+":grid:head:object_id",{
							"value":"Идентификатор объекта",
							"columns":[
								new GridColumn({
									"field":model.getField("object_id")
								})
							],
							"sortable":true
						})						
						,options.detail? null : new GridCellHead(id+":grid:head:object_descr",{
							"value":"Представление объекта",
							"columns":[
								new GridColumn({
									"field":model.getField("object_descr")
								})
							],
							"sortable":true
						})						
						
						,new GridCellHead(id+":grid:head:user_descr",{
							"value":"Пользователь",
							"columns":[
								new GridColumn({
									"field":model.getField("user_descr")
								})
							],
							"sortable":true
						})						
						,new GridCellHead(id+":grid:head:action",{
							"value":"Действие",
							"columns":[
								new EnumGridColumn_object_mod_actions({
									"field":model.getField("action")
								})
							],
							"sortable":true
						})						
						,new GridCellHead(id+":grid:head:details",{
							"value":"Описание",
							"columns":[
								new GridColumn({
									"field":model.getField("details")
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
		"refreshInterval": constants.grid_refresh_interval.getValue()*1000,
		"rowSelect":false,
		"focus":true,
		"srvEvents": {
			"events": [{"id": "ObjectModLog.update"}]
		}
	}));	
	


}
extend(ObjectModLog_View,ViewAjxList);
