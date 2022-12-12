<?php
/* ���������� ������������������������������ */
define("CONST_1C_OBR_NAME",'API1C');

define('ER_FIRM_INN_NOT_DEFINED', '��� ����������� �� ���������.');
define('ER_FIRM_INN_NOT_FOUND', '����������� �� ��� %s �� �������.');
define('ER_FIRM_REF_NOT_DEFIND', '������ ����������� �� ���������.');

define('ER_DOC_REF_NOT_DEFIND', '������ �� �������� �� ����������.');

define('ER_SKALD_NOT_DEFINED', '������������ ������ �� ����������.');
define('ER_SKALD_NOT_FOUND', '����� �� ������������ %s �� ������.');

define('ER_CLIENT_NOT_DEFINED', '���������� �� ���������.');
define('ER_CLIENT_INN_NOT_DEFINED', '��� ����������� �� ���������.');
define('CLIENT_COMMENT', 'web');
define('DOG_COMMENT', 'web');

define('ER_DOG_DATE_FROM_NOT_DEFINED', '���� ������ �������� �� ���������.');
define('ER_DOG_DATE_TO_NOT_DEFINED', '���� ��������� �������� �� ���������.');

define('CURRENCY_RUB_CODE', '643');

define('ER_BANK_ACC_NOT_DEFINED', '����� ����������� ����� �� ���������.');
define('ER_BANK_ACC_NOT_FOUND', '���������� ���� �� ������ %s �� ������.');

define('ER_ITEM_NOT_DEFINED', '������������ ����� �� ����������.');
define('ER_ITEM_NOT_FOUND', '������������ �� ������������ %s �� �������.');



//**************************
function cyr_str_decode($str){
	return iconv('UTF-8', 'Windows-1251', $str);
}

function cyr_str_encode($str){
	return iconv('Windows-1251', 'UTF-8', $str);
}

function get_ext_obr($v8){
	$ext_form = $v8->�����������->������������������������������->�������������������(CONST_1C_OBR_NAME,TRUE);
	if ($ext_form->������()){
		throw new Exception('�� ������� ������� ��������� "'.CONST_1C_OBR_NAME.'"');
	}
	$f = $v8->��������������������������();
	$d = $ext_form->������������������->��������();
	$d->��������($f);
	return $v8->����������������->�������($f,FALSE);
}

function get_currency_rub($v8){
	return $v8->�����������->������->�����������(CURRENCY_RUB_CODE);
}

function get_client($v8, $doc){
	if(!isset($doc['client'])){
		throw new Exception(ER_CLIENT_NOT_DEFINED);
	}
	$client = $doc['client'];
	if(!isset($client['inn'])){
		throw new Exception(ER_CLIENT_INN_NOT_DEFINED);
	}
	
	$q = $v8->NewObject('������');
	$q->����� ='������� ������ 1 ������ �� ����������.����������� ��� ��� = &inn';
	$q->������������������('inn', $client['inn']);		
	$sel = $q->���������()->�������();
	if (!$sel->���������()){
		//new client
		$obj = $v8->�����������->�����������->��������������();
		$obj->������������					= stripslashes(cyr_str_decode($client['name']));
		$obj->������������������			= stripslashes(cyr_str_decode($client['name_full']));
		$obj->���							= $client['inn'];
		$obj->���							= $client['kpp'];
		$obj->��������������������			= $client['ogrn'];
		$obj->�����������					= CLIENT_COMMENT;
		$obj->��������();
		return $obj->������;
		
	}else{
		return $sel->������;
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
	
	$q = $v8->NewObject('������');
	$q->����� ='������� ������ 1 ������ �� ����������.�������������������� ��� �������� = &client � ������������ = &name';
	$q->������������������('name', $dog['item_name']);		
	$q->������������������('client', $clientRef);		
	$sel = $q->���������()->�������();
	if (!$sel->���������()){
		//new client
		$obj = $v8->�����������->��������������������->��������������();
		$obj->��������						= $clientRef;
		$obj->������������					= stripslashes(cyr_str_decode($dog['item_name']));
		$obj->��������������������			= get_currency_rub($v8);
		$obj->�����������					= DOG_COMMENT;
		$obj->�����������					= $firmRef;
		$obj->�����������					= $v8->������������->�������������������������->������������;
		$obj->����							= date('Ymd', strtotime($dog['date_from']));
		$obj->������������					= date('Ymd', strtotime($dog['date_to']));
		$obj->��������();
		return $obj->������;
		
	}else{
		return $sel->������;
	}
}

function get_bank_acc($v8, $firmRef, $doc){
	if(isset($doc['bank_account_ref']) && strlen($doc['bank_account_ref'])){
		$id = $v8->NewObject('�����������������������',$doc['bank_account_ref']);
		return $v8->�����������->���������������->��������������($id);			
	
	}else if(isset($doc['bank_account']) && strlen($doc['bank_account'])){
		$q = $v8->NewObject('������');
		$q->����� ='������� ������ 1 ������ �� ����������.��������������� ��� �������� = &firm � ���������� = &bank_account';
		$q->������������������('firm', $firmRef);		
		$q->������������������('bank_account', $doc['bank_account']);		
		$sel = $q->���������()->�������();
		if (!$sel->���������()){
			throw new Exception(sprintf(ER_BANK_ACC_NOT_FOUND, $doc['bank_account']));
		}
		return $sel->������;		
		
	}else{
		throw new Exception(ER_BANK_ACC_NOT_DEFINED);
	}
}

function get_item($v8, $dog){
	if(isset($doc['item_ref']) && strlen($doc['item_ref'])){
		$id = $v8->NewObject('�����������������������',$doc['item_ref']);
		return $v8->�����������->������������->��������������($id);			
	
	}else if(isset($dog['item_name']) && strlen($dog['item_name'])){
		$item_name = cyr_str_decode($dog['item_name']);
		$q = $v8->NewObject('������');
		$q->����� ='������� ������ 1 ������ �� ����������.������������ ��� ������������ = &name';
		$q->������������������('name', $item_name);		
		$sel = $q->���������()->�������();
		if (!$sel->���������()){
			throw new Exception(sprintf(ER_ITEM_NOT_FOUND, $item_name));
		}
		return $sel->������;	
		
	}else{
		throw new Exception(ER_ITEM_NOT_DEFINED);
	}
}

function get_firm($v8, &$doc){
	if(isset($doc['firm_ref']) && strlen($doc['firm_ref'])){
		$id = $v8->NewObject('�����������������������',$doc['firm_ref']);
		return $v8->�����������->�����������->��������������($id);			
	
	}else if(isset($doc['firm_inn']) && strlen($doc['firm_inn'])){
		$q = $v8->NewObject('������');
		$q->����� ='������� ������ 1 ������ �� ����������.����������� ��� ��� = &firm_inn';
		$q->������������������('firm_inn', $doc['firm_inn']);		
		$sel = $q->���������()->�������();
		if (!$sel->���������()){
			throw new Exception(sprintf(ER_FIRM_INN_NOT_FOUND, $doc['firm_inn']));
		}
		return $sel->������;
		
	}else{
		throw new Exception(ER_FIRM_INN_NOT_DEFINED);
	}
}

function get_sklad($v8, $doc){
	if(isset($doc['sklad_ref']) && strlen($doc['sklad_ref'])){
		$id = $v8->NewObject('�����������������������',$doc['sklad_ref']);
		return $v8->�����������->������->��������������($id);			
		
	}else if(isset($doc['sklad_name']) && strlen($doc['sklad_name'])){
		$skald_name = cyr_str_decode($doc['sklad_name']);
		$q = $v8->NewObject('������');
		$q->����� ='������� ������ 1 ������ �� ����������.������ ��� ������������ = &sklad_name';
		$q->������������������('sklad_name',$skald_name);		
		$sel = $q->���������()->�������();
		if (!$sel->���������()){
			throw new Exception(sprintf(ER_SKALD_NOT_FOUND, $skald_name));
		}
		return $sel->������;	
		
	}else{
		throw new Exception(ER_SKALD_NOT_DEFINED);
	}	
}

//***************************
//��
 function add_schet($v8, &$doc){
	$doc_obj = $v8->���������->����������������������->���������������();	
	$doc_obj->����					= date('YmdHis', strtotime($doc['date']));
	$doc_obj->�����������			= get_firm($v8, $doc);
	$doc_obj->�����					= get_sklad($v8, $doc);
	$doc_obj->����������			= get_client($v8, $doc);
	$doc_obj->������������������	= get_dogovor($v8, $doc_obj->�����������, $doc_obj->����������, $doc['client']['dogovor']);
	$doc_obj->���������������������	= $doc_obj->�����������;
	$doc_obj->������������������	= get_bank_acc($v8, $doc_obj->�����������, $doc);
	
	//item
	$nds_val = (!isset($doc['nds_val']) || intval($doc['nds_val'])==0)? 0 : intval($doc['nds_val']);
	$item = get_item($v8, $doc['client']['dogovor']);
	$line = $doc_obj->������->��������();
	$line->������������ 			= $item;
	$line->���������� 				= 1;
	$line->���� 					= floatval($doc['total']);
	$line->�����					= floatval($doc['total']);
	$line->���������				= ($nds_val==0)? $v8->������������->���������->������ : $v8->������������->���������->���20;
	$line->��������					= ($nds_val==0)? 0 : round($line->�����*$nds_val/(100 + $nds_val), 2);
	
	$doc_obj->��������($v8->��������������������->����������);	
	$doc['ref'] = $v8->String($doc_obj->������->�����������������������());
	$doc['firm_ref'] = $v8->String($doc_obj->�����������->�����������������������());
	$doc['sklad_ref'] = $v8->String($doc_obj->�����->�����������������������());
	$doc['bank_account_ref'] = $v8->String($doc_obj->������������������->�����������������������());
	$doc['client']['ref'] = $v8->String($doc_obj->����������->�����������������������());
	$doc['client']['dogovor']['ref'] = $v8->String($doc_obj->������������������->�����������������������());
	$doc['client']['dogovor']['item_ref'] = $v8->String($item->�����������������������());
	$doc['num'] = cyr_str_encode($doc_obj->�����);
	$doc['descr'] = cyr_str_encode($v8->String($doc_obj->������));
 }
 
 function get_schet_print($v8, $ref){
	//$obr = get_ext_obr($v8);
	//return $obr->����������������($ref);	
	$id = $v8->NewObject('�����������������������',$ref);
	$pr_objects = $v8->NewObject('��������������');
	$pr_objects->��������($v8->���������->����������������������->��������������($id));	
	
	$pr_opts = $v8->NewObject('���������');
	$pr_opts->��������("�������������������", TRUE);	
	
	$pr_inf = $v8->���������->����������������������->������������������������������������($pr_objects);
	$tab_doc = $v8->������������������������->�������������������($pr_inf, $pr_objects, $pr_opts);
	//$tmp_fl = 'C:/www/'.uniqid().'.pdf';
	$tmp_fl = $v8->����������������������() . $v8->String($v8->NewObject('�����������������������')) . ".pdf";			
	$tab_doc->��������($tmp_fl, $v8->���������������������������->PDF);
//throw new Exception('REF='.$ref.' tmp_fl='.$tmp_fl);
	return $tmp_fl;
 }
 
 function check_payment($v8, &$docAr){
	$q = $v8->NewObject('������');
	$firm_ref = NULL;	
	$i = 0;
	$q_doc = '';
	foreach($docAr as $doc){
		/*if(is_null($firm_ref)){
			if(!isset($doc['firm_ref'])){
				throw new Exception(ER_FIRM_REF_NOT_DEFIND);
			}
			$firm_id = $v8->NewObject('�����������������������',$doc['firm_ref']);
			$firm_ref = $v8->�����������->�����������->��������������($firm_id);			
			$q->������������������('firm_ref', $firm_ref );		
		}
		if(!isset($doc['ref'])){
			throw new Exception(ER_DOC_REF_NOT_DEFIND);
		}
		*/
		$doc_id = $v8->NewObject('�����������������������',$doc['ref']);
		$doc_ref = $v8->���������->����������������������->��������������($doc_id);			
		$q->������������������('doc_ref_'.$i, $doc_ref);		
		$q_doc.= ($q_doc=='')? '(':' ��� ';
		$q_doc.= '�������� = &doc_ref_'.$i;
		$i++;
	}
	//��� ����������� = &firm_ref � 
	$q_doc.= ')';	
//throw new Exception('������� �����������������������(��������) AS RefStr, ������  �� ���������������.����������������� ��� '.$q_doc);	
	$q->����� ='������� �����������������������(��������) AS RefStr, ������  �� ���������������.����������������� ��� '.$q_doc;	
	$sel = $q->���������()->�������();
	while ($sel->���������()){
		foreach($docAr as &$doc){
//throw new Exception('Q='.$sel->RefStr.' doc='.$doc['ref']);			
			if($v8->String($sel->RefStr) == $doc['ref']){				
				$doc['payed'] = ($v8->String($sel->������)=='�������');
				break;
			}
		}
	}
	 
 }
 
?>
