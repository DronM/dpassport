/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends View
 * @requires core/extend.js
 * @requires controls/View.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function PersonData_View(id,options){
	options = options || {};	
	
	var self = this;
		
	options.addElement = function(){
	
		this.addElement(new EditSelect(id+":sort_order",{		
			//"inline":true,
			//"contClassName":"",
			"addNotSelected": false,
			"labelCaption":"Порядок сортировки:",
			"visible": false,
			"events":{
				"change":function(e){
					self.onChangeSortOrder(e);
				}
			},
			"elements": [
				new EditSelectOption(id+":grp:issue_date",{
					"value": "issue_date",
					"descr": "Дата выдачи",
					"checked": true
				})
				,new EditSelectOption(id+":grp:end_date",{
					"value": "end_date",
					"descr": "Дата окончания"
				})								
				,new EditSelectOption(id+":grp:post",{
					"value": "post",
					"descr": "Должность"
				})
				,new EditSelectOption(id+":grp:work_place",{
					"value": "work_place",
					"descr": "Место работы"
				})
				,new EditSelectOption(id+":grp:organization",{
					"value": "organization",
					"descr": "Организация"
				})
				,new EditSelectOption(id+":grp:study_type",{
					"value": "study_type",
					"descr": "Вид обучения"
				})
				,new EditSelectOption(id+":grp:series",{
					"value": "series",
					"descr": "Серия"
				})
				,new EditSelectOption(id+":grp:number",{
					"value": "number",
					"descr": "Номер"
				})
				,new EditSelectOption(id+":grp:study_prog_name",{
					"value": "study_prog_name",
					"descr": "Программа обучения"
				})
				,new EditSelectOption(id+":grp:profession",{
					"value": "profession",
					"descr": "Профессия"
				})
				,new EditSelectOption(id+":grp:reg_number",{
					"value": "reg_number",
					"descr": "Рег.номер"
				})
				,new EditSelectOption(id+":grp:study_period",{
					"value": "study_period",
					"descr": "Период"
				})
				,new EditSelectOption(id+":grp:qualification_name",{
					"value": "qualification_name",
					"descr": "Квалификация"
				})
			]
		}));
	
		this.addElement(new EditRadioGroup(id+":view_switch",{
			//"inline":true,
			//"contClassName":"",
			"labelCaption": "Вариант просмотра:",
			"elements": [
				new EditRadio(id+":grp:list",{
					"name":"view_switch",
					"value":"list",
					"labelCaption":"В форме списка",
					"title":"Представление данных в форме списка",
					"labelAlign":"right",
					"labelClassName":"",
					"contClassName":"row",
					"editContClassName":"",
					"className":"",
					"checked": true,
					"events":{
						"change":function(){
							self.onChangeViewSwitch();
						}
					}
				})				
				,new EditRadio(id+":grp:box",{
					"name":"view_switch",
					"value":"box",
					"labelCaption":"В форме карточек",
					"title":"Представление данных в форме карточек",
					"labelAlign":"right",
					"labelClassName":"",
					"contClassName":"row",
					"editContClassName":"",
					"className":"",
					"events":{
						"change":function(){
							self.onChangeViewSwitch();
						}
					}
				})						
			]
		}));

		this.addElement(new EditRadioGroup(id+":sort_direct",{
			//"inline":true,
			//"contClassName":"",
			"visible": false,
			"labelCaption": "Направление сортировки:",
			"elements": [
				new EditRadio(id+":grp:asc",{
					"name":"sort_direct",
					"value":"asc",
					"labelCaption":"по возрастанию",
					"title":"Сортировать по возрастанию значений",
					"labelAlign":"right",
					"labelClassName":"",
					"contClassName":"row",
					"editContClassName":"",
					"className":"",
					"checked": true,
					"events":{
						"change":function(){
							self.onChangeSortOrder();
						}
					}
				})				
				,new EditRadio(id+":grp:desc",{
					"name":"sort_direct",
					"value":"desc",
					"labelCaption":"по убыванию",
					"title":"Сортировать по убыванию значений",
					"labelAlign":"right",
					"labelClassName":"",
					"contClassName":"row",
					"editContClassName":"",
					"className":"",
					"events":{
						"change":function(){
							self.onChangeSortOrder();
						}
					}
				})						
			]
		}));
	
		this.m_pdata = this.getDataElement("list",options);
		this.addElement(this.m_pdata);				
	}
	
	PersonData_View.superclass.constructor.call(this, id, "DIV", options);
	
	//ButtonCmd
	this.m_cmdSearch = new GridCmdSearch(id+":search",{
		"caption":"Поиск",
		"grid": this.m_pdata
	});
	
	this.m_cmdSearch.controlsToContainer(this);
}
//ViewObjectAjx,ViewAjxList
extend(PersonData_View, ControlContainer);

/* Constants */


/* private members */

/* protected*/


/* public methods */

PersonData_View.prototype.onChangeSortOrder = function(){
	var sort_col = this.getElement("sort_order").getValue();
	var sort_dir = this.getElement("sort_direct").getValue();

	var head = this.m_pdata.getHead();
	for(var col in head.m_elements["row0"].m_elements){
		head.m_elements["row0"].m_elements[col].setSort((col==sort_col)? sort_dir : "")
	}
	this.m_pdata.onRefresh();
}

PersonData_View.prototype.onChangeViewSwitch = function(){
	var view_opt = this.getElement("view_switch").getValue();
	this.getElement("sort_order").setVisible((view_opt == "box"));
	this.getElement("sort_direct").setVisible((view_opt == "box"));
	
	var sorting = {"col":null, "direct":"null"};
	var pag_from = 0;
	var filters, search_inf;
	if(this.m_pdata){
		//sorting/diret
		var head = this.m_pdata.getHead();
		for(var col in head.m_elements["row0"].m_elements){
			var direct = head.m_elements["row0"].m_elements[col].getSort();
			if(direct == "asc" || direct == "desc"){
				sorting.col = col;
				sorting.direct = direct;
				break;
			}
		}
		
		//pagination
		pag_from = this.m_pdata.getPagination().getFrom();
		
		//filter
		filters = this.m_pdata.getFilters();
		search_inf = this.m_pdata.getSearchInfControl();
		
		this.m_pdata.delDOM();
		delete this.m_pdata;
		this.m_pdata = undefined;
	}
	this.m_pdata = this.getDataElement(view_opt, null);
	this.m_pdata.getPagination().setFrom(pag_from);
	if(sorting.col) {
		var head = this.m_pdata.getHead();
		for(var col in head.m_elements["row0"].m_elements){
			head.m_elements["row0"].m_elements[col].setSort((col==sorting.col)? sorting.direct : "")
		}
		if(view_opt != "list"){
			this.getElement("sort_order").setValue(sorting.col);
			this.getElement("sort_direct").setValue(sorting.direct);
		}
	}
	if(filters) {
		this.m_pdata.setFilters(filters);
		search_inf.m_grid = this.m_pdata;
		this.m_pdata.setSearchInfControl(search_inf);		
	}	
	this.m_pdata.toDOM(this.m_node);
	if(filters) {
		this.m_pdata.getSearchInfControl().show();
	}
	
	this.m_cmdSearch.m_grid = this.m_pdata;
}

PersonData_View.prototype.getDataElement = function(viewOption, options){
	var id = this.getId();
	
	var model_exists = (options && options.models && options.models.StudyDocumentWithPictList_Model);
	var model = model_exists? options.models.StudyDocumentWithPictList_Model : new StudyDocumentWithPictList_Model();
	var contr = new StudyDocument_Controller();
	
	var constants = {"doc_per_page_count":null};//,"grid_refresh_interval":null
	window.getApp().getConstantManager().get(constants);
	var pagClass = window.getApp().getPaginationClass();
	
	var pag  = new pagClass(id+"_page",{
		"countPerPage": constants.doc_per_page_count.getValue()
		,"attrs": (viewOption=="list")? null: {"style": "clear:both;"}
	});
	var self = this;
	return (new GridAjx(id+":pdata",{
		"model":model,
		"controller":contr,
		"readPublicMethod": contr.getPublicMethod("get_with_pict_list"),
		"editInline":false,
		"editWinClass":null,
		"commands": null,	
		"popUpMenu": null,
		"showHead": (viewOption=="list"),
		"tagName": (viewOption=="list")? null : "DIV",
		"bodyTagName": (viewOption=="list")? null : "DIV",
		"className": (viewOption=="list")? null : "smallWidthCardFormat",
		
		"onEventSetRowOptions":function(rowOpts){
			var m = this.getModel();
			rowOpts.attrs = rowOpts.attrs || {};
			rowOpts.attrs["style"] = "cursor: pointer;";
			rowOpts.attrs["title"] = "Кликните для открытия документа";
			rowOpts.events = rowOpts.events || {};
			rowOpts.events.click = (function(docId){
				return function(){
					self.openDoc(docId);
				}
			})(m.getFieldValue("id"))
		},
		
		"onEventSetCellOptions":function(cellOpts){
			if(cellOpts.gridColumn.getId()=="attachments"){
				var doc_id = cellOpts.fields.id.getValue();
				var att = cellOpts.fields.attachments.getValue();
				if(att&&att.length){
					cellOpts.attrs = cellOpts.attrs||{};
					cellOpts.attrs["style"] = "cursor: pointer;";
					cellOpts.attrs["title"] = "Кликните для открытия документа";
					cellOpts.events = {
						"click": (function(docId, fileId){
							return function(e){								
								self.downloadAttachment(docId, fileId);
								e.stopPropagation();
							}
						})(doc_id, att[0].id)
					}
				}
			}
		},
		
		"head":new GridHead(id+":pdata:head",{
			"rowClass": (viewOption=="list")? GridRow : PersonDataBoxGridRow,
			"elements":[
				new GridRow(id+":pdata:head:row0",{
					"elements":[
						,new GridCellHead(id+":pdata:head:issue_date",{
							"value":"Дата выдачи",
							"colAlign": (viewOption=="list")? "center" : "left",
							"columns":[
								new GridColumnDate({
									"field":model.getField("issue_date")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
									/*,"formatFunction": (viewOption=="list")? null : function(f){
										return "Дата выдачи:"+ DateHelper.format(f.issue_date.getValue(),"dd/mm/y")
									}*/
								})
							],
							"sortable":true,
							"sort":"desc"
						})
						,new GridCellHead(id+":pdata:head:end_date",{
							"value":"Дата окончания",
							"colAlign": (viewOption=="list")? "center" : "left",
							"columns":[
								new GridColumnDate({
									"field":model.getField("end_date")									
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:post",{
							"value":"Должность",
							"columns":[
								new GridColumn({
									"field":model.getField("post")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:work_place",{
							"value":"Место работы",
							"columns":[
								new GridColumn({
									"field":model.getField("work_place")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:organization",{
							"value":"Организация",
							"columns":[
								new GridColumn({
									"field":model.getField("organization")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:study_type",{
							"value":"Вид обучения",
							"columns":[
								new GridColumn({
									"field":model.getField("study_type")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:series",{
							"value":"Серия",
							"columns":[
								new GridColumn({
									"field":model.getField("series")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})					
						,new GridCellHead(id+":pdata:head:number",{
							"value":"Номер",
							"columns":[
								new GridColumn({
									"field":model.getField("number")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:study_prog_name",{
							"value":"Программа обучения",
							"columns":[
								new GridColumn({
									"field":model.getField("study_prog_name")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:profession",{
							"value":"Профессия",
							"columns":[
								new GridColumn({
									"field":model.getField("profession")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:reg_number",{
							"value":"Рег.номер",
							"columns":[
								new GridColumn({
									"field":model.getField("reg_number")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:study_period",{
							"value":"Период",
							"columns":[
								new GridColumn({
									"field":model.getField("study_period")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							],
							"sortable":true
						})
						,new GridCellHead(id+":pdata:head:qualification_name",{
							"value":"Квалификация",
							"columns":[
								new GridColumn({
									"field":model.getField("qualification_name")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							]
						})						
						,new GridCellHead(id+":pdata:head:attachments",{
							"value":"Скан",
							"columns":[
								new GridColumnPicture({
									"field":model.getField("attachments")
									,"cellClass": (viewOption=="list")? GridCell : PersonDataBoxGridCell
								})
							]
						})						
						
					]
				})
			]
		}),
		"pagination": pag,
		"autoRefresh": !model_exists,
//constants.grid_refresh_interval.getValue()*1000		
		"refreshInterval":null,
		"rowSelect":false,
		"focus":true
	}));	
}

PersonData_View.prototype.downloadAttachment = function(docId, fileId){
	var ref = new RefType({"dataType":"study_documents", "keys": {"id": docId}});
	var pm = (new StudyDocumentAttachment_Controller()).getPublicMethod("get_file");
	pm.setFieldValue("study_documents_ref", CommonHelper.serialize(ref));
	pm.setFieldValue("content_id", fileId);
	pm.setFieldValue("inline", 0);
	var offset = 0;
	var h = $( window ).width()/3*2;
	var left = $( window ).width()/2;
	var w = left - 20;
	
	pm.openHref("ViewXML","location=0,menubar=0,status=0,titlebar=0,top=50"+",left="+left+",width="+w+",height="+h);
}

PersonData_View.prototype.openDoc = function(docId){
	var self = this;
	var pm = (new StudyDocument_Controller).getPublicMethod("get_object");
	pm.setFieldValue("id", docId);
	pm.run({
		"ok":function(resp){
			self.openDocCont(resp.getModel("StudyDocumentDialog_Model"));
		}
	})
}

PersonData_View.prototype.openDocCont = function(mDialog){
	var self = this;
	this.m_modal = new WindowFormModalBS(this.m_modalId,{
		"contentHead": "Документ",
		"dialogWidth": "50%",
		"content":new StudyDocumentPersonDialog_View(this.m_modalId+":cont",{
			"models":{"StudyDocumentDialog_Model": mDialog},
			"onDownloadAttachment": function(studyDocumentId, fileId){
				self.downloadAttachment(studyDocumentId, fileId);
			}
		}),
		"controlOk": new ButtonCmd(this.m_modalId+":btn-ok",{
			"caption": "ОК",
			"title": "Закрыть форму документа",
			"onClick": function(){
				self.closeDoc();
			}
		}),
		"cmdCancel":false,
		"cmdOk":false
	});
	
	this.m_modal.open();	
}

PersonData_View.prototype.closeDoc = function(){
	this.m_modal.close();
	delete this.m_modal;
	this.m_modal = undefined;
}
