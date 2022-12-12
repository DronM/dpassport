<?php
/* Справочник ДополнительныеОтчетыИОбработки */
define("CONST_1C_OBR_NAME",'API1C');

define('ER_FIRM_INN_NOT_DEFINED', 'ИНН организации не определен.');
define('ER_FIRM_INN_NOT_FOUND', 'Органиазция по ИНН %s не найдена.');
define('ER_FIRM_REF_NOT_DEFIND', 'Ссылка организации не определен.');

define('ER_DOC_REF_NOT_DEFIND', 'Ссылка на документ не определена.');

define('ER_SKALD_NOT_DEFINED', 'Наименование склада не определено.');
define('ER_SKALD_NOT_FOUND', 'Склад по наименованию %s не найден.');

define('ER_CLIENT_NOT_DEFINED', 'Контрагент не определен.');
define('ER_CLIENT_INN_NOT_DEFINED', 'ИНН контрагента не определен.');
define('CLIENT_COMMENT', 'web');
define('DOG_COMMENT', 'web');

define('ER_DOG_DATE_FROM_NOT_DEFINED', 'Дата начала договора не определен.');
define('ER_DOG_DATE_TO_NOT_DEFINED', 'Дата окончания договора не определен.');

define('CURRENCY_RUB_CODE', '643');

define('ER_BANK_ACC_NOT_DEFINED', 'Номер банковского счета не определен.');
define('ER_BANK_ACC_NOT_FOUND', 'Банковский счет по номеру %s не найден.');

define('ER_ITEM_NOT_DEFINED', 'Номенклатура счета не определена.');
define('ER_ITEM_NOT_FOUND', 'Номенклатура по наименованию %s не найдена.');



//**************************
function cyr_str_decode($str){
	return iconv('UTF-8', 'Windows-1251', $str);
}

function cyr_str_encode($str){
	return iconv('Windows-1251', 'UTF-8', $str);
}

function get_ext_obr($v8){
	$ext_form = $v8->Справочники->ДополнительныеОтчетыИОбработки->НайтиПоНаименованию(CONST_1C_OBR_NAME,TRUE);
	if ($ext_form->Пустая()){
		throw new Exception('Не найдена внешняя обработка "'.CONST_1C_OBR_NAME.'"');
	}
	$f = $v8->ПолучитьИмяВременногоФайла();
	$d = $ext_form->ХранилищеОбработки->Получить();
	$d->Записать($f);
	return $v8->ВнешниеОбработки->Создать($f,FALSE);
}

function get_currency_rub($v8){
	return $v8->Справочники->Валюты->НайтиПоКоду(CURRENCY_RUB_CODE);
}

function get_client($v8, $doc){
	if(!isset($doc['client'])){
		throw new Exception(ER_CLIENT_NOT_DEFINED);
	}
	$client = $doc['client'];
	if(!isset($client['inn'])){
		throw new Exception(ER_CLIENT_INN_NOT_DEFINED);
	}
	
	$q = $v8->NewObject('Запрос');
	$q->Текст ='ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.Контрагенты ГДЕ ИНН = &inn';
	$q->УстановитьПараметр('inn', $client['inn']);		
	$sel = $q->Выполнить()->Выбрать();
	if (!$sel->Следующий()){
		//new client
		$obj = $v8->Справочники->Контрагенты->СоздатьЭлемент();
		$obj->Наименование					= stripslashes(cyr_str_decode($client['name']));
		$obj->НаименованиеПолное			= stripslashes(cyr_str_decode($client['name_full']));
		$obj->ИНН							= $client['inn'];
		$obj->КПП							= $client['kpp'];
		$obj->РегистрационныйНомер			= $client['ogrn'];
		$obj->Комментарий					= CLIENT_COMMENT;
		$obj->Записать();
		return $obj->Ссылка;
		
	}else{
		return $sel->Ссылка;
	}
}

function get_dogovor($v8, $firmRef, $clientRef, $dog){
	if(!isset($dog['date_from'])){
		throw new Exception(ER_DOG_DATE_FROM_NOT_DEFINED);
	}
	if(!isset($dog['date_to'])){
		throw new Exception(ER_DOG_DATE_TO_NOT_DEFINED);
	}
	if(!isset($dog['item_name']) || !strlen($dog['item_name'])){
		throw new Exception(ER_ITEM_NOT_DEFINED);
	}
	
	$q = $v8->NewObject('Запрос');
	$q->Текст ='ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.ДоговорыКонтрагентов ГДЕ Владелец = &client И Наименование = &name';
	$q->УстановитьПараметр('name', $dog['item_name']);		
	$q->УстановитьПараметр('client', $clientRef);		
	$sel = $q->Выполнить()->Выбрать();
	if (!$sel->Следующий()){
		//new client
		$obj = $v8->Справочники->ДоговорыКонтрагентов->СоздатьЭлемент();
		$obj->Владелец						= $clientRef;
		$obj->Наименование					= stripslashes(cyr_str_decode($dog['item_name']));
		$obj->ВалютаВзаиморасчетов			= get_currency_rub($v8);
		$obj->Комментарий					= DOG_COMMENT;
		$obj->Организация					= $firmRef;
		$obj->ВидДоговора					= $v8->Перечисления->ВидыДоговоровКонтрагентов->СПокупателем;
		$obj->Дата							= date('Ymd', strtotime($dog['date_from']));
		$obj->СрокДействия					= date('Ymd', strtotime($dog['date_to']));
		$obj->Записать();
		return $obj->Ссылка;
		
	}else{
		return $sel->Ссылка;
	}
}

function get_bank_acc($v8, $firmRef, $doc){
	if(isset($doc['bank_account_ref']) && strlen($doc['bank_account_ref'])){
		$id = $v8->NewObject('УникальныйИдентификатор',$doc['bank_account_ref']);
		return $v8->Справочники->БанковскиеСчета->ПолучитьСсылку($id);			
	
	}else if(isset($doc['bank_account']) && strlen($doc['bank_account'])){
		$q = $v8->NewObject('Запрос');
		$q->Текст ='ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.БанковскиеСчета ГДЕ Владелец = &firm И НомерСчета = &bank_account';
		$q->УстановитьПараметр('firm', $firmRef);		
		$q->УстановитьПараметр('bank_account', $doc['bank_account']);		
		$sel = $q->Выполнить()->Выбрать();
		if (!$sel->Следующий()){
			throw new Exception(sprintf(ER_BANK_ACC_NOT_FOUND, $doc['bank_account']));
		}
		return $sel->Ссылка;		
		
	}else{
		throw new Exception(ER_BANK_ACC_NOT_DEFINED);
	}
}

function get_item($v8, $dog){
	if(isset($doc['item_ref']) && strlen($doc['item_ref'])){
		$id = $v8->NewObject('УникальныйИдентификатор',$doc['item_ref']);
		return $v8->Справочники->Номенклатура->ПолучитьСсылку($id);			
	
	}else if(isset($dog['item_name']) && strlen($dog['item_name'])){
		$item_name = cyr_str_decode($dog['item_name']);
		$q = $v8->NewObject('Запрос');
		$q->Текст ='ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.Номенклатура ГДЕ Наименование = &name';
		$q->УстановитьПараметр('name', $item_name);		
		$sel = $q->Выполнить()->Выбрать();
		if (!$sel->Следующий()){
			throw new Exception(sprintf(ER_ITEM_NOT_FOUND, $item_name));
		}
		return $sel->Ссылка;	
		
	}else{
		throw new Exception(ER_ITEM_NOT_DEFINED);
	}
}

function get_firm($v8, &$doc){
	if(isset($doc['firm_ref']) && strlen($doc['firm_ref'])){
		$id = $v8->NewObject('УникальныйИдентификатор',$doc['firm_ref']);
		return $v8->Справочники->Организации->ПолучитьСсылку($id);			
	
	}else if(isset($doc['firm_inn']) && strlen($doc['firm_inn'])){
		$q = $v8->NewObject('Запрос');
		$q->Текст ='ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.Организации ГДЕ ИНН = &firm_inn';
		$q->УстановитьПараметр('firm_inn', $doc['firm_inn']);		
		$sel = $q->Выполнить()->Выбрать();
		if (!$sel->Следующий()){
			throw new Exception(sprintf(ER_FIRM_INN_NOT_FOUND, $doc['firm_inn']));
		}
		return $sel->Ссылка;
		
	}else{
		throw new Exception(ER_FIRM_INN_NOT_DEFINED);
	}
}

function get_sklad($v8, $doc){
	if(isset($doc['sklad_ref']) && strlen($doc['sklad_ref'])){
		$id = $v8->NewObject('УникальныйИдентификатор',$doc['sklad_ref']);
		return $v8->Справочники->Склады->ПолучитьСсылку($id);			
		
	}else if(isset($doc['sklad_name']) && strlen($doc['sklad_name'])){
		$skald_name = cyr_str_decode($doc['sklad_name']);
		$q = $v8->NewObject('Запрос');
		$q->Текст ='ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.Склады ГДЕ Наименование = &sklad_name';
		$q->УстановитьПараметр('sklad_name',$skald_name);		
		$sel = $q->Выполнить()->Выбрать();
		if (!$sel->Следующий()){
			throw new Exception(sprintf(ER_SKALD_NOT_FOUND, $skald_name));
		}
		return $sel->Ссылка;	
		
	}else{
		throw new Exception(ER_SKALD_NOT_DEFINED);
	}	
}

//***************************
//йф
 function add_schet($v8, &$doc){
	$doc_obj = $v8->Документы->СчетНаОплатуПокупателю->СоздатьДокумент();	
	$doc_obj->Дата					= date('YmdHis', strtotime($doc['date']));
	$doc_obj->Организация			= get_firm($v8, $doc);
	$doc_obj->Склад					= get_sklad($v8, $doc);
	$doc_obj->Контрагент			= get_client($v8, $doc);
	$doc_obj->ДоговорКонтрагента	= get_dogovor($v8, $doc_obj->Организация, $doc_obj->Контрагент, $doc['client']['dogovor']);
	$doc_obj->ОрганизацияПолучатель	= $doc_obj->Организация;
	$doc_obj->СтруктурнаяЕдиница	= get_bank_acc($v8, $doc_obj->Организация, $doc);
	
	//item
	$nds_val = (!isset($doc['nds_val']) || intval($doc['nds_val'])==0)? 0 : intval($doc['nds_val']);
	$item = get_item($v8, $doc['client']['dogovor']);
	$line = $doc_obj->Товары->Добавить();
	$line->Номенклатура 			= $item;
	$line->Количество 				= 1;
	$line->Цена 					= floatval($doc['total']);
	$line->Сумма					= floatval($doc['total']);
	$line->СтавкаНДС				= ($nds_val==0)? $v8->Перечисления->СтавкиНДС->БезНДС : $v8->Перечисления->СтавкиНДС->НДС20;
	$line->СуммаНДС					= ($nds_val==0)? 0 : round($line->Сумма*$nds_val/(100 + $nds_val), 2);
	
	$doc_obj->Записать($v8->РежимЗаписиДокумента->Проведение);	
	$doc['ref'] = $v8->String($doc_obj->Ссылка->УникальныйИдентификатор());
	$doc['firm_ref'] = $v8->String($doc_obj->Организация->УникальныйИдентификатор());
	$doc['sklad_ref'] = $v8->String($doc_obj->Склад->УникальныйИдентификатор());
	$doc['bank_account_ref'] = $v8->String($doc_obj->СтруктурнаяЕдиница->УникальныйИдентификатор());
	$doc['client']['ref'] = $v8->String($doc_obj->Контрагент->УникальныйИдентификатор());
	$doc['client']['dogovor']['ref'] = $v8->String($doc_obj->ДоговорКонтрагента->УникальныйИдентификатор());
	$doc['client']['dogovor']['item_ref'] = $v8->String($item->УникальныйИдентификатор());
	$doc['num'] = cyr_str_encode($doc_obj->Номер);
	$doc['descr'] = cyr_str_encode($v8->String($doc_obj->Ссылка));
 }
 
 function get_schet_print($v8, $ref){
	//$obr = get_ext_obr($v8);
	//return $obr->ПечатьСчетаВФайл($ref);	
	$id = $v8->NewObject('УникальныйИдентификатор',$ref);
	$pr_objects = $v8->NewObject('СписокЗначений');
	$pr_objects->Добавить($v8->Документы->СчетНаОплатуПокупателю->ПолучитьСсылку($id));	
	
	$pr_opts = $v8->NewObject('Структура');
	$pr_opts->Вставить("ОтображатьФаксимиле", TRUE);	
	
	$pr_inf = $v8->Документы->СчетНаОплатуПокупателю->ПолучитьТаблицуСведенийСчетаНаОплату($pr_objects);
	$tab_doc = $v8->ПечатьТорговыхДокументов->ПечатьСчетаНаОплату($pr_inf, $pr_objects, $pr_opts);
	//$tmp_fl = 'C:/www/'.uniqid().'.pdf';
	$tmp_fl = $v8->КаталогВременныхФайлов() . $v8->String($v8->NewObject('УникальныйИдентификатор')) . ".pdf";			
	$tab_doc->Записать($tmp_fl, $v8->ТипФайлаТабличногоДокумента->PDF);
//throw new Exception('REF='.$ref.' tmp_fl='.$tmp_fl);
	return $tmp_fl;
 }
 
 function check_payment($v8, &$docAr){
	$q = $v8->NewObject('Запрос');
	$firm_ref = NULL;	
	$i = 0;
	$q_doc = '';
	foreach($docAr as $doc){
		/*if(is_null($firm_ref)){
			if(!isset($doc['firm_ref'])){
				throw new Exception(ER_FIRM_REF_NOT_DEFIND);
			}
			$firm_id = $v8->NewObject('УникальныйИдентификатор',$doc['firm_ref']);
			$firm_ref = $v8->Справочники->Организации->ПолучитьСсылку($firm_id);			
			$q->УстановитьПараметр('firm_ref', $firm_ref );		
		}
		if(!isset($doc['ref'])){
			throw new Exception(ER_DOC_REF_NOT_DEFIND);
		}
		*/
		$doc_id = $v8->NewObject('УникальныйИдентификатор',$doc['ref']);
		$doc_ref = $v8->Документы->СчетНаОплатуПокупателю->ПолучитьСсылку($doc_id);			
		$q->УстановитьПараметр('doc_ref_'.$i, $doc_ref);		
		$q_doc.= ($q_doc=='')? '(':' ИЛИ ';
		$q_doc.= 'Документ = &doc_ref_'.$i;
		$i++;
	}
	//ГДЕ Организация = &firm_ref И 
	$q_doc.= ')';	
//throw new Exception('ВЫБРАТЬ УникальныйИдентификатор(Документ) AS RefStr, Статус  ИЗ РегистрСведений.СтатусыДокументов ГДЕ '.$q_doc);	
	$q->Текст ='ВЫБРАТЬ УникальныйИдентификатор(Документ) AS RefStr, Статус  ИЗ РегистрСведений.СтатусыДокументов ГДЕ '.$q_doc;	
	$sel = $q->Выполнить()->Выбрать();
	while ($sel->Следующий()){
		foreach($docAr as &$doc){
//throw new Exception('Q='.$sel->RefStr.' doc='.$doc['ref']);			
			if($v8->String($sel->RefStr) == $doc['ref']){				
				$doc['payed'] = ($v8->String($sel->Статус)=='Оплачен');
				break;
			}
		}
	}
	 
 }
 
?>
