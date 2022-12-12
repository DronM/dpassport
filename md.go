package main

/**
 * THIS FILE IS GENERATED FROM TEMPLATE build/templates/controllers/md.go.tmpl
 * ALL DIRECT MODIFICATIONS WILL BE LOST WITH THE NEXT BUILD PROCESS!!!
 */

import (
	"encoding/gob"
	
	"dpassport/controllers"
	"dpassport/models"
	"dpassport/constants"

	"osbe"
	"osbe/permission"
	"osbe/about"
	"osbe/stat"
	"osbe/model"
	"osbe/evnt"
	osbe_const "osbe/constants"	
)

func initMD() *osbe.Metadata{

	md := osbe.NewMetadata()
	
	model.Cond_Model_init()
	
	md.Controllers["About"] = about.NewController_About()
	md.Controllers["Event"] = evnt.NewController_Event()
	md.Controllers["Permission"] = permission.NewController_Permission()
	
	md.Controllers["Constant"] = osbe_const.NewController_Constant()
	md.Models["ConstantValue"] = osbe_const.NewModelMD_ConstantValue()
	md.Models["ConstantList"] = osbe_const.NewModelMD_ConstantList()
	
	md.Controllers["SrvStatistics"] = stat.NewSrvStatistics_Controller()
	
	md.Controllers["MainMenuConstructor"] = controllers.NewController_MainMenuConstructor()
	md.Models["MainMenuConstructor"] = models.NewModelMD_MainMenuConstructor()
	md.Models["MainMenuConstructorDialog"] = models.NewModelMD_MainMenuConstructorDialog()
	md.Models["MainMenuConstructorList"] = models.NewModelMD_MainMenuConstructorList()
	
	md.Controllers["View"] = controllers.NewController_View()
	md.Models["ViewList"] = models.NewModelMD_ViewList()
	
	md.Controllers["VariantStorage"] = controllers.NewController_VariantStorage()
	md.Models["VariantStorageList"] = models.NewModelMD_VariantStorageList()
	
	md.Controllers["LoginDevice"] = controllers.NewController_LoginDevice()
	md.Models["LoginDeviceList"] = models.NewModelMD_LoginDeviceList()
	
	md.Controllers["LoginDeviceBan"] = controllers.NewController_LoginDeviceBan()
	md.Models["LoginDeviceBan"] = models.NewModelMD_LoginDeviceBan()
	
	md.Controllers["Login"] = controllers.NewController_Login()
	md.Models["Login"] = models.NewModelMD_Login()
	md.Models["LoginList"] = models.NewModelMD_LoginList()

	md.Controllers["MailMessage"] = controllers.NewController_MailMessage()
	md.Models["MailMessage"] = models.NewModelMD_MailMessage()
	md.Models["MailMessageList"] = models.NewModelMD_MailMessageList()
	
	md.Controllers["MailMessageAttachment"] = controllers.NewController_MailMessageAttachment()
	md.Models["MailMessageAttachment"] = models.NewModelMD_MailMessageAttachment()
	
	md.Controllers["MailTemplate"] = controllers.NewController_MailTemplate()
	md.Models["MailTemplate"] = models.NewModelMD_MailTemplate()
	md.Models["MailTemplateList"] = models.NewModelMD_MailTemplateList()

	//************************
	md.Controllers["TimeZoneLocale"] = controllers.NewController_TimeZoneLocale()
	md.Models["TimeZoneLocale"] = models.NewModelMD_TimeZoneLocale()
	
	md.Controllers["User"] = controllers.NewController_User()
	md.Models["User"] = models.NewModelMD_User()
	md.Models["UserDialog"] = models.NewModelMD_UserDialog()
	md.Models["UserList"] = models.NewModelMD_UserList()
	md.Models["UserProfile"] = models.NewModelMD_UserProfile()
	md.Models["UserSelect"] = models.NewModelMD_UserSelect()
	
	md.Controllers["UserMacAddress"] = controllers.NewController_UserMacAddress()
	md.Models["UserMacAddress"] = models.NewModelMD_UserMacAddress()
	md.Models["UserMacAddressList"] = models.NewModelMD_UserMacAddressList()
	
	md.Controllers["UserOperation"] = controllers.NewController_UserOperation()
	md.Models["UserOperation"] = models.NewModelMD_UserOperation()
	md.Models["UserOperationDialog"] = models.NewModelMD_UserOperationDialog()
	
	md.Controllers["ClientSearch"] = controllers.NewController_ClientSearch()
	md.Controllers["Captcha"] = controllers.NewController_Captcha()
	
	//
	md.Controllers["Client"] = controllers.NewController_Client()
	md.Models["Client"] = models.NewModelMD_Client()
	md.Models["ClientList"] = models.NewModelMD_ClientList()
	md.Models["ClientDialog"] = models.NewModelMD_ClientDialog()

	md.Controllers["ClientAccess"] = controllers.NewController_ClientAccess()
	md.Models["ClientAccess"] = models.NewModelMD_ClientAccess()
	md.Models["ClientAccessList"] = models.NewModelMD_ClientAccessList()

	md.Controllers["Company"] = controllers.NewController_Company()
	md.Models["Company"] = models.NewModelMD_Company()
	md.Models["CompanyList"] = models.NewModelMD_CompanyList()

	md.Controllers["StudyDocumentType"] = controllers.NewController_StudyDocumentType()
	md.Models["StudyDocumentType"] = models.NewModelMD_StudyDocumentType()

	md.Controllers["ObjectModLog"] = controllers.NewController_ObjectModLog()
	md.Models["ObjectModLog"] = models.NewModelMD_ObjectModLog()
	
	md.Controllers["StudyDocumentRegister"] = controllers.NewController_StudyDocumentRegister()
	md.Models["StudyDocumentRegister"] = models.NewModelMD_StudyDocumentRegister()
	md.Models["StudyDocumentRegisterList"] = models.NewModelMD_StudyDocumentRegisterList()
	md.Models["StudyDocumentRegisterDialog"] = models.NewModelMD_StudyDocumentRegisterDialog()

	md.Controllers["StudyDocument"] = controllers.NewController_StudyDocument()
	md.Models["StudyDocument"] = models.NewModelMD_StudyDocument()
	md.Models["StudyDocumentList"] = models.NewModelMD_StudyDocumentList()
	md.Models["StudyDocumentWithPictList"] = models.NewModelMD_StudyDocumentWithPictList()
	md.Models["StudyDocumentDialog"] = models.NewModelMD_StudyDocumentDialog()

	md.Controllers["StudyDocumentInsert"] = controllers.NewController_StudyDocumentInsert()
	md.Models["StudyDocumentInsert"] = models.NewModelMD_StudyDocumentInsert()
	md.Models["StudyDocumentInsertList"] = models.NewModelMD_StudyDocumentInsertList()
	md.Models["StudyDocumentInsertSelectList"] = models.NewModelMD_StudyDocumentInsertSelectList()

	md.Controllers["StudyDocumentInsertHead"] = controllers.NewController_StudyDocumentInsertHead()
	md.Models["StudyDocumentInsertHead"] = models.NewModelMD_StudyDocumentInsertHead()
	md.Models["StudyDocumentInsertHeadList"] = models.NewModelMD_StudyDocumentInsertHeadList()
	
	md.Controllers["StudyDocumentInsertAttachment"] = controllers.NewController_StudyDocumentInsertAttachment()
	md.Models["StudyDocumentInsertAttachmentList"] = models.NewModelMD_StudyDocumentInsertAttachmentList()	
	
	md.Controllers["StudyDocumentAttachment"] = controllers.NewController_StudyDocumentAttachment()
	md.Models["StudyDocumentAttachmentList"] = models.NewModelMD_StudyDocumentAttachmentList()

	md.Controllers["StudyType"] = controllers.NewController_StudyType()
	md.Models["StudyType"] = models.NewModelMD_StudyType()
	md.Controllers["Profession"] = controllers.NewController_Profession()
	md.Models["Profession"] = models.NewModelMD_Profession()
	md.Controllers["Qualification"] = controllers.NewController_Qualification()
	md.Models["Qualification"] = models.NewModelMD_Qualification()
	md.Controllers["StudyForm"] = controllers.NewController_StudyForm()
	md.Models["StudyForm"] = models.NewModelMD_StudyForm()

	md.Controllers["PersonData"] = controllers.NewController_PersonData()
	
	//
	md.Controllers["MailServer"] = controllers.NewController_MailServer()
	md.Controllers["APIServer"] = controllers.NewController_APIServer()
	md.Controllers["Server1C"] = controllers.NewController_Server1C()
	
	//
	md.Constants["grid_refresh_interval"] = constants.New_Constant_grid_refresh_interval()
	md.Constants["session_live_time"] = constants.New_Constant_session_live_time()
	md.Constants["doc_per_page_count"] = constants.New_Constant_doc_per_page_count()
	md.Constants["allowed_attachment_extesions"] = constants.New_Constant_allowed_attachment_extesions()
	md.Constants["study_document_fields"] = constants.New_Constant_study_document_fields()
	md.Constants["study_document_register_fields"] = constants.New_Constant_study_document_register_fields()
	md.Constants["mail_server"] = constants.New_Constant_mail_server()
	md.Constants["api_server"] = constants.New_Constant_api_server()
	md.Constants["client_offer"] = constants.New_Constant_client_offer()
	md.Constants["qr_code"] = constants.New_Constant_qr_code()
	md.Constants["server_1c"] = constants.New_Constant_server_1c()

	md.Version.Value = APP_VERSION

	//gob values for use in session
	gob.Register(controllers.CaptchaSessVal{})

	return md
}
