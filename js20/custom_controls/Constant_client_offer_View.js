/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends EditJSON
 * @requires core/extend.js
 * @requires controls/EditJSON.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function Constant_client_offer_View(id,options){

	options = options || {};
	
	options.className = options.className || "form-group";
	
	var self = this;

	options.addElement = function(){
		//********* fields grid ***********************
		var model = new ReportTemplateField_Model();
	
		var grid = new GridAjx(id+":fields",{
			"model":model,
			"keyIds":["id"],
			"controller":new ReportTemplateField_Controller({"clientModel":model}),
			"editInline":true,
			"editWinClass":null,
			"popUpMenu":new PopUpMenu(),
			"commands":new GridCmdContainerAjx(id+":fields:cmd",{
				"cmdSearch":false,
				"cmdExport":false
			}),
			"head":new GridHead(id+":fields:head",{
				"elements":[
					new GridRow(id+":fields:head:row0",{
						"elements":[
							new GridCellHead(id+":fields:head:id",{
								"value":"Идентификатор",
								"columns":[
									new GridColumn({
										"field":model.getField("id"),
										"ctrlClass":EditString,
										"maxLength":"50",
										"ctrlOptions":{
											"required":true
										}
																										
									})
								]
							}),					
							new GridCellHead(id+":fields:head:descr",{
								"value":"Описание",
								"columns":[
									new GridColumn({
										"field":model.getField("descr"),
										"ctrlClass":EditString,
										"maxLength":"250",
										"ctrlOptions":{
											"required":true
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
			"refreshInterval":0,
			"rowSelect":true,
			"focus":true		
		});
		//!!!
		grid.getValue = function(){	
			if (this.m_model){
				return this.m_model.getData();
			}
		}
		this.addElement(grid);

	
		this.addElement(new EditText(id+":contract",{
			"title":"Договор с контрагентом",
			"labelCaption":"Договор с контрагентом"
		}));

	}	
	Constant_client_offer_View.superclass.constructor.call(this,id,options);
	
}
extend(Constant_client_offer_View, EditJSON);

/* Constants */


/* private members */

/* protected*/


/* public methods */

