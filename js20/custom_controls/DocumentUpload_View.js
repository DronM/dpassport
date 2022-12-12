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
function DocumentUpload_View(id,options){
	options = options || {};	
	
	this.m_controllerId = options.controllerId;
	var self = this;
	options.addElement = function(){
		/*
		this.addElement(new ButtonCmd(id+":save_order",{
			"caption":"Сохранить настройки",
			"enabled": false,
			"onClick": function(){
				self.saveFieldOrder();
			}
		}));
		*/	
		//Analyze file button
		this.addElement(new Control(id+":analize_file","TEMPLATE", {
			"events":{
				"click": function(){
					var input = document.createElement("input");
					input.type = "file";
					input.onchange = function(e) { 
						var file = e.target.files[0]; 
						var ext_ar = file.name.split(".");
						if(!ext_ar.length || ext_ar.length<2){
							throw new Error("Расширение файла не найдено!");
						}
						if(ext_ar[ext_ar.length-1].toLowerCase() != "xlsx") {
							throw new Error("Неверное расширение файла!");
						}
						//
						DOMHelper.delNode(self.getId()+":PreviewGrid");
						DOMHelper.hide(self.getId()+":upload_ok_cont")
						DOMHelper.hide(self.getId()+":upload_er_cont")
						DOMHelper.delAllChildren(self.getId()+":upload_ok_cont");
						DOMHelper.setText("upload_er_text", "");
						self.m_file = undefined;
						
						window.setGlobalWait(true);
						self.getElement("analize_file").setEnabled(false);
						var pm = (new window[self.m_controllerId]()).getPublicMethod("analyze_excel");
						pm.setFieldValue("analyze_count", self.getElement("analyze_count").getValue());
						pm.setFieldValue("content_data", [file]);
						pm.run({
							//"viewId": "ExcelUploadPreview",
							"ok":function(resp){
								self.showPreview(resp.getModel("FileHeader_Model"), resp.getModel("FileContent_Model"));
								self.m_file = file;
							},
							"all":function(){
								self.getElement("analize_file").setEnabled(true);
								window.setGlobalWait(false);
							},
							"fail":function(resp,errCode,errStr){
								throw new Error(errStr);
							}
						});
					}
					input.click();					
				}
			}
		}));
		
		this.addElement(new EditNum(id+":analyze_count",{
			"enabled":false,
			"inline":true,
			"focus":true,
			"cmdClear":false,
			"attrs":{"style":"width:50px;"}
		}));			
		
		this.addElement(new ButtonCmd(id+":upload_file",{
			"caption": "Загрузить документы",
			"title":"Создать документы из файла Excel",
			"onClick": function(){
				self.uploadFile();
			}
		}));			

		this.addElement(new ClientEdit(id+":companies_ref",{
			"title":"Аттестующая организация, обязательное для заполнения поле.",
			"labelCaption":"*Компания:",
			"required": true,
			"cmdInsert": true,
			"cmdOpen": false,
			"cmdClear": false,
			"events":{
				"input": function(){
					if(DOMHelper.hasClass(this.getNode(), this.INCORRECT_VAL_CLASS)){
						this.setValid();
					}
				}
			}
		}));			

		this.addElement(new Control(id+":excel_template","TEMPLATE", {
			"events":{
				"click": function(){
					(new window[self.m_controllerId]()).getPublicMethod("get_excel_template").download("ViewXML");
				}
			}
		}));			

		this.addElement(new Control(id+":excel_error","TEMPLATE",{
			"events":{
				"click": function(){
					var pm = (new window[self.m_controllerId]()).getPublicMethod("get_excel_error");
					pm.setFieldValue("operation_id", self.m_operationId);
					pm.download("ViewXML");
				}
			}
		}));			
		
		this.addElement(new Control(id+":preview_grid_cont","DIV"));
	}
	
	DocumentUpload_View.superclass.constructor.call(this, id, options);
}

//ViewObjectAjx,ViewAjxList
extend(DocumentUpload_View, View);

/* Constants */


/* private members */

/* protected*/
DocumentUpload_View.prototype.m_controllerId;
DocumentUpload_View.prototype.m_previewCtrl;
DocumentUpload_View.prototype.m_file;
DocumentUpload_View.prototype.m_operationTimer;
DocumentUpload_View.prototype.m_operationEvent
DocumentUpload_View.prototype.m_operationId;

/* public methods */
DocumentUpload_View.prototype.toDOM = function(p){
	DocumentUpload_View.superclass.toDOM.call(this, p);
	
	var self = this;
	((new window[this.m_controllerId]()).getPublicMethod("get_analyze_count")).run({
		"ok":function(resp){
			var m = resp.getModel("AnalyzeCount_Model");
			if(m.getNextRow()){
				var ctrl = self.getElement("analyze_count");
				ctrl.setValue(m.getFieldValue("analyze_count"));
				ctrl.setEnabled(true);
			}
		}
	});
}


DocumentUpload_View.prototype.showPreview = function(headModel, rowModel){
	var tmpl_opts = {"HEADER": [], "ROWS": [],
		"FONT_SIZE": this.m_controllerId=="StudyDocument_Controller"? "70":"100",
		"HEADER_FONT_SIZE": this.m_controllerId=="StudyDocument_Controller"? "90":"120"		
	};
	
	while(headModel.getNextRow()){
		var req = headModel.getFieldValue("required");
		var descr = headModel.getFieldValue("descr");
		tmpl_opts.HEADER.push({
			"DESCR": descr? (req=="true"? "*":"") + ""+descr : "",
			"NAME": headModel.getFieldValue("name"),
			"MAX_LENGTH": headModel.getFieldValue("maxLength"),
			"REQUIRED": req,
			"DATA_TYPE": headModel.getFieldValue("dataType"),
			"COL_ID": CommonHelper.ID()
		});
	}
	while(rowModel.getNextRow()){
		var row = {"COL": []};
		for(i = 0; i < tmpl_opts.HEADER.length; i++){
			row.COL.push({"VAL": rowModel.getFieldValue("f"+i)})
		}
		tmpl_opts.ROWS.push(row);
	}
	
	var ctrl = new Control(this.getId()+":PreviewGrid", "TEMPLATE", {
		"template":window.getApp().getTemplate("ExcelUploadPreviewGrid"),
		"templateOptions":tmpl_opts
	})
	ctrl.toDOM(this.getElement("preview_grid_cont").getNode());
	
	var modal_n = DOMHelper.getParentByAttrValue(this.getNode(), "class", "modal-dialog");
	if(!modal_n){
		throw new Error("Node with modal-dialog class not found!");
	}
	
	var rect = modal_n.getBoundingClientRect();
	//drag && drop
	var th_list = (ctrl.getNode()).getElementsByTagName("th");
	if(!th_list || !th_list.length)return;
	for(var i=0; i< th_list.length; i++){
		th_list[i].m_drag = new DragObject(th_list[i], {"offsetY":  rect.top + th_list[i].clientHeight, "offsetX": rect.left});
		th_list[i].m_drop = new DropTarget(th_list[i]);
		th_list[i].m_drop.accept = (function(){
			return function(dragObject) {
				console.log("dragObject=",dragObject.element.getAttribute("id"))
				console.log("drop=",this.element.getAttribute("id"))
				
				var drop_descr = this.element.textContent;
				var drop_name = this.element.getAttribute("field_id");
				var drop_data_type = this.element.getAttribute("data_type");
				var drop_max_length = this.element.getAttribute("max_length");
				var drop_id = this.element.getAttribute("id");
				this.element.textContent = dragObject.element.textContent;
				this.element.setAttribute("field_id", dragObject.element.getAttribute("field_id"));
				this.element.setAttribute("id", dragObject.element.getAttribute("id"));
				this.element.setAttribute("data_type", dragObject.element.getAttribute("data_type"));
				this.element.setAttribute("max_length", dragObject.element.getAttribute("max_length"));
				
				dragObject.element.textContent = drop_descr;
				dragObject.element.setAttribute("field_id", drop_name);
				dragObject.element.setAttribute("id", drop_id);
				dragObject.element.setAttribute("data_type", drop_data_type);
				dragObject.element.setAttribute("max_length", drop_max_length);
			}
		})();
	}
	
	DOMHelper.show(this.getId()+":uploadCmd");
	//this.getElement("save_order").setEnabled(true);	
}

DocumentUpload_View.prototype.onOperationEnd = function(model){
	if(this.m_operationTimer){
		clearInterval(this.m_operationTimer);
	}
	this.unsubscribeFromSrvEvents();
	
	if(model && model.getNextRow()){	
		var er = model.getFieldValue("error_text");
		var cmt = model.getFieldValue("comment_text");
		if(er && er.length && !model.getFieldValue("file_content_exists")){
			throw new Error(er);
			
		}else if(er && er.length && model.getFieldValue("file_content_exists")){
			if(cmt && cmt.length){
				window.getApp().addTextToCont(this.getId(), "upload_ok_cont", cmt);
			}
			
			DOMHelper.setText(this.getId()+":upload_er_text", er);
			DOMHelper.show(this.getId()+":upload_er_cont");
			
		}else{
			//del preview
			DOMHelper.delNode(document.getElementById(this.getId()+":PreviewGrid"));
			this.m_file = undefined;
			
			DOMHelper.hide(this.getId()+":uploadCmd");
			//this.getElement("save_order").setEnabled(false);	
			
			window.getApp().addTextToCont(this.getId(), "upload_ok_cont", cmt);
		}
	}
}

DocumentUpload_View.prototype.delDOM = function(){
	DocumentUpload_View.superclass.delDOM.call(this);
	this.clearOperation();
}

DocumentUpload_View.prototype.clearOperation = function(){
	if(!this.m_operationId){
		return;
	}
	var self = this;
	var pm = (new UserOperation_Controller()).getPublicMethod("delete");
	pm.setFieldValue("operation_id", this.m_operationId);
	pm.setFieldValue("user_id", window.getApp().getServVar("user_id"));
	pm.run();
}

DocumentUpload_View.prototype.setRefreshOperation = function(){
	var self = this;
	var pm = (new UserOperation_Controller()).getPublicMethod("get_object");
	pm.setFieldValue("operation_id", this.m_operationId);
	pm.setFieldValue("user_id", window.getApp().getServVar("user_id"));
	this.m_operationTimer = setInterval(function(){
		pm.run({
			"ok":function(resp){
				self.onOperationEnd(resp.getModel("UserOperationDialog_Model"));
			}
		})
	}, 2000);
}

DocumentUpload_View.prototype.uploadFileCont = function(){
	var srv = window.getApp().getAppSrv();
	if(srv && srv.connActive()){
		var self = this;
		
		this.unsubscribeFromSrvEvents();
		this.subscribeToSrvEvents({
			"events":[
				{"id":"UserOperation."+CommonHelper.md5(window.getApp().getServVar("user_id")+this.m_operationId)}
			]
			,"onEvent":function(json){
				var pm = (new UserOperation_Controller()).getPublicMethod("get_object");
				pm.setFieldValue("operation_id", json.params.operation_id);
				pm.setFieldValue("user_id", window.getApp().getServVar("user_id"));
				pm.run({
					"ok":function(resp){
						self.onOperationEnd(resp.getModel("UserOperationDialog_Model"));
					}
				});				
			}
			,"onClose": function(error){
				self.setRefreshOperation();
			}
			,"onSubscribed":function(error){
				if(self.m_operationTimer){
					clearInterval(self.m_operationTimer);
				}
			}
		});		
	}else{
		//query on timer
		if(this.m_operationTimer){
			clearInterval(this.m_operationTimer);
		}
		this.setRefreshOperation();
	}
}

DocumentUpload_View.prototype.getFieldOrder = function(){
	var grid_n = document.getElementById(this.getId()+":PreviewGrid");
	if(!grid_n)return
	var th_list = grid_n.getElementsByTagName("th");
	if(!th_list || !th_list.length)return;
	var field_order = {};
	for(var i=0; i < th_list.length; i++){		
		var field_id = th_list[i].getAttribute("field_id");
		if(field_id && field_id.length){
			var descr = DOMHelper.getText(th_list[i]);
			if(descr.substr(0,1) == "*"){
				descr = descr.substr(1);
			}
			field_order[field_id] = {
				"ind": i,
				"name": field_id,
				"descr": descr,
				"dataType": th_list[i].getAttribute("data_type"),
				"maxLength": parseInt(th_list[i].getAttribute("max_length"), 10),
				"required": (th_list[i].getAttribute("required")=="true"),
			};
		}
	}
	return field_order;
}

DocumentUpload_View.prototype.uploadFile = function(){
	if(!this.m_file){
		throw new Error("Файл не определен!");
	}
	var field_order = this.getFieldOrder();
	if(!field_order){
		return;
	}
	
	var cl_ref = this.getElement("companies_ref").getValue();
	if(!cl_ref || cl_ref.isNull()){
		this.getElement("companies_ref").setNotValid("Не заполнено");
		return;
	}
	
//console.log("field_order=", CommonHelper.serialize(field_order))
//return;
	window.setGlobalWait(true);
	this.getElement("analize_file").setEnabled(false);
	
	DOMHelper.hide(this.getId()+":uploadCmd");
	DOMHelper.hide(this.getId()+":upload_ok_cont")
	DOMHelper.hide(this.getId()+":upload_er_cont")
	
	//this.getElement("save_order").setEnabled(false);
	
	//actual field order
	var self = this;
	var pm = (new window[this.m_controllerId]()).getPublicMethod("upload_excel");
	pm.setFieldValue("analyze_count", this.getElement("analyze_count").getValue());
	pm.setFieldValue("field_order", CommonHelper.serialize(field_order));
	pm.setFieldValue("company_id", cl_ref.getKey("id"));
	pm.setFieldValue("content_data", [this.m_file]);
	pm.run({
		"ok":function(resp){
			var m = resp.getModel("UserOperation_Model");
			if(m && m.getNextRow()){
				//subscribe to events
				self.m_operationId = m.getFieldValue("operation_id");
				self.uploadFileCont();
			}
		},
		"all":function(){
			self.getElement("analize_file").setEnabled(true);
			//DOMHelper.show(self.getId()+":uploadCmd");
			//self.getElement("save_order").setEnabled(true);
			window.setGlobalWait(false);
		}
	});	
}

DocumentUpload_View.prototype.saveFieldOrder = function(){
	var field_order = this.getFieldOrder();
	if(!field_order){
		return;
	}
	
	var self = this;
	var pm = (new window[this.m_controllerId]()).getPublicMethod("save_field_order");
	pm.setFieldValue("analyze_count", this.getElement("analyze_count").getValue());
	pm.setFieldValue("field_order", CommonHelper.serialize(field_order));
	pm.run({
		"ok":function(resp){
			window.showTempNote("Настройки сохранены",null, 3000);
		},
		"all":function(){
			self.getElement("analize_file").setEnabled(true);
			DOMHelper.show(self.getId()+":uploadCmd");
			//self.getElement("save_order").setEnabled(true);
			window.setGlobalWait(false);
		}
	});
	
}

