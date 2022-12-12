update const_study_document_fields
set val = '{"rows":[
{"name":"Client_search","descr":"Площадка"},
{"name":"Snils","descr":"СНИЛС"},
{"name":"Issue_date", "descr": "Дата выдачи", "dataType":"Date"},
{"name":"End_date", "descr": "Дата окончания", "dataType":"Date"},
{"name":"Post", "descr": "Аттестуемая должность"},
{"name":"Work_place", "descr": "Место работы"},
{"name":"Organization", "descr": "Аттестуемая организация"},
{"name":"Study_type", "descr": "Вид обучения"},
{"name":"Series", "descr": "Серия документа", "maxLength":50},
{"name":"Number", "descr": "Номер документа", "maxLength":50},
{"name":"Study_prog_name", "descr": "Наименование программы обучения"},
{"name":"Profession", "descr": "Наименование профессии"},
{"name":"Reg_number", "descr": "Регистрационный номер"},
{"name":"Study_period", "descr": "Срок обучения"},
{"name":"Name_first", "descr": "Имя"},
{"name":"Name_second", "descr": "Фамилия"},
{"name":"Name_middle", "descr": "Отчество"},
{"name":"Qualification_name", "descr": "Квалификация"}
],
"analyze_count":5}'

update const_study_document_register_fields
set val = '{"rows":[
{"name":"Client_search","descr":"Площадка"},
{"name":"Date_time", "descr": "Дата", "dataType":"DateTimeTZ"},
{"name":"Name", "descr": "Наименование"}
],
"analyze_count":5}'

