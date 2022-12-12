<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="ViewBase.html.xsl"/>

<xsl:template match="/document">
<html>
	<head>
		<xsl:call-template name="initHead"/>		
		
		<script>		
			function pageLoad(){
			
				<xsl:call-template name="initApp"/>
				
				var view = new Registration_View("Registration");
				view.toDOM();
			}
		</script>		
		
	</head>
	<body onload="pageLoad();" class="login-container">

	<xsl:call-template name="page_header"/>

	<!-- Page container -->
	<div class="page-container">

		<!-- Page content -->
		<div class="page-content">

			<!-- Main content -->
			<div class="content-wrapper">

				<!-- Content area -->
				<div class="content">

					<div class="row">
						<div id="windowData" class="col-lg-12">

							<div id="Registration" class="panel panel-white">
								<div class="panel-heading">
									<h6 class="panel-title">Регистрация пользователя</h6>
								</div>
								<form id="Registration:form" class="stepy-basic hidden">
									<fieldset title="1">
										<legend class="text-semibold">Организация</legend>
										<div calss="row">
											<div id="Registration:inn"/>
										</div>
										<div class="row">
											<div class="col-lg-4">
											</div>
											<div class="col-lg-3">
												<div id="Registration:captchaCheckInn"/>
											</div>
										</div>
										<div id="Registration:org_registered" class="alert alert-info alert-styled-left alert-bordered hidden">
											<h6>Организация найдена
											</h6>
											<div>Проверьте данные и переходите на следующую страницу
											</div>												
										</div>											
										
										<div id="Registration:attrs" class="hidden">
											<div class="row">
												<div id="Registration:name" />
											</div>
											<div class="row">
												<div id="Registration:name_full" />
											</div>	
											<div class="row">
												<div id="Registration:ogrn" />
											</div>	
											<div class="row">
												<div id="Registration:kpp" />
											</div>	
											<div class="row">
												<div id="Registration:post_address" />
											</div>	
											<div class="row">
												<div id="Registration:legal_address" />
											</div>	
											<div class="row">
												<div id="Registration:okpo" />
											</div>	
											<div class="row">
												<div id="Registration:okved" />
											</div>													
										</div>
										
										<div id="Registration:org_error" class="alert alert-danger alert-styled-left hidden">
										</div>
									</fieldset>
									
									<fieldset title="2">
										<legend class="text-semibold">Оферта</legend>
										<div id="Registration:org_exists" class="alert alert-info alert-styled-left alert-bordered hidden">
											<p>Организация зарегистрирована ранее</p>
											<p id="Registration:org_exists:payed" class="hidden">Оплаченный период: <span id="Registration:org_exists:period"></span>
											</p>
											<p id="Registration:org_exists:not_payed" class="hidden">Доступ не оплачен.
											</p>
										</div>
										<div id="Registration:org_offer" class="alert alert-info alert-styled-left alert-bordered hidden">
											<p>Организация регистрируется впервые</p>
											<p>Необходимо ...</p>
											<br></br>
											<br></br>
											<textarea id="Registration:org_offer:text" rows="10" style="width:100%;" disabled="disabled"></textarea>
											<div>
												<input id="Registration:org_offer:agreed" type="checkbox"/>
												<label for="Registration:org_offer:agreed">Согласен</label>
											</div>
										</div>
									</fieldset>
									
									<fieldset title="3">
										<legend class="text-semibold">Персональные данные</legend>
										<div calss="row">
											<div id="Registration:user_name"/>
										</div>
										<div calss="row">
											<div id="Registration:user_name_full"/>
										</div>
										<div calss="row">
											<div id="Registration:user_post"/>
										</div>
										<div calss="row">
											<div id="Registration:user_snils"/>
										</div>
										<div calss="row">
											<div id="Registration:user_sex"/>
										</div>	
										<div class="row">
											<div class="col-lg-4">
											</div>
											<div class="col-lg-3">
												<div id="Registration:captchaRegister"/>
											</div>
										</div>
										<div id="Registration:user_error" class="alert alert-danger alert-styled-left hidden">
										</div>										
									</fieldset>
								
									<a id="Registration:submit" href="#" class="stepy-finish btn btn-primary">Завершить</a>	
								</form>
								
								<div id="Registration:user_registered" class="alert alert-info alert-styled-left hidden">
									<p>Пользователь зарегистрирован, ждите активации
									</p>
								</div>
								
							</div>
						</div>
						
						<div class="windowMessage hidden">
						</div>
						<!--waiting  -->
						<div id="waiting">
							<div>Обработка...</div>
							<img src="img/loading.gif"/>
						</div>
						
					</div>
					<!-- Footer -->
					<div class="footer text-muted text-center">
						2022. <a href="#"></a>
					</div>
					<!-- /footer -->

				</div>
				<!-- /content area -->

			</div>
			<!-- /main content -->

		</div>
		<!-- /page content -->

	</div>
	<!-- /page container -->
		
	<script>
			var n = document.getElementById("Registration:user");
			if (n){
				if (document.activeElement &amp;&amp; document.activeElement.id!="Registration:user"){
					n.focus();
				}
			}
	</script>
		
		<xsl:call-template name="initJS"/>
	</body>
</html>		
</xsl:template>

</xsl:stylesheet>
