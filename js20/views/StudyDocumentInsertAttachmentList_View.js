/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function StudyDocumentInsertAttachmentList_View(id,options){	

	options = options || {};

	this.m_headView = options.headView;

	StudyDocumentInsertList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.StudyDocumentInsertAttachmentList_Model)? options.models.StudyDocumentInsertAttachmentList_Model : new StudyDocumentInsertAttachmentList_Model();
	var contr = new StudyDocumentInsertAttachment_Controller();
	
	var constants = {"allowed_attachment_extesions":null};
	window.getApp().getConstantManager().get(constants);
	this.m_allowedFileExtList = constants.allowed_attachment_extesions.getValue().split(",");

	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var self = this;
	
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"readPublicMethod":contr.getPublicMethod("get_list"),
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"insertViewOptions": function(){
			//save main form to get id!!!
			if (self.m_headView.getCmd() == "insert"){
				self.m_headView.onSave();
			}
			return {};
		},
		"commands": new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdPrint": false,
			"cmdCopy": false,
			"cmdInsert": false,
			"cmdEdit": false,
			"cmdExport": false,
			"cmdSearch": false,
			"addCustomCommandsAfter":function(commands){
				commands.push(new StudyDocumentInsertAttachmentListGridCmd(id+":grid:cmd:upload",{
					"showCmdControl":true,					
					"getHeadId": function(){
						return self.m_headView.getElement("id").getValue();
					}
				}));
			}			
		}),	
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						/*
						new GridCellHead(id+":grid:head:study_document_inserts_ref",{
							"value":"ФИО",
							"columns":[
								new GridColumnRef({
									"field":model.getField("study_document_inserts_ref"),
									"ctrlClass":StudyDocumentInsertEdit,
									"ctrlBindFieldId": "study_document_insert_id",
									"ctrlOptions": function(){
										return {
											"study_document_insert_head_id": self.m_headView.getElement("id").getValue()
										}
									}
								})
							],
							"sortable":true,
							"sort":"asc"
						})
						*/
						new GridCellHead(id+":grid:head:name_full",{
							"value":"ФИО",
							"columns":[
								new GridColumn({
									"field":model.getField("name_full")
								})
							]
						})						
						,new GridCellHead(id+":grid:head:attachment",{
							"value":"Скан",
							"columns":[
								new GridColumn({//Picture
									//"field":model.getField("attachment"),
									"cellOptions":function(column,row){
										var res = {};
										//var ins_id = this.m_model.getFieldValue("study_document_inserts_ref").getKey("id");
										var ins_id = this.m_model.getFieldValue("id");
										var ctrl = new ButtonCmd(null,{
											"glyph":"glyphicon-plus",
											"attrs":{"style": "margin-right: 10px;"},
											"caption":" Скан ",
											"title": "Добавить скан к сертификату",
											"onClick":(function(keyId){												
												return function(){
													self.addAttachment(this,keyId);
												}
											})(ins_id)
										});										
										ctrl.m_row = row;
										
										res.elements = [ctrl];
										var att = this.m_model.getFieldValue("attachment");
										if(att && CommonHelper.isArray(att) && att.length>0){
											res.elements.push(new Control(null,"IMG",{
												"attrs":{
													"src": "data:image/png;base64, "+att[0].dataBase64,
													"width": "50px",
													"height": "50px",
													"title": att[0]["name"]+" ("+CommonHelper.byteFormat(att[0]["size"],2)+")",
													"style":"cursor:pointer;"
												},
												"events":{
													"click":(function(keyId, fileId){
														return function(e){
															self.getAttachment(keyId, fileId);
														}
													})(ins_id, att[0].id)
												}
											}));
											
											//delete
											res.elements.push(new Control(null,"I",{
												"attrs":{
													"class":"glyphicon glyphicon-trash",
													//"glyphicon glyphicon-remove-circle",
													"title": "Удалить скан",
													"style":"cursor:pointer;"
												},
												"events":{
													"click":(function(keyId, fileId){
														return function(e){
															self.delAttachment(keyId, fileId);
														}
													})(ins_id, att[0].id)
												}
											}));
										}
										
										return res;
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
	}));	
	


}
extend(StudyDocumentInsertAttachmentList_View,ViewAjxList);

StudyDocumentInsertAttachmentList_View.prototype.getRefAsStr = function(id){
	return CommonHelper.serialize(new RefType({"dataType":"study_document_inserts", "keys": {"id": id}}));
}

StudyDocumentInsertAttachmentList_View.prototype.addAttachmentCont = function(btnCont, keyId, fl){
	//check type
	if(this.m_allowedFileExtList){
		//extension list
		var ext_ar = fl.name.split(".");
		if(!ext_ar.length || ext_ar.length<2){
			throw new Error(EditFile.prototype.ER_EXT_NOT_DEFINED);
		}
		if(CommonHelper.inArray(ext_ar[ext_ar.length-1].toLowerCase(),this.m_allowedFileExtList)==-1){
			throw new Error(CommonHelper.format(EditFile.prototype.ER_EXT_NOT_ALLOWED,ext_ar[ext_ar.length-1]));
		}
	}

	var pm = (new StudyDocumentAttachment_Controller).getPublicMethod("add_file");
	pm.setFieldValue("study_documents_ref", this.getRefAsStr(keyId));
	pm.setFieldValue("content_data", [fl]);
	pm.setFieldValue("content_info", CommonHelper.serialize({"id": CommonHelper.uniqid(), "name": fl.name, "size": 0}));
	window.setGlobalWait(true);
	btnCont.setEnabled(false);
	var self = this;
	pm.run({
		"ok":function(){
			self.getElement("grid").onRefresh();
			window.showTempNote("Скан сертификата загружен", null, 3000);
		},
		"all":function(){
			window.setGlobalWait(false);
			btnCont.setEnabled(true);
		}
	});
}

StudyDocumentInsertAttachmentList_View.prototype.addAttachment = function(btnCont, keyId){	
	var self = this;
	var fl = $('<input type="file"/>');
	fl.change(function(e) { 
		self.addAttachmentCont(btnCont, keyId, e.target.files[0])
	});
	fl.click();
}	

StudyDocumentInsertAttachmentList_View.prototype.getAttachment = function(keyId, fileId){
	var pm = (new StudyDocumentAttachment_Controller()).getPublicMethod("get_file");
	pm.setFieldValue("study_documents_ref", this.getRefAsStr(keyId));
	pm.setFieldValue("content_id", fileId);
	pm.setFieldValue("inline",1);	
	var offset = 0;
	var h = $( window ).width()/3*2;
	var left = $( window ).width()/2;
	var w = left - 20;	
	pm.openHref("ViewXML", "location=0,menubar=0,status=0,titlebar=0,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h);
	//pm.download();
}

StudyDocumentInsertAttachmentList_View.prototype.delAttachment = function(keyId, fileId){
	var self = this;
	WindowQuestion.show({
		"no":false,
		"text":"Удалить скан сертификата?",
		"callBack": function(){
			self.delAttachmentCont(keyId, fileId);
		}
	});
}

StudyDocumentInsertAttachmentList_View.prototype.delAttachmentCont = function(keyId, fileId){
	var pm = (new StudyDocumentAttachment_Controller()).getPublicMethod("delete_file");
	pm.setFieldValue("study_documents_ref", this.getRefAsStr(keyId));
	pm.setFieldValue("content_id", fileId);
	var self = this;
	pm.run({
		"ok":function(){
			self.getElement("grid").onRefresh();
			window.showTempNote("Скан сертификата удален", null, 3000);
		}
	});
}
