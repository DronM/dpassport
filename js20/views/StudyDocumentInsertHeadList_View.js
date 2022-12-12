/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentInsertHeadList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Журнал черновиков";

	StudyDocumentInsertHeadList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.StudyDocumentInsertHeadList_Model)? options.models.StudyDocumentInsertHeadList_Model : new StudyDocumentInsertHeadList_Model();
	var contr = new StudyDocumentInsertHead_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":StudyDocumentInsertHead_Form,
		"commands": new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdExport": false
		}),	
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:register_date",{
							"value":"Дата протокола",
							"columns":[
								new GridColumnDate({
									"field":model.getField("register_date")
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:register_name",{
							"value":"Наименование протокола",
							"columns":[
								new GridColumn({
									"field":model.getField("register_name")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:companies_ref",{
							"value":"Компания",
							"columns":[
								new GridColumnRef({
									"field":model.getField("companies_ref")
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":grid:head:register_attachment",{
							"value":"Скан",
							"columns":[
								new GridColumnPicture({
									"field":model.getField("register_attachment")
								})
							]
						})						
						,new GridCellHead(id+":grid:head:study_document_count",{
							"value":"Количество сертификатов",
							"columns":[
								new GridColumn({
									"field":model.getField("study_document_count")
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
		"focus":true
	}));	
	


}
extend(StudyDocumentInsertHeadList_View, ViewAjxList);

