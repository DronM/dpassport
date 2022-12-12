/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends ViewObjectAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function StudyDocumentInsertDialog_View(id,options){	

	options = options || {};
	
	options.cmdSave = false;
	options.model = (options.models&&options.models.StudyDocumentInsertList_Model)? options.models.StudyDocumentInsertList_Model : new StudyDocumentInsertList_Model();
	options.controller = options.controller || new StudyDocumentInsert_Controller();
	
	var self = this;
	options.addElement = function(){
	
		this.addElement(new EditDate(id+":issue_date",{
			"labelCaption": "Дата выдачи",
			"cmdClear":false
		}));	
		this.addElement(new EditDate(id+":end_date",{
			"labelCaption": "Дата окончания",
			"cmdClear":false
		}));	

		this.addElement(new EditSNILS(id+":snils",{
			"required":false,
		}));			

		this.addElement(new EditString(id+":series",{
			"required":false,
			"labelCaption":"Серия:",
			"maxLength":"50"
		}));			
		this.addElement(new EditString(id+":number",{
			"labelCaption": "Регистрационный номер:",
			"maxLength":50,
			"cmdClear":false,
			"maxLength":"50"
		}));	
		
		this.addElement(new EditString(id+":study_prog_name",{
			"required":false,
			"labelCaption":"Наименование программы:",
			"maxLength":"1000"
		}));		

		this.addElement(new EditNum(id+":study_period",{
			"required":false,
			"labelCaption":"Период обучения:"
		}));		

		this.addElement(new EditString(id+":post",{
			"required":false,
			"labelCaption":"Аттестуемая должность:"
		}));		
		this.addElement(new EditString(id+":work_place",{
			"required":false,
			"labelCaption":"Место работы:"
		}));		
		this.addElement(new EditString(id+":organization",{
			"required":false,
			"labelCaption":"Аттестуемая организация:"
		}));		
		this.addElement(new EditString(id+":study_type",{
			"required":false,
			"labelCaption":"Вид обучения:"
		}));		
		this.addElement(new EditString(id+":profession",{
			"required":false,
			"labelCaption":"Наименование профессии (для заполнения ФИСФРДО):"
		}));		
		this.addElement(new EditString(id+":reg_number",{
			"required":false,
			"labelCaption":"Регистрационный номер документа:"
		}));		
		this.addElement(new EditString(id+":qualification_name",{
			"required":false,
			"labelCaption":"Наименование квалификации:"
		}));		
		this.addElement(new EditString(id+":name_first",{
			"required":false,
			"labelCaption":"Имя:"
		}));		
		this.addElement(new EditString(id+":name_second",{
			"required":false,
			"labelCaption":"Фамилия:"
		}));		
		this.addElement(new EditString(id+":name_middle",{
			"required":false,
			"labelCaption":"Отчество:"
		}));		
			
	}
	
	ClientDialog_View.superclass.constructor.call(this,id,options);
	
	//****************************************************	
	
	//read
	var read_b = [
		new DataBinding({"control":this.getElement("snils")})
		,new DataBinding({"control":this.getElement("issue_date")})
		,new DataBinding({"control":this.getElement("end_date")})
		,new DataBinding({"control":this.getElement("series")})
		,new DataBinding({"control":this.getElement("number")})
		,new DataBinding({"control":this.getElement("study_prog_name")})
		,new DataBinding({"control":this.getElement("study_period")})
		,new DataBinding({"control":this.getElement("post")})
		,new DataBinding({"control":this.getElement("work_place")})
		,new DataBinding({"control":this.getElement("organization")})
		,new DataBinding({"control":this.getElement("study_type")})
		,new DataBinding({"control":this.getElement("profession")})
		,new DataBinding({"control":this.getElement("reg_number")})
		,new DataBinding({"control":this.getElement("qualification_name")})
		,new DataBinding({"control":this.getElement("name_first")})
		,new DataBinding({"control":this.getElement("name_second")})
		,new DataBinding({"control":this.getElement("name_middle")})
	];
	this.setDataBindings(read_b);
	
	//write
	var write_b = [
		new CommandBinding({"control":this.getElement("snils")})
		,new CommandBinding({"control":this.getElement("issue_date")})
		,new CommandBinding({"control":this.getElement("end_date")})
		,new CommandBinding({"control":this.getElement("series")})
		,new CommandBinding({"control":this.getElement("number")})
		,new CommandBinding({"control":this.getElement("study_prog_name")})
		,new CommandBinding({"control":this.getElement("study_period")})
		,new CommandBinding({"control":this.getElement("post")})
		,new CommandBinding({"control":this.getElement("work_place")})
		,new CommandBinding({"control":this.getElement("organization")})
		,new CommandBinding({"control":this.getElement("study_type")})
		,new CommandBinding({"control":this.getElement("profession")})
		,new CommandBinding({"control":this.getElement("reg_number")})
		,new CommandBinding({"control":this.getElement("qualification_name")})
		,new CommandBinding({"control":this.getElement("name_first")})
		,new CommandBinding({"control":this.getElement("name_second")})
		,new CommandBinding({"control":this.getElement("name_middle")})
	];
	this.setWriteBindings(write_b);

}
extend(StudyDocumentInsertDialog_View, ViewObjectAjx);

//********************

