var DATE_SEP = ".";
var cache = {};
var search_cols = ["study_prog_name", "post","work_place","organization","study_type","series","number","study_period","study_form"];

function pageLoad(){
	
	$('.container').click(function(e){
		var c = $(e.target).closest('.container');
		if(!c||!c.length)return;
		showCertDetails(c[0].getAttribute('cert_id'));
	});
	
	$('#view_type_card').change(function(e){
		setCardView();
	});
	$('#view_type_grid').change(function(e){
		setGridView();
	});
	
}

function showCertDetails(certId){
	if(cache[certId]){
		showDetails(cache[certId]);
		return;
	}
	
	$.ajax({
		url: "?c=StudyDocument&f=get_object&v=ViewJSON&id="+certId
		
	}).done(function(data) {
		if(!data.models||!data.models.StudyDocumentDialog_Model||!data.models.StudyDocumentDialog_Model.rows
		||!data.models.StudyDocumentDialog_Model.rows.length){
			showAjaxError(data);
		}else{
			showDetails(data.models.StudyDocumentDialog_Model.rows[0]);
		}
	});		
}

function getBsClass(bsW, n){
	return "col-"+bsW+"-"+n;
}

function getBsWidthClass(){
	var w = $( window ).width();
	if(w >= 1200){
		bsW = "lg";
		
	}else if(w >= 992){
		bsW = "md";
		
	}else if(w >= 768){
		bsW = "sm";		
	}else{
		bsW = "xs";		
	}
	return bsW;
}

function showAjaxError(data) {
	if(data.models&&data.models.Response&&data.models.Response.rows&&data.models.Response.rows.length
	&&data.models.Response.rows[0].descr&&data.models.Response.rows[0].descr.length){
		$('#f_error').text(data.models.Response.rows[0].descr);
		$("#error_dlg").modal({
			show: true
		});				
	}else{
		console.log("Error")
	}
}

function fetchData(callBack) {
	var ord_directs, ord_fields;
	var search_val, s_cond;

	if(document.getElementById("view_type_card").checked){
		ord_directs = "desc";
		ord_fields = "end_date";
	}else{				
		var n = document.getElementById("search");
		if(n){
			search_val = n.value;
		}
		var ord_directs_n = document.getElementById("ord_directs");
		if(ord_directs_n){
			ord_directs = ord_directs_n.value;
		}else{
			ord_directs = "desc";
		}
		var ord_fields_n = document.getElementById("ord_fields");
		if(ord_fields_n){
			ord_fields = ord_fields_n.value;
		}else{
			ord_fields = "end_date";
		}				
	}
	if(search_val && search_val.length){
		var cond_fields = "", cond_sgns = "", cond_joins = "", cond_vals = "", cond_ic = "";
		for(var i = 0; i<search_cols.length; i++){
			cond_fields += i? "@@":"";
			cond_fields += search_cols[i];
			
			cond_sgns+= i? "@@":"";
			cond_sgns+= "lk";
			
			cond_joins+= i? "@@":"";
			cond_joins+= "o";

			cond_ic+= i? "@@":"";
			cond_ic+= "1";

			cond_vals+= i? "@@":"";
			cond_vals+= "%25" + search_val + "%25";
			
		}
		s_cond = "field_sep=@@&cond_fields="+cond_fields+"&cond_sgns="+cond_sgns+"&cond_joins="+cond_joins+"&cond_vals="+cond_vals+"&cond_ic="+cond_ic;
	}
	
	$.ajax({
		url: "?c=StudyDocument&f=get_list&ord_fields="+ord_fields+"&ord_directs="+ord_directs+"&v=ViewJSON" + (s_cond? "&"+s_cond : "")

	}).done(function(data) {
		if(!data.models||!data.models.StudyDocumentList_Model||!data.models.StudyDocumentList_Model.rows){
			showAjaxError(data);
		}else{
			//format dates
			for(i = 0; i < data.models.StudyDocumentList_Model.rows.length; i++){
				data.models.StudyDocumentList_Model.rows[i].issue_date = format_date(data.models.StudyDocumentList_Model.rows[i].issue_date);
				data.models.StudyDocumentList_Model.rows[i].end_date = format_date(data.models.StudyDocumentList_Model.rows[i].end_date);
				//search highlight
				/*if(search_val){
					for(var k = 0; k<search_cols.length; k++){
						var n_v = data.models.StudyDocumentList_Model.rows[i][search_cols[k]].replace(search_val, "<span class='searchVal'>"+search_val+"</span>");
						if(data.models.StudyDocumentList_Model.rows[i][search_cols[k]] != n_v){
							data.models.StudyDocumentList_Model.rows[i][search_cols[k]] = "<div>"+n_v+"</div>";
						}
					}	
				}*/
			}
			
			callBack(data.models.StudyDocumentList_Model.rows);
		}
	});		
}
function getDataContainer() {
	var l = document.getElementsByClassName("dataContainer");
	if(!l || !l.length){
		return;
	}
	return l[0];
}
	
function clear() {
	var l = getDataContainer();
	if(!l){
		return;
	}
	while (l && l.firstChild) {
		l.removeChild(l.firstChild);
	}	
}

function setView(rows, t){
	var l = getDataContainer();
	if(!l){
		return;
	}
	Mustache.parse(t);
	l.innerHTML = Mustache.render(t, {"rows": rows});
//console.log("rows=",rows)	
}

function updateGrid(rows){
	var n = document.getElementById("dataGrid");
	while (n && n.firstChild) {
		n.removeChild(n.firstChild);
	}	
	var t = getGridTemplate();
	Mustache.parse(t);
	n.innerHTML = Mustache.render(t, {"rows": rows});
	setGridEvent();
}

function setGridView(){	
	fetchData(function(rows){
		clear();
		setView(rows, getGridContainerTemplate());
				
		var l = getDataContainer();
		if(l){
			$(l).removeClass("setka");
			$("#dataWrapper").removeClass("wrapper");
		}
		$('#ord_fields').change(function(){
			fetchData(function(rows){
				updateGrid(rows);
			});			
		});
		
		$('#ord_directs').change(function(){
			fetchData(function(rows){
				updateGrid(rows);
			});			
		});	
		
		$('#search').on("input", function(){
			fetchData(function(rows){
				updateGrid(rows);
			});			
		});
		setGridEvent();			
		document.getElementById("search").focus();
	});
}

function setGridEvent(){
	$('.doc_cert').click(function(e){
		var c = $(e.target).closest('.doc_cert');
		if(!c||!c.length)return;
		showCertDetails(c[0].getAttribute('cert_id'));
	});
}

function setCardView(){
	fetchData(function(rows){
		clear();
		setView(rows, getCardTemplate());
		var l = getDataContainer();
		if(l){
			$(l).addClass("setka");
			$("#dataWrapper").addClass("wrapper");
		}
	});
}

function showDetails(obj){
	cache[obj.id] = obj;
	
	$("#details_dlg").modal({
		show: true
	});
	$('#f_post').text(obj.post);
	$('#f_end_date').text(format_date(obj.end_date));
	$('#f_issue_date').text(format_date(obj.issue_date));
	$('#f_work_place').text(obj.work_place);
	$('#f_organization').text(obj.organization);
	$('#f_study_type').text(obj.study_type);
	$('#f_series').text(obj.series);
	$('#f_number').text(obj.number);
	$('#f_study_prog_name').text(obj.study_prog_name);
	$('#f_reg_number').text(obj.reg_number);
	$('#f_study_period').text(obj.study_period);
	$('#f_qualification_name').text(obj.qualification_name);
	
	if(obj.attachments && obj.attachments.length && obj.attachments[0].dataBase64){
		$('#f_pic').attr("src", "data:image/png;base64, "+obj.attachments[0].dataBase64);
		$('#f_pic').click(function(){			
			window.open('?c=StudyDocumentAttachment&f=get_file&study_documents_ref={"dataType":"study_documents","keys":{"id":"'+obj.id+'"}}&inline=1&content_id='+obj.attachments[0].id,
				"Сертификат",
				"location=0,menubar=0,status=0,titlebar=0,top=0,width="+($(window).width()/3)+",height="+($(window).height()/3*2)
			);
		});
	}
	
}
function add_zero(s){
	return (s.length==1? "0"+s : s);
}
function format_date(dateISO){
	if(!dateISO||!dateISO.length)return;
	let d_parts = dateISO.split("-");
	if(!d_parts.length)return;
	return (add_zero(d_parts[2])+ DATE_SEP + add_zero(d_parts[1]) + DATE_SEP + d_parts[0].substring(2));
}

//**************************

function getGridContainerTemplate() {
	var bs_w = getBsWidthClass();
	var lb_cl = getBsClass(bs_w, 4);
	var ctrl_cont_cl = getBsClass(bs_w, 8);
	var f_set = getBsClass(bs_w, 4);
	
	return 	`<div>
			<div id="grid_cmd" class="row">
				<div class="`+f_set+`">
					<label for="ord_fields" class="`+lb_cl+` fieldLabel">Сортировать по: </label>
					<div class ="`+ctrl_cont_cl+`">
						<select id="ord_fields" class="form-control">
							<option value="study_prog_name">Программа обучения</option>
							<option value="study_type">Вид обучения</option>
							<option value="post">Должность</option>
							<option value="work_place">Место работы</option>
							<option value="issue_date">Дата выдачи</option>
							<option value="end_date" selected="selected">Дата окончания</option>
							<option value="organization">Организация</option>
						</select>				
					</div>
				</div>
				<div class="`+f_set+`">
					<label for="ord_directs" class="`+lb_cl+` fieldLabel">Порядок: </label>
					<div class ="`+ctrl_cont_cl+`">
						<select id="ord_directs" class="form-control">
							<option value="asc">По возрастанию</option>
							<option value="desc" selected="selected">По убывания</option>
						</select>				
					</div>	
				</div>

				<div class ="`+f_set+`">
					<label for="search" class="`+lb_cl+` fieldLabel">Найти: </label>
					<div class ="`+ctrl_cont_cl+`">
						<input type="text" id="search" class="form-control" placeholder="Строка поиска"/>				
					</div>
				</div>		
			</div>
			<div class="dataGridContainer">
				<table id="dataGrid" class="table table-bordered table-responsive table-striped">`+getGridTemplate()+`
				</table>
			</div>	
		</div>`;
}

function getGridTemplate() {
	return 	`<thead>
			<tr>
				<th>Программа обучения</th>
				<th>Вид обучения</th>
				<th>Должность</th>
				<th>Место работы</th>
				<th>Дата выдачи</th>
				<th>Дата окончания</th>
				<th>Организация</th>
			</tr>
		</thead>
		<tbody>
		{{#rows}}
			<tr cert_id="{{id}}" class="doc_cert">
				<td>{{study_prog_name}}</td>
				<td>{{study_type}}</td>
				<td>{{post}}</td>
				<td>{{work_place}}</td>
				<td>{{issue_date}}</td>
				<td>{{end_date}}</td>
				<td>{{organization}}</td>
			</tr>			
		{{/rows}}
		</tbody>`;
}

function getCardTemplate() {
	return `{{#rows}}
	<div class="block-body">
                    <div class="back-side container" cert_id="{{id}}">
                        <div class="back-side__background">
                            <div class="back-side__background--left"></div>
                            <div class="back-side__background--right"></div>
                            <div class="line-first {{CERT_CLASS}}"></div>
                            <div class="line-second {{CERT_CLASS}}"></div>
                            <div class="line-third line"></div>
                            <div class="line-fourth line"></div>
                        </div>
                        <div class="back-side__content">
                            <div class="back-side__content-body--top">
                                <div class="body__top-course--name">
                                    <span>
                                       {{study_prog_name}}
                                    </span>
                                </div>
                            </div>
                            <div class="back-side__content-body--bottom">
                                <div class="body__left">
                                    <div class="body__left-study--programm">
                                    	{{study_type}}
                                    </div>
                                
                                    <div class="body__left-post--user">
                                        Должность:
                                        <div>
                                        	{{post}}
                                        </div>
                                    </div>
                                    <div class="body__left-worl--place">
                                        Место работы: {{work_place}}
                                    </div>
                                </div>
                                <div class="body__right">
                                    <div class="body__right-date--start">
                                        <div><span>Выдан:</span></div>
                                        <div style="overflow-wrap: anywhere">
                                        	{{issue_date}}
                                        </div>
                                    </div>
                                    <div class="body__right-organiztion">
                                        <div>Аттестован в:</div>
                                        <div>
                                        	{{organization}}
                                        </div>
                                    </div>
                                    <div class="body__right-date--end">
                                        <div>Сроком до:</div>
                                        <div>
                                        	{{end_date}}																					
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
	{{/rows}}`;
}
