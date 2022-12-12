function UserPhotoManager(options){	
	this.m_view = options.view;
}

UserPhotoManager.prototype.ALLOWED_EXT_LIST = "jpg,jpeg,png";

UserPhotoManager.prototype.deleteAttachmentCont = function(fileId, callBack){
	var pm = (new User_Controller()).getPublicMethod("delete_file");
	pm.setFieldValue("study_documents_ref", this.getStudyDocumentsRefAsStr());
	pm.setFieldValue("content_id", fileId);
	pm.run({
		"ok":function(){
			if(callBack){
				callBack();
			}
		}
	});
}

