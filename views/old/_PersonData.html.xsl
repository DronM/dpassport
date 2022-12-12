<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="ViewBase.html.xsl"/>

<xsl:template match="/document">
<html>
	<head>
		<xsl:call-template name="initHead"/>		
		
		<script>
			<xsl:call-template name="modelFromTemplate"/>		
			function pageLoad(){
				<xsl:call-template name="initApp"/>
				
				<xsl:call-template name="checkForError"/>
								
				showView();
			}
		</script>		
		
	</head>
	<body onload="pageLoad();" class="sidebar-xs">

	<xsl:call-template name="page_header"/>

	<!-- Page container -->
	<div class="page-container">

		<!-- Page content -->
		<div class="page-content">

			<!-- Main sidebar -->
			<div class="sidebar sidebar-main">
				<div class="sidebar-content">
					<xsl:call-template name="initMenu"/>					
				</div>
			</div>

			<!-- Main content -->
			<div class="content-wrapper">
				<!-- Content area -->
				<div class="content">
					<div class="row">
						<div id="windowData" class="col-lg-12">
							<xsl:apply-templates select="model[@htmlTemplate='TRUE']"/>
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
