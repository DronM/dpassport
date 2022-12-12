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
				
				var view = new StudyDocumentInsert_View("StudyDocumentInsert");
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

							<div id="StudyDocumentInsert" class="panel panel-white hidden">
								<div class="panel-heading">
									<h6 class="panel-title">Добавление сертификатов</h6>
								</div>
								<form id="StudyDocumentInsert:form" class="stepy-basic">
									<fieldset title="1">
										<legend class="text-semibold">Компания</legend>
										<div calss="row">
											<div id="StudyDocumentInsert:companies_ref"/>
										</div>
									</fieldset>
									
									<fieldset title="2">
										<legend class="text-semibold">Протокол</legend>
										<div calss="row">
											<div id="StudyDocumentInsert:register_date"/>
										</div>
										<div calss="row">
											<div id="StudyDocumentInsert:register_name"/>
										</div>
										<div calss="row">
											<div id="StudyDocumentInsert:register_attachment"/>
										</div>
										
									</fieldset>
									
									<fieldset title="3">
										<legend class="text-semibold">Сертификаты</legend>
										<div calss="row">
											<div id="StudyDocumentInsert:document_list"/>
										</div>
									</fieldset>

									<fieldset title="4">
										<legend class="text-semibold">Сканы</legend>
										<div calss="row">
											<div id="StudyDocumentInsert:attachment_list"/>
										</div>
									</fieldset>
								
									<a id="Registration:submit" href="#" class="stepy-finish btn btn-primary">Завершить</a>	
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
		
		<xsl:call-template name="initJS"/>
	</body>
</html>		
</xsl:template>

</xsl:stylesheet>
