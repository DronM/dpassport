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
function Constant_server_1c_View(id,options){

	options = options || {};
	
	options.className = options.className || "form-group";
	
	var self = this;

	options.addElement = function(){
		var id = this.getId();

		this.addElement(new EditString(id+":host",{
			"maxLength":"200",
			"labelCaption":"Хост (протокол://хост:порт):",
			"title":"Хост в виде ПРОТОКОЛ://ИМЯ_ХОСТА:НОМЕР_ПОРТА"
		}));
		this.addElement(new EditEmail(id+":key",{
			"maxLength":"200",
			"labelCaption":"Ключ:",
			"title":"Секретный ключ доступа"
		}));
		this.addElement(new EditNum(id+":log_level",{
			"labelCaption":"Уровень лога (0-9):",
			"title":"Уровень лога от 0 - ошибки до 9 - отладка"
		}));

		this.addElement(new EditNum(id+":pay_check_interval",{
			"labelCaption":"Интервал проверки оплат (секунд):",
			"title":"Проверять оплаты по выписанным счетам с заданным интервалом"
		}));
		this.addElement(new EditString(id+":firm_inn",{
			"labelCaption": "ИНН организации в 1с:",
			"title":"ИНН организации от которой выписывать счет. Организация должна существовать в базе 1с."
		}));
		this.addElement(new EditString(id+":sklad_name",{
			"labelCaption": "Наименование склада в 1с:",
			"title":"Наименование склада как оно задано в 1с."
		}));
		this.addElement(new EditString(id+":bank_account",{
			"labelCaption": "Номер р/с нашего банка:",
			"title":"Расчетный счет должен существовать в 1с у нашей организации"
		}));

		this.addElement(new EditNum(id+":nds_val",{
			"labelCaption": "Значение ставки НДС:",			
			"title":"Числовое значение ставки НДС. Если 0 - без НДС"
		}));

		this.addElement(new EditString(id+":item_name",{
			"labelCaption": "Наименование услуги в 1с:",			
			"title":"Точное наименование услуги в справочнике Номенклатура 1с. Если элемент справочника в 1с не будет найден, то программа создаст новый."
		}));
		
		this.addElement(new EditNum(id+":dogovor_dur_mon",{
			"labelCaption": "Длительность договора (месяцев)",
			"title":"Срок действия договора в месяцах."
		}));

		this.addElement(new EditMoney(id+":total",{
			"labelCaption": "Полная сумма услуги:",			
			"title":"Полная стоимость услуги за период с НДС (если есть НДС)"
		}));

	}	
	Constant_server_1c_View.superclass.constructor.call(this,id,options);
	
}
extend(Constant_server_1c_View, EditJSON);

/* Constants */


/* private members */

/* protected*/


/* public methods */

