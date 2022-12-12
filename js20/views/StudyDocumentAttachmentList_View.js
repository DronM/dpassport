/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentAttachmentList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Журнал вложений";

	StudyDocumentAttachmentList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.StudyDocumentAttachmentList_Model)? options.models.StudyDocumentAttachmentList_Model : new StudyDocumentAttachmentList_Model();
	var contr = new StudyDocumentAttachment_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":StudyDocument_Form,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"exportFileName" :"Вложения"
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time")
								})
							],
							"sortable":true,
							"sort":"desc"							
						}),
					
						new GridCellHead(id+":grid:head:content_info",{
							"value":"Файл",
							"columns":[
								new GridColumnRef({
									"field":model.getField("content_info"),
									"formatFunction": function(fields){
										return "stub";
									}
								})
							]
						}),
						new GridCellHead(id+":grid:head:content_preview",{
							"value":"Содержание",
							"columns":[
								new GridColumnPicture({
									"field":model.getField("content_preview"),
									"pictureWidth": "50",
									"pictureHeight": "50"
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
extend(StudyDocumentAttachmentList_View,ViewAjxList);

