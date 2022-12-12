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
								<ul class="stepy-header">
									<li class="stepy-active">
										<div>1</div>
										<span>Организация</span>
									</li>
									<li class="">
										<div>2</div>
										<span>Оферта</span>
									</li>
									<li class="">
										<div>2</div>
										<span>Персональные данные</span>
									</li>
								
								
								</ul>
									<div class="steps clearfix">
										<ul role="tablist">
											<li role="tab" class="first current" aria-disabled="false" aria-selected="true">
												<a id="steps-uid-0-t-0" href="#steps-uid-0-h-0"
													aria-controls="steps-uid-0-p-0">											
													<span class="number">1</span> Организация
												</a>
											</li>
											<li role="tab" class="disabled" aria-disabled="true">
												<a id="steps-uid-0-t-1" href="#steps-uid-0-h-1" aria-controls="steps-uid-0-p-1">
													<span class="number">2</span> 
												</a>
											</li>
											<li role="tab" class="disabled" aria-disabled="true">
												<a id="steps-uid-0-t-2" href="#steps-uid-0-h-2" aria-controls="steps-uid-0-p-2">
													<span class="number">3</span> Персональные данные
												</a>
											</li>
										</ul>
									</div>
									
									<div class="content clearfix">
										<h6 id="steps-uid-0-h-0" tabindex="-1" class="title current">Организация</h6>
										<fieldset id="steps-uid-0-p-0" class="body current" role="tabpanel" aria-labelledby="steps-uid-0-h-0"
										aria-hidden="false" style="display: block;">
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
										
										<h6 id="steps-uid-0-h-1" tabindex="-1" class="title current">Оферта</h6>
										<fieldset id="steps-uid-0-p-1" class="body" role="tabpanel" aria-labelledby="steps-uid-0-h-1"
										aria-hidden="true" style="display: none;">
											<div calss="row">
												<div id="Registration:offer"/>
											</div>
										</fieldset>

										<h6 id="steps-uid-0-h-2" tabindex="-1" class="title current">Персональные данные</h6>
										<fieldset id="steps-uid-0-p-2" class="body" role="tabpanel" aria-labelledby="steps-uid-0-h-2"
										aria-hidden="true" style="display: none;">
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
										
									</div>
									
									<div class="actions clearfix">
										<ul role="menu" aria-label="Pagination">
											<li aria-hidden="false" aria-disabled="false">
												<a id="Registration:nextStep" href="#next" role="menuitem">Следующая</a>
												<i class="icon-arrow-right14 position-right"></i>												
											</li>
											<li style="display: none;" aria-hidden="true">
												<a id="Registration:finishStep" href="#finish" role="menuitem">Завершить</a>
											</li>
										</ul>							
									</div>
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
