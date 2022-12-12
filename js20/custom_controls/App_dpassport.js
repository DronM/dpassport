/**
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022
 
 * @class
 * @classdesc
	
 * @param {object} options
 */	
function App_dpassport(options){
	options = options || {};
	options.lang = "ru";
	options.paginationClass = Pagination;
	
	App_dpassport.superclass.constructor.call(this,"dpassport",options);	
}
extend(App_dpassport,App);

/* Constants */
App_dpassport.prototype.SERV_RESPONSE_MODEL_ID = "Response";
App_dpassport.prototype.EVENT_MODEL_ID = "Event";
App_dpassport.prototype.INSERTED_KEY_MODEL_ID = "InsertedKey";

/* private members */

/* protected*/


/* public methods */
App_dpassport.prototype.getSidebarId = function(){
	return this.getServVar("user_name")+"_"+"sidebar-xs";
}
App_dpassport.prototype.toggleSidebar = function(){
	var id = this.getSidebarId();
	this.storageSet(id,(this.storageGet(id)=="xs")? "":"xs");
}


App_dpassport.prototype.makeItemCurrent = function(elem){
	if (elem){		
		var l = DOMHelper.getElementsByAttr("active", document.body, "class", false, "LI");
		for(var i=0; i < l.length; i++){
			//DOMHelper.delClass(l[i], "active");
			//groups!!!						
			var ch_l = DOMHelper.getElementsByAttr("has-ul", l[i], "class", true, "A");
			if(!ch_l || !ch_l.length){
				//not a group
				DOMHelper.delClass(l[i], "active");
			}
		}
		var it = (elem.tagName.toUpperCase()=="LI")? elem:elem.parentNode;
		DOMHelper.addClass(it, "active");
		/*if (elem.nextSibling){
			elem.nextSibling.style="display: block;";
		}*/
		var p = DOMHelper.getParentByTagName(it, "LI");
		if(p && !DOMHelper.hasClass(p, "active")){
			DOMHelper.addClass(p, "active");
			var ch_l = DOMHelper.getElementsByAttr("hidden-ul", p, "class", true, "UL");
			if(ch_l && ch_l.length){
				ch_l[0].style="display: block;";
			}
		}
	}
}

App_dpassport.prototype.showMenuItem = function(item,c,f,t,extra,title){
	App_dpassport.superclass.showMenuItem.call(this,item,c,f,t,extra,title);
	this.makeItemCurrent(item);
}

App_dpassport.prototype.formatError = function(erCode,erStr){
	return (erStr +( (erCode)? (", код:"+erCode):"" ) );
}

App_dpassport.prototype.addTextToCont = function(viewId, elemId, txt){
	var cont = document.getElementById(viewId+":"+elemId);
	DOMHelper.delAllChildren(cont);
	var p = document.createElement("p");
	p.append(txt);
	cont.append(p);
	DOMHelper.show(cont);
}

App_dpassport.prototype.addLastUpdateToGridFilter = function(id, filters){
	var last_update = new EditPeriodDateTime(id+":filter-ctrl-last_update",{
		"labelCaption":"Период последнего изменения:",
		"cmdDownFast": false,
		"cmdDown": false,
		"cmdUp": false,
		"cmdUpFast": false,
		"controlCmdClear": false,
		"field":new FieldDateTime("last_update")			
	});

	filters.last_update = {
			"binding":new CommandBinding({
				"control":last_update,
				"field":last_update.getField()
			}),
			"bindings":[
				{"binding":new CommandBinding({
					"control":last_update.getControlFrom(),
					"field":last_update.getField()
					}),
				"sign":"ge"
				},
				{"binding":new CommandBinding({
					"control":last_update.getControlTo(),
					"field":last_update.getField()
					}),
				"sign":"le"
				}
			]
	};
	filters.last_update_user = {
			"binding":new CommandBinding({
				"control":new EditString(id+":filter-ctrl-last_update_user",{
					"contClassName":"form-group-filter",
					"labelCaption":"Последний изменявший пользователь:",
				}),
			"field": new FieldString("last_update_user")}),
			"sign": "lk",
			"icase": "1",
			"lwcards": true,
			"rwcards": true
	};
}

//*********
App_dpassport.prototype.gridOnBatchDelete = function(grid, ids, callBack){	
	var res = false;
	if (grid.m_cmdDelete){
		var self = this;
		grid.setFocused(false);
		WindowQuestion.show({
			"cancel":false,
			"text": "Удалить строки ("+ids.length+")?",
			"callBack":function(r){
				if (r==WindowQuestion.RES_YES){
					self.gridOnBatchDeleteCont(grid, ids, callBack);
				}else{
					grid.focus();	
				}
				if(callBack){
					callBack(r);
				}
			}
		});	
		res = true;
	}
	return res;
}

App_dpassport.prototype.gridOnBatchDeleteCont = function(grid, keys, callBack){
	var pm = grid.getDeletePublicMethod().getController().getPublicMethod("batch_delete");
	if (!pm){
		throw Error(grid.ER_NO_DEL_PM);
	}
	pm.setFieldValue("keys", keys);
	grid.setEnabled(false);
	pm.run({
		"ok":function(){
			grid.setEnabled(true);
			grid.onRefresh(callBack);
		}
		,"all":function(){			
			grid.setEnabled(true);
			grid.focus();
		}
	});
}

App_dpassport.prototype.gridOnBatchEdit = function(grid, contrId, modelId, keys, noCopyFields, onSubmit){
	grid.setLocked(true);
	grid.unbindPopUpMenu();

	//удалить все строки
	//создать новую форму во все поля со всеми строками в режиме редактирования + ОК для запуска коллективного update	
	var contr = new window[contrId]();
	var pm = contr.getPublicMethod("get_list");
	var cond_fields = "", cond_vals = "", cond_sgns="", cond_joins = "";
	for(var i=0; i < keys.length; i++){
		if(i>0){
			cond_fields+= contr.PARAM_FIELD_SEP_VAL;
			cond_vals+= contr.PARAM_FIELD_SEP_VAL;
			cond_joins+= contr.PARAM_FIELD_SEP_VAL;
			cond_sgns+= contr.PARAM_FIELD_SEP_VAL;
		}
		cond_fields+= "id";
		cond_vals+= keys[i].id;
		cond_joins+= contr.PARAM_JOIN_OR;
		cond_sgns+= contr.PARAM_SGN_EQUAL;
	}
	pm.setFieldValue("cond_fields", cond_fields);
	pm.setFieldValue("cond_vals", cond_vals);
	pm.setFieldValue("cond_joins", cond_joins);
	pm.setFieldValue("cond_sgns", cond_sgns);
	pm.setFieldValue("field_sep", contr.PARAM_FIELD_SEP_VAL);
	
	grid.orderingToMethod(pm);
	
	var self = this;
	pm.run({
		"ok":function(resp){
			self.gridOnBatchEditCont(grid, resp.getModel(modelId), noCopyFields, onSubmit);
		}
		,"fail":function(resp,errCode,errStr){
			grid.setLocked(false);
			grid.bindPopUpMenu();
			throw new Error(errStr);
		}
	});
}

App_dpassport.prototype.gridOnBatchEditCont = function(grid, model, noCopyFields, onSubmit){
	//create new structure and append it to grid body
	var b = grid.getBody();
	b.clear();
	b.toDOM();
		
	var columns = grid.getHead().getColumns();
	var r_ind = 0;
	while(model.getNextRow()){
		var row_id = model.getFieldValue("id") ;
		var cols = [];
		var c_ind = 0;
		
		for (var col_id = 0; col_id < columns.length; col_id++){
			var ctrl;
			if(!columns[col_id].getCtrlEdit()){
				ctrl = new Control(null, "DIV");
			}else{
				var col_cl = columns[col_id].getCtrlClass();

				if(!col_cl){
					col_cl = EditString;
				}
				var opts = columns[col_id].getCtrlOptions()||{};
				if(col_cl == ClientEdit
				|| col_cl == StudyTypeEdit
				|| col_cl == ProfessionEdit
				|| col_cl == QualificationEdit
				){
					var edit_frm;
					if(col_cl == ClientEdit){
						edit_frm = ClientList_Form;
					}else if(col_cl == StudyTypeEdit){
						edit_frm = StudyTypeList_Form;
					}else if(col_cl == ProfessionEdit){
						edit_frm = ProfessionList_Form;
					}else if(col_cl == QualificationEdit){
						edit_frm = QualificationList_Form;
					}
					opts.attrs = opts.attrs || {};
					opts.attrs.style = opts.attrs.style || "";
					opts.attrs.style += "cursor:pointer;";
					opts.events = {
						"click":(function(r, c, grid, eForm){
							return function(){
								var win_opts = {app: window.getApp()};
								win_opts.onClose = (function(cont){
									return function(){
										cont.m_winObj.close();
										delete cont.m_winObj;	
									};
								})(this);
								this.m_winObj = new eForm(win_opts);
								var win = this.m_winObj.open();
								win.onSelect = (function(cont){
									return function(fields){
										var row = grid.getBody().getElement("r-"+r);
										var ctrl = row.getElement("c-"+c).getElement("ctrl");
										ctrl.setKeys({"id": fields.id.getValue()});
										ctrl.m_node.value = fields.name.getValue(); 
										cont.m_winObj.close();
										
										//all following nodes
										r++;
										row = grid.getBody().getElement("r-"+r);										
										while(row){
											var col = row.getElement("c-"+c);
											if(!col)break;
											var ctrl = col.getElement("ctrl");
											if(!ctrl)break;
											ctrl.setKeys({"id": fields.id.getValue()});
											ctrl.m_node.value = fields.name.getValue(); 
											
											r++;
											row = grid.getBody().getElement("r-"+r);
										}										
									}
								})(this);
								
							}
						})(r_ind, c_ind, grid, edit_frm)
					}
				}
				
				opts["name"] = "ctrl";
				ctrl = new col_cl(grid.getId()+":grid:r-"+r_ind+":c-"+c_ind+":ctrl", opts);
				ctrl.setInitValue(model.getFieldValue(columns[col_id].getField().getId()));
				var f_id = columns[col_id].getField().getId();
				
				if(!noCopyFields ||
					(noCopyFields.find && !noCopyFields.find(
						function(v){
							return (v == f_id);
						})
					)
				){
					EventHelper.add(ctrl.getNode(), "input",
						(function(grid){
							return function(e){
								var tr = DOMHelper.getParentByTagName(e.target, "TR");
								if(!tr)return;
								var td = DOMHelper.getParentByTagName(e.target, "TD");
								if(!td)return;
								
								var r_ind = tr.getAttribute("name").substr(2);
								var c_ind = td.getAttribute("name").substr(2);
								var row = grid.getBody().getElement("r-"+r_ind);
								var col = row.getElement("c-"+c_ind);
								//var cur_val = col.getElement("ctrl").getValue();
								
								r_ind++;
								row = grid.getBody().getElement("r-"+r_ind);
								while(row){
									var col = row.getElement("c-"+c_ind);
									if(!col)break;
									var ctrl = col.getElement("ctrl");
									if(!ctrl)break;
									//ctrl.setValue(cur_val);
									ctrl.getNode().value = e.target.value;
									
									r_ind++;
									row = grid.getBody().getElement("r-"+r_ind);
								}
								
							}						
						})(grid)
					);
				}
			}
			cols.push(new ControlContainer(grid.getId()+":grid:r-"+r_ind+":c-"+c_ind, "TD",{
				"attrs": {"class": "noPadding"},
				"elements": [ctrl],
				"visible":columns[col_id].getHeadCell().getVisible()
			}))
			c_ind++;
		}
		var tr = new ControlContainer(grid.getId()+":grid:r-"+r_ind, "TR",{
			"elements": cols
		});
		tr.m_rowID = row_id;
		b.addElement(tr);
		r_ind++;
	}
	//+submit row
	var self = this;
	b.addElement(new ControlContainer(null, "TR",{
		"elements": [
			new ControlContainer(null, "TD",{
				"attrs":{"colspan": columns.length},
				"elements":[
					new ButtonOK(null, {
						"onClick": function(){
							if(onSubmit){
								onSubmit(grid);
							}else{
								self.gridOnBatchEditSubmit(grid);
							}
						}
					})
					,new ButtonCmd(null, {
						"caption":"Отмена",
						"onClick": function(){
							grid.closeEditView({"updated":true});
						}
					})
				]
			})
		]
	}));
	b.toDOM();
}

//fills ob with objects, returns {bool} errors
App_dpassport.prototype.gridOnBatchEditFetchObjects = function(grid, ob, oldKeys){	
	var columns = grid.getHead().getColumns();
	var rows = grid.getBody().getElements();
	var errors = false;
	
	for(var i in rows){
		var cols = rows[i].getElements();
		var c_in = 0;
		var do_add = false;
		var old_key = {"old_id": rows[i].m_rowID};
		var o = old_key;
		for(var k in cols){
			var f = columns[c_in].getField();
			if(f){
				var ctrl = cols[k].getElement("ctrl");
				if(ctrl && ctrl.getModified()){
					var v = ctrl.getValue();
					if(ctrl.getIsRef && ctrl.getIsRef()){
						o[columns[c_in].getCtrlBindFieldId()] = v.getKey("id");
						do_add = true;
					}else{
						try{
							f.setValue(v);
							var f_id = f.getId();
							o[f_id] = f.getValueXHR();
							do_add = true;
						}catch(e){
							ctrl.setNotValid(e.message);
							errors = true;
						}
					}
				}
			}
			c_in++			
		}
		if(rows[i].m_rowID && oldKeys){
			oldKeys.push(old_key);
		}
		
		if(do_add){
			ob.push(o);
		}
	}
	return errors;
}

App_dpassport.prototype.gridOnBatchEditSubmit = function(grid){
	var ob = [];
	var errors = this.gridOnBatchEditFetchObjects(grid, ob);
	if(!errors && ob.length){
		var pm = grid.getReadPublicMethod().getController().getPublicMethod("batch_update");	
		pm.setFieldValue("objects", ob);
		pm.run({
			"ok":function(){
				grid.closeEditView({"updated":true});
			}
		});
		
	}else if (!errors){
		grid.closeEditView({"updated":true});
	}	
}

//
App_dpassport.prototype.clientEditAccess = function(){
	return this.isAdmin();
}
App_dpassport.prototype.isAdmin = function(){
	var r = this.getServVar("role_id");
	return (r == "admin" || r == "client_admin1");
}

App_dpassport.prototype.getCompanyRef = function(){
	return (new RefType({"keys": {"id": this.getServVar("company_id")}, "descr": this.getServVar("company_descr")}));
}
	
App_dpassport.prototype.splitNameOnPaste = function(e){	
	var v = (e.clipboardData || window.clipboardData).getData('text');
	if(!v || v.length<5){
		return;
	}
	e.preventDefault();
	var names = [0,0];
	//a a a
	v_parts = v.split(" ");
	if(v_parts.length > 1){
		e.target.value = (v_parts[0].length>1)?
			v_parts[0][0].toUpperCase()+v_parts[0].substring(1) : v_parts[0];
	}
	if(v_parts.length >= 2){
		names[0] =
			(v_parts[1].length>1)?
			v_parts[1][0].toUpperCase()+v_parts[1].substring(1) : v_parts[1]
		;
	}
	if(v_parts.length >= 3){
		names[1] =
			(v_parts[2].length>1)?
			v_parts[2][0].toUpperCase()+v_parts[2].substring(1) : v_parts[2]
		;														
	}
	return names;													
}	
