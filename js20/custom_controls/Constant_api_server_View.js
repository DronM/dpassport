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
function Constant_api_server_View(id,options){

	options = options || {};
	
	options.className = options.className || "form-group";
	
	var self = this;

	options.addElement = function(){

		this.addElement(new EditNum(id+":check_interval_ms",{
			"labelCaption":"Интервал запросов (мс):",
			"title":"С заданным интервалом сервер будет запросы на проверку изменений данных. Устанавливается в миллисекундах."
		}));

		this.addElement(new EditNum(id+":worker_count",{
			"labelCaption":"Количество потоков:",
			"title":"Количество потоков обработки."
		}));

		this.addElement(new EditString(id+":host",{
			"maxLength":"500",
			"labelCaption":"Хост API (хост:порт):",
			"title":"Хост API в виде URL:НОМЕР_ПОРТА"
		}));

		this.addElement(new EditString(id+":token",{
			"maxLength":"100",
			"labelCaption":"Token:",
			"title":"Секретный ключ"
		}));

	}	
	Constant_api_server_View.superclass.constructor.call(this,id,options);
	
}
extend(Constant_api_server_View, EditJSON);

/* Constants */


/* private members */

/* protected*/


/* public methods */

