<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" 
 xmlns:html="http://www.w3.org/TR/REC-html40"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:import href="functions.xsl"/>

<xsl:output method="html" indent="yes"
			doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" 
			doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

<xsl:variable name="VERSION" select="/document/model[@id='ServerVars']/row[1]/scriptId"/>

<!-- Main template-->
<xsl:template match="/">
<html>
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta name="viewport" content="width=device-width, initial-scale=1" />
		<xsl:apply-templates select="document/model[@id='Link']/row"/>
		
		<title>Тюменьстрой</title>	
	</head>	
	<body>
	<xsl:apply-templates select="document/model[@id='Response']"/>
	<xsl:apply-templates select="document/model[@id='Head_Model']"/>
	<xsl:apply-templates select="document/model[@id='MaterialList_Model']"/>				
	</body>
</html>	
</xsl:template>

<xsl:template match="model">	
</xsl:template>

<xsl:template match="model[@id='Link']/row">	
	<link rel="stylesheet" href="{concat(href,'?',$VERSION)}" type="text/css"/>
</xsl:template>


</xsl:stylesheet>
