/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function MailMessageList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Журнал исходящих электронных писем";

	MailMessageList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.MailMessageList_Model)? options.models.MailMessageList_Model : new MailMessageList_Model();
	var contr = new MailMessage_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":false,
		"editWinClass":StudyDocument_Form,
		"commands": new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert": false,
			"cmdEdit": false,
			"exportFileName" :"ЭлектронныеПисьма"
		}),	
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						,new GridCellHead(id+":grid:head:date_time",{
							"value":"Дата",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("date_time")
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":grid:head:subject",{
							"value":"Тема",
							"columns":[
								new GridColumn({
									"field":model.getField("subject")
								})
							]
						})
					
						/*,new GridCellHead(id+":grid:head:from_addr",{
							"value":"Отпр.адрес",
							"columns":[
								new GridColumn({
									"field":model.getField("from_addr")
								})
							],
							"sortable":true							
						})
						,new GridCellHead(id+":grid:head:from_name",{
							"value":"Отпр.имя",
							"columns":[
								new GridColumn({
									"field":model.getField("from_name")
								})
							],
							"sortable":true							
						})*/
						,new GridCellHead(id+":grid:head:to_addr",{
							"value":"Получатель адрес",
							"columns":[
								new GridColumn({
									"field":model.getField("to_addr")
								})
							],
							"sortable":true							
						})
						,new GridCellHead(id+":grid:head:to_name",{
							"value":"Получатель имя",
							"columns":[
								new GridColumn({
									"field":model.getField("to_name")
								})
							],
							"sortable":true							
						})
						,new GridCellHead(id+":grid:head:to_addr",{
							"value":"Получатель адрес",
							"columns":[
								new GridColumn({
									"field":model.getField("to_addr")
								})
							],
							"sortable":true							
						})
						/*,new GridCellHead(id+":grid:head:reply_addr",{
							"value":"Ответ адрес",
							"columns":[
								new GridColumn({
									"field":model.getField("reply_addr")
								})
							],
							"sortable":true							
						})
						,new GridCellHead(id+":grid:head:reply_name",{
							"value":"Ответ имя",
							"columns":[
								new GridColumn({
									"field":model.getField("reply_name")
								})
							],
							"sortable":true							
						})*/
						/*,new GridCellHead(id+":grid:head:sender_addr",{
							"value":"Адрес отправителя",
							"columns":[
								new GridColumn({
									"field":model.getField("sender_addr")
								})
							],
							"sortable":true							
						})*/
						,new GridCellHead(id+":grid:head:sent_date_time",{
							"value":"Отправка",
							"columns":[
								new GridColumnDateTime({
									"field":model.getField("sent_date_time")
								})
							]
						})
						,new GridCellHead(id+":grid:head:error_str",{
							"value":"Ошибка",
							"columns":[
								new GridColumn({
									"field":model.getField("error_str")
								})
							]
						})
						
						,new GridCellHead(id+":grid:head:mail_type",{
							"value":"Тип",
							"columns":[
								new EnumGridColumn_mail_types({
									"field":model.getField("mail_type")
								})
							]
						})
						,new GridCellHead(id+":grid:head:body_begin",{
							"value":"Тело",
							"columns":[
								new GridColumn({
									"field":model.getField("body_begin")
								})
							]
						})
						,new GridCellHead(id+":grid:head:attachment_count",{
							"value":"Вложения",
							"columns":[
								new GridColumn({
									"field":model.getField("attachment_count")
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
extend(MailMessageList_View, ViewAjxList);

