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
									<h6 class="panel-title">Регистрация сотрудника</h6>
								</div>
								<form class="stepy-basic">
									<fieldset class="stepy-step" title="1" style="display: block;">
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
											<h6>Организация успешно зарегистрирована
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
										
										<div id="Registration:org_exists" class="alert alert-danger alert-styled-left hidden">
											<h6>Данная организация уже зарегистрирована
											</h6>
											<div>Отправляйтесь...
											</div>
										</div>
									</fieldset>
									
									<fieldset class="stepy-step" title="2" style="display: none;">
										<legend class="text-semibold">Оферта</legend>
										<div calss="row">
											<div id="Registration:offer"/>
										</div>
									</fieldset>
									
									<fieldset class="stepy-step" title="3" style="display: none;">
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
											<div id="Registration:user_phone_cel"/>
										</div>
										<div calss="row">
											<div id="Registration:user_snils"/>
										</div>
										<div calss="row">
											<div id="Registration:user_sex"/>
										</div>	
									</fieldset>
									
								</form>
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
