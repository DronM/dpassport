/** Copyright (c) 2022
 *	Andrey Mikhalevich, Katren ltd.
 */
function ClientAccessList_View(id,options){	

	options = options || {};
	options.HEAD_TITLE = "Доступы площадок";

	ClientAccessList_View.superclass.constructor.call(this,id,options);
	
	var model = (options.models && options.models.ClientAccessList_Model)? options.models.ClientAccessList_Model : new ClientAccessList_Model();
	var contr = new ClientAccess_Controller();
	
	var constants = {"doc_per_page_count":null,"grid_refresh_interval":null};
	window.getApp().getConstantManager().get(constants);
	
	var popup_menu = new PopUpMenu();
	var pagClass = window.getApp().getPaginationClass();
	
	var r = window.getApp().getServVar("role_id");
	var adm1 = (r=="client_admin1" || r=="admin");
	
	var self = this;
	this.addElement(new GridAjx(id+":grid",{
		"model":model,
		"controller":contr,
		"editInline":true,
		"editWinClass":null,
		"commands":new GridCmdContainerAjx(id+":grid:cmd",{
			"cmdInsert": adm1,
			"cmdEdit": adm1,
			"cmdDelete": adm1,
			"exportFileName" :"Доступы"
		}),		
		"popUpMenu":popup_menu,
		"head":new GridHead(id+"-grid:head",{
			"elements":[
				new GridRow(id+":grid:head:row0",{
					"elements":[
						new GridCellHead(id+":grid:head:date_from",{
							"value":"Период с",
							"columns":[
								new GridColumnDate({
									"field":model.getField("date_from"),
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							]
						}),
						new GridCellHead(id+":grid:head:date_to",{
							"value":"Период по",
							"columns":[
								new GridColumnDate({
									"field":model.getField("date_to"),
									"ctrlOptions":{
										"labelCaption":""
									}
								})
							],
							"sortable":true,
							"sort":"desc"
						}),
						
						new GridCellHead(id+":grid:head:doc_1c_ref",{
							"value":"Документ 1с",
							"columns":[
								new GridColumn({
									//"field":model.getField("doc_1c_ref"),
									"ctrlEdit": false,
									"formatFunction":function(fields, cell){
										self.formatDoc1c(fields, cell);
									}
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
	

	this.m_queryId = CommonHelper.uniqid();
	//async
	var srv = window.getApp().getAppSrv();
	var self = this;
	if(srv){
		srv.subscribe({
			"events":[
				{"id":"Server1C.makeOrder_"+this.m_queryId}
			]
			,"onEvent":function(json){
				if(json.params.res!=undefined && json.params.res===true){
					self.getElement("grid").onRefresh(function(){
						window.showTempNote("Создан счет в 1с",null,5000);
					});
				}else if(json.params.res!=undefined && json.params.res===false && typeof(json.params.descr)=="string"){
					window.showTempError(json.params.descr,null,10000);					
					
				}else{
					window.showTempError("Ошибка создания счета",null,10000);					
				}
				if(self.m_orderCtrl){
					self.m_orderCtrl.setEnabled(true);
				}
			}	
		});
	}
}
extend(ClientAccessList_View,ViewAjxList);

ClientAccessList_View.prototype.makeOrder = function(clientAccessId, ctrl){	
	var self = this;	
	var pm = (new ClientAccess_Controller()).getPublicMethod("make_order");
	pm.setFieldValue("client_access_id", clientAccessId);	
	pm.setFieldValue("q_id", this.m_queryId);
	pm.run({
		"ok":function(){
			ctrl.setEnabled(false);
			self.m_orderCtrl = ctrl;
			window.showTempNote("Запрос на формирование счета отправлен",null,3000);					
		}
	});	
}

ClientAccessList_View.prototype.openOrder = function(clientAccessId){
	//open pdf in new window
	var pm = (new ClientAccess_Controller()).getPublicMethod("get_order_print");
	pm.setFieldValue("client_access_id", clientAccessId);
	pm.setFieldValue("q_id", CommonHelper.uniqid());
	//pm.setFieldValue("inline",1);
	var offset = 0;
	var h = $( window ).width()/3*2;
	var left = $( window ).width()/2;
	var w = left - 20;
	pm.openHref("ViewXML", "location=0,menubar=0,status=0,titlebar=0,popup=1,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h, "orderPrint");	
}

ClientAccessList_View.prototype.formatDoc1c = function(fields, cell){
	var v = fields.doc_1c_ref.getValue();
	var cell_n = cell.getNode();
	var self = this;
	if(!v || !v["ref"]){
		cell_n.setAttribute("title", "Счет не выписывался.");
		(new ButtonCmd(null,{
			"caption":"Выписать счет",
			"title":"Выписать счет в 1с",
			"attrs":{"client_access_id": fields.id.getValue()},
			"onClick":function(){
					self.makeOrder(this.getAttr("client_access_id"), this);
				}
			})
		).toDOM(cell_n);
	}else{
		
		var a = document.createElement("A");
		a.setAttribute("href","#");
		a.textContent = v["descr"];
		var a_class = "doc_ref_1c";
		if(v["payed"] != true){
			a_class+= " doc_ref_1c_not_payed";
			a.setAttribute("title", "Ожидание оплаты. Кликните для откытия печатной формы счета.");
		}else{
			a.setAttribute("title", "Оплачен. Кликните для откытия печатной формы счета.");
		}
		a.setAttribute("class", a_class);
		a.setAttribute("client_access_id", fields.id.getValue());
		EventHelper.add(a,"click", function(e){
				e.preventDefault();
				var id = e.target.getAttribute("client_access_id");
				self.openOrder(id);
			}
		);
		cell_n.appendChild(a);		
	}
}


