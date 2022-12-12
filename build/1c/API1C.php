<?php
	require_once('downloader.php');
	require_once('functions.php');
	
	//Should correspond to const_server_1c->'key'
	define('TOKEN', '5g4*7h4c46tr$%uk41jn65)bhv54vcwr54v');
	
	define('PAR_COMMAND', 'cmd');
	define('PAR_TOKEN', 'k');
	define('PAR_DOC', 'doc');
	define('PAR_DOC_AR', 'docs');
	define('PAR_REF_1C', 'ref');
	
	define('ER_PARAM_MISSING', 'Required param %s not found.');

	header('Content-Type: application/json; charset=utf-8');
	//йф
	
	/**
	* GoLang Document structures
		type SprDogovor struct {
			Date_from time.Time `json:"date_from"`
			Date_to time.Time `json:"date_from"`
			Item_name string `json:"item_name"`	
			Ref_1c string `json:"ref_1c"`
		}

		type SprClient struct {
			Name string `json:"name"`
			Name_full string `json:"name_full"`
			Inn string `json:"inn"`
			Kpp string `json:"kpp"`
			Ogrn string `json:"ogrn"`
			Dogovor SprDogovor `json:"dogovor"`
			Ref_1c string `json:"ref_1c"`
		}

		type DocPayment struct {
			Num string `json:"num"`
			Date string `json:"date"`
		}

		type DocSchet struct {
			Num string `json:"num"`
			Date time.Time `json:"date"`
			Client SprClient `json:"client"`
			Total float32 `json:"total"`
			Ref_1c string `json:"ref_1c"`
			Doc_payment DocPayment `json:"doc_payment"`
		}
	
	*/
	
	//********* команды *************
	set_time_limit(300);
	
	/**
	 * Creates new document
	 * @param {string} doc json document
	 */
	define('CMD_ADD_SCHET', 'add_schet');	

	/**
	 * @param {string} ref1c
	 */
	define('CMD_GET_SCHET_PRINT', 'get_schet_print');	

	/**
	 * @param {string} doc_id ссылка документ счет
	 * Checks for payments
	 */
	define('CMD_CHECK_PAYMENT', 'check_payment');	
	//******************
	
	define('COM_OBJ_NAME', 'v8Server.Connection');
	
	$resp_status = 'true';
	$resp_er = '""';
	$resp_body = '';
	$SENT_FILE = FALSE;
	
	try{		
		if (!isset($_REQUEST[PAR_COMMAND])){
			throw new Exception(sprintf(ER_PARAM_MISSING, PAR_COMMAND));
		}else if (!isset($_REQUEST[PAR_TOKEN])){
			throw new Exception(sprintf(ER_PARAM_MISSING, PAR_TOKEN));
		}else if ($_REQUEST[PAR_TOKEN] != TOKEN){	
		}
		
		$com = $_REQUEST[PAR_COMMAND];
		
		if ($com == CMD_ADD_SCHET){
			if (!isset($_REQUEST[PAR_DOC])){
				throw new Exception(sprintf(ER_PARAM_MISSING, PAR_DOC));
			}		
			$v8 = new COM(COM_OBJ_NAME);
			$doc = json_decode($_REQUEST[PAR_DOC], TRUE);			
			add_schet($v8, $doc);
			$resp_body = '"doc": '.json_encode($doc, JSON_UNESCAPED_UNICODE);
		
		}else if ($com == CMD_GET_SCHET_PRINT){
			if (!isset($_REQUEST[PAR_REF_1C])){
				throw new Exception(sprintf(ER_PARAM_MISSING, PAR_REF_1C));
			}					
			$v8 = new COM(COM_OBJ_NAME);
			$file = get_schet_print($v8, $_REQUEST[PAR_REF_1C]);
			downloadfile($file);
			unlink($file);
			$SENT_FILE = TRUE;		
		
		}else if ($com==CMD_CHECK_PAYMENT){
			if (!isset($_REQUEST[PAR_DOC_AR])){
				throw new Exception(sprintf(ER_PARAM_MISSING, PAR_DOC_AR));
			}		
			$doc_ar = json_decode($_REQUEST[PAR_DOC_AR], TRUE);
			if(!is_array($doc_ar) || !count($doc_ar)){
				throw new Exception('Parameter '.PAR_DOC_AR.' must be an array.');
			}
			$v8 = new COM(COM_OBJ_NAME);			
			check_payment($v8, $doc_ar);				
			$resp_body = '"docs": '.json_encode($doc_ar, JSON_UNESCAPED_UNICODE);
		}
	}
	catch (Exception $e){
		//error
		$resp_status = 'false';		
		//$resp_er = json_encode($e->getMessage(), JSON_UNESCAPED_UNICODE);		
		$resp_er = json_encode(iconv('Windows-1251', 'UTF-8', $e->getMessage()), JSON_UNESCAPED_UNICODE);		
	}
	if (!$SENT_FILE){
		if($resp_body != ''){
			$resp_body = ', '. $resp_body;
		}
		echo sprintf('{"status": %s, "error": %s%s}', $resp_status, $resp_er, $resp_body);
	}
?>
