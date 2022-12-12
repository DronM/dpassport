<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="format_date">
	<xsl:param name="val"/>
	<xsl:param name="yearFormat"/>
	<xsl:choose>
		<xsl:when test="string-length($val)=10">
			<xsl:variable name="val_year">
			<xsl:choose>
			<xsl:when test="$yearFormat=2">
				<xsl:value-of select="substring($val,2,2)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-before($val,'-')"/>
			</xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			<xsl:variable name="part_month" select="substring-after($val,'-')"/>
			<xsl:variable name="val_month" select="substring-before($part_month,'-')"/>
			<xsl:variable name="part_date" select="substring-after($part_month,'-')"/>
			<xsl:variable name="val_date" select="$part_date"/>
			<xsl:value-of select="concat($val_date,'.',$val_month,'.',$val_year)" />
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$val" />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="/document">
<xsl:variable name="VERSION" select="/document/model[@id='Response']/row/app_version"/>        
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Сертификаты пользователя</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"/>
        <link rel="stylesheet" href="pd_css/style.css?{$VERSION}_1" />
        <link rel="stylesheet" href="pd_css/p_style.css?{$VERSION}_1" />
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" />
        <link
            href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;700&amp;display=swap"
            rel="stylesheet"
        />
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
	<script src="js20/ext/mustache/mustache.min.js"></script>        	        	
        
        <script src='js20/pd.js?{$VERSION}3'></script>
    </head>
    <body onload="pageLoad();">
        <div id="dataWrapper" class="wrapper">
            <div class="user-info">
            	<xsl:variable name="user" select="/document/model[@id='User']/row"/>
                <div class="user-info--container">
                    <div class="user-fio">
                        <span>ФИО: </span><xsl:value-of select="$user/name_full"/>
                    </div>
                    <div class="user-id">ID: <xsl:value-of select="$user/id"/></div>
                </div>
                 <div class="view_type--container">
                 	<span>Вариант представления данных:</span>
                 	<span class="viewTypeCont">
				<input type="radio" id="view_type_card" name="view_type" value="card" checked="checked" class="viewTypeItem"/>
				<label for="view_type_card">Карточки</label>
				
				<input type="radio" id="view_type_grid" name="view_type" value="grid" class="viewTypeItem"/>
				<label for="view_type_grid">Таблица</label>
			</span>
                 </div>
            </div>
        
            <div class="setka dataContainer">
	    <xsl:choose>
	    <xsl:when test="not(/document/model[@id='Response']/row/result='0')">
	            <xsl:apply-templates select="/document/model[@id='Response']"/>
	    </xsl:when>
	    <xsl:otherwise>
	        <xsl:apply-templates select="/document/model[@id='StudyDocumentList_Model']"/>
            </xsl:otherwise>
            </xsl:choose>
            </div> 
        </div>
        
        <!-- error -->
	<div id="error_dlg" class="modal fade" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-body">			
					<div class="row">
						<div class="alert alert-danger alert-styled-left">
							<p id="f_error"/>
						</div>				  
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
				</div>
			</div>
        	</div>
        </div>
        
        
        <!-- details -->
	<div id="details_dlg" class="modal fade" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">×</button>
					<h4 class="modal-title">Данные сертификата</h4>
				</div>
				<div class="modal-body">			
						<div class="row">
							<label class="control-label col-lg-5">Дата выдачи:</label>
							<div id="f_issue_date" class="col-lg-4"></div>				  
						</div>
					<div class="row">
						<label class="control-label col-lg-5">Дата окончания:</label>
						<div id="f_end_date" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Аттестуемая должность:</label>
						<div id="f_post" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Место работы:</label>
						<div id="f_work_place" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Аттестуемая организация:</label>
						<div id="f_organization" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Вид обучения:</label>
						<div id="f_study_type" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Серия документа:</label>
						<div id="f_series" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Номер документа:</label>
						<div id="f_number" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Название программы обучения:</label>
						<div id="f_study_prog_name" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Наименование профессии:</label>
						<div id="f_profession" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Регистрационный номер документа:</label>
						<div id="f_reg_number" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Срок обучения:</label>
						<div id="f_study_period" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<label class="control-label col-lg-5">Наименование квалификации:</label>
						<div id="f_qualification_name" class="col-lg-4"></div>				  
					</div>
					<div class="row">
						<img id="f_pic" src="" title="Сертификат, кликните для открытия"
							style="width:200px;height:200px;cursor:pointer;margin: 10px 10px;">
						</img> 
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Закрыть</button>
				</div>
			
			</div>
		</div>
	</div>
	
    </body>
</html>		
</xsl:template>

<xsl:template match="model[@id='Response']/row">
        <div class="block-body error">
            <div class="back-side container">
                <div class="back-side__background">
                    <div class="back-side__background--left"></div>
                    <div class="back-side__background--right"></div>
                    <div class="line-first line"></div>
                    <div class="line-second line"></div>
                    <div class="line-third line"></div>
                    <div class="line-fourth line"></div>
                </div>
                <div class="back-side__content">
                    <div class="error-block"> <xsl:value-of select="descr"/></div>
                </div>
            </div>
        </div>
</xsl:template>

<xsl:template match="model[@id='StudyDocumentList_Model']/row">
	<xsl:variable name="cert_id" select="id"/>
	<xsl:variable name="cert_class">
	<xsl:choose>
	<xsl:when test="overdue='true'">
		<xsl:value-of select="'line overdue'"/>	
	</xsl:when>
	<xsl:when test="month_left='true'">
		<xsl:value-of select="'line month-left'"/>	
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="'line'"/>	
	</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>
                <div class="block-body">
                    <div class="back-side container" cert_id="{$cert_id}">
                        <div class="back-side__background">
                            <div class="back-side__background--left"></div>
                            <div class="back-side__background--right"></div>
                            <div class="line-first {$cert_class}"></div>
                            <div class="line-second {$cert_class}"></div>
                            <div class="line-third line"></div>
                            <div class="line-fourth line"></div>
                        </div>
                        <div class="back-side__content">
                            <div class="back-side__content-body--top">
                                <div class="body__top-course--name">
                                    <span>
                                        <xsl:value-of select="study_prog_name"/>
                                    </span>
                                </div>
                            </div>
                            <div class="back-side__content-body--bottom">
                                <div class="body__left">
                                    <div class="body__left-study--programm">
                                        <xsl:value-of select="study_type"/>
                                    </div>
                                
                                    <div class="body__left-post--user">
                                        Должность:
                                        <div>
                                            <xsl:value-of select="post"/>
                                        </div>
                                    </div>
                                    <div class="body__left-worl--place">
                                        Место работы: <xsl:value-of select="work_place"/>
                                    </div>
                                </div>
                                <div class="body__right">
                                    <div class="body__right-date--start">
                                        <div><span>Выдан:</span></div>
                                        <div style="overflow-wrap: anywhere">
						<xsl:call-template name="format_date">
							<xsl:with-param name="val" select="issue_date"/>
							<xsl:with-param name="yearFormat" select="4"/>
						</xsl:call-template>																					
                                        </div>
                                    </div>
                                    <div class="body__right-organiztion">
                                        <div>Аттестован в:</div>
                                        <div>
                                        	<xsl:value-of select="organization"/>
                                        </div>
                                    </div>
                                    <div class="body__right-date--end">
                                        <div>Сроком до:</div>
                                        <div>
						<xsl:call-template name="format_date">
							<xsl:with-param name="val" select="end_date"/>
							<xsl:with-param name="yearFormat" select="4"/>
						</xsl:call-template>																					
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- <div class="error-block">some ERROR</div> -->
                </div>
</xsl:template>

</xsl:stylesheet>
