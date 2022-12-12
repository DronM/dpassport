/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends GridAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 * @param {string} options.className
 */
function Constant_study_document_register_fields_Grid(id,options){
	options = options || {};
	var model = new Constant_study_document_register_fields_Model({
		//"sequences":{"id":0},
		"simpleStructure": true
	});

	CommonHelper.merge(options,
	{	
		"model":model,
		"keyIds":["name"],
		"controller":new Constant_study_document_register_fields_Controller({"clientModel":model}),
		"editInline":true,
		"editWinClass":null,
		"inlineInsertPlace":"last",
		"popUpMenu":new PopUpMenu(),
		"commands":new GridCmdContainerAjx(id+":cmd",{
			"addCustomCommandsBefore":function(commands){
				commands.push(new GridCmdRowUp(id+":grid:cmd:rowUp",{"showCmdControl":true}));
				commands.push(new GridCmdRowDown(id+":grid:cmd:rowDown",{"showCmdControl":true}));
			},		
			"cmdInsert":false,
			"cmdEdit":true,
			"cmdSearch":false,
			"cmdExport":false
		}),
		"head":new GridHead(id+":head",{
			"elements":[
				new GridRow(id+":head:row0",{
					"elements":[
						new GridCellHead(id+":head:descr",{
							"value":"Представление",
							"columns":[
								new GridColumn({
									"field":model.getField("descr"),
									"ctrlClass":EditString
									,"ctrlBindFieldId":"descr"
								})							
							]
						})
						,new GridCellHead(id+":head:dataType",{
							"value":"Тип данных",
							"columns":[
								new GridColumn({
									"field":model.getField("dataType"),
									"ctrlClass":EditString
									,"ctrlBindFieldId":"dataType"
								})							
							]
						})
						
						,new GridCellHead(id+":head:maxLength",{
							"value":"Макс.длина",
							"columns":[
								new GridColumn({
									"field":model.getField("maxLength"),
									"ctrlClass":EditInt
									,"ctrlBindFieldId":"maxLength"
								})							
							]
						})
						,new GridCellHead(id+":head:required",{
							"value":"Обязательный",
							"columns":[
								new GridColumnBool({
									"field":model.getField("required"),
									"ctrlClass":EditCheckBox
									,"ctrlBindFieldId":"required"
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
		"rowSelect":true
	});
	
	Constant_study_document_register_fields_Grid.superclass.constructor.call(this,id,options);
}
extend(Constant_study_document_register_fields_Grid, GridAjx);

/* Constants */


/* private members */

/* protected*/


/* public methods */
Constant_study_document_register_fields_Grid.prototype.getValue = function(){	
	if (this.m_model){
		return this.m_model.getData();
	}
}

