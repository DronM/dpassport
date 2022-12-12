function AttachmentManager(options){	
	this.m_view = options.view;
	this.m_dataType = options.dataType;
	
	this.m_attachmentViewName = options.attachmentViewName || "attachments";
}

AttachmentManager.prototype.getStudyDocumentsRefAsStr = function(){
	return CommonHelper.serialize(new RefType({"keys":{"id": this.m_view.getElement("id").getValue()}, "dataType": this.m_dataType}));
}

AttachmentManager.prototype.downloadAttachment = function(fileId){
	var pm = (new StudyDocumentAttachment_Controller()).getPublicMethod("get_file");
	pm.setFieldValue("study_documents_ref", this.getStudyDocumentsRefAsStr());
	pm.setFieldValue("content_id", fileId);
	pm.setFieldValue("inline",1);
	//pm.download();
	var offset = 0;
	var h = $( window ).width()/3*2;
	var left = $( window ).width()/2;
	var w = left - 20;	
	pm.openHref("ViewXML", "location=0,menubar=0,status=0,titlebar=0,top="+(50+offset)+",left="+(left+offset)+",width="+w+",height="+h);
	
}

AttachmentManager.prototype.addAttachmentCont = function(fl){
	var self = this;
	var pm = (new StudyDocumentAttachment_Controller()).getPublicMethod("add_file");
	pm.setFieldValue("study_documents_ref", this.getStudyDocumentsRefAsStr());
	pm.setFieldValue("content_info", CommonHelper.serialize({"id": fl.file_id, "name": "", "size": 0}));
	pm.setFieldValue("content_data", [fl]);
	pm.run({
		"ok":function(resp){
			var m = resp.getModel("Preview_Model");
			var preview_data;
			if(m && m.getNextRow()){
				preview_data = m.getFieldValue("cont");
			}
			self.setAttachmentUploaded(fl, preview_data);
		}
		,"fail":function(resp,errCode,errStr){
			self.setAttachmentUploadError(fl);
			throw new Error("Ошибка загрузки файла: "+errStr);
		}
	});
}

AttachmentManager.prototype.addAttachment = function(fileId){
	var list = this.m_view.getElement(this.m_attachmentViewName).getFiles();
	if(!list || !list.length)return;
	var fl = list[list.length-1];
	
	if (this.m_view.getCmd() != "insert"){// && !this.m_view.getModified()
		this.addAttachmentCont(fl);
	}
	else{	
		var self = this;
		this.m_view.getControlOK().setEnabled(false);		
		this.m_view.onSave(
			function(){
				self.addAttachmentCont(fl);
			},
			null,
			function(){
				self.m_view.getControlOK().setEnabled(true);		
			}
		);			
	}
}	

AttachmentManager.prototype.setAttachmentUploaded = function(fl, previewData){
	var n = document.getElementById(fl.file_id+"-pic");
	if(n){
		n.className = "glyphicon glyphicon-ok";
		n.title = "Файл прикреплен к документу";
	}
	var n = document.getElementById(fl.file_id+"-href");
	if(n){
		n.setAttribute("file_uploaded","true");
	}	
	var n = document.getElementById(fl.file_id+"-del");
	if(n){
		n.setAttribute("file_uploaded","true");
	}	
	
	fl.uploaded = true;
	
	var n = document.getElementById(fl.file_id+"-preview");
	if(n&&previewData){
		n.setAttribute("src","data:image/png;base64, "+previewData);
	}
}

AttachmentManager.prototype.setAttachmentUploadError = function(fl){
	var n = document.getElementById(fl.file_id+"-pic");
	if(n){
		n.className = "glyphicon glyphicon-remove";
		n.title = "Ошибка загрузки файла";
	}
}

AttachmentManager.prototype.deleteAttachmentCont = function(fileId, callBack){
	var pm = (new StudyDocumentAttachment_Controller()).getPublicMethod("delete_file");
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

AttachmentManager.prototype.deleteAttachment = function(fileId,callBack){
	var self = this;
	WindowQuestion.show({
		"text":"Удалить файл?",
		"cancel":false,
		"callBack":function(res){			
			if (res==WindowQuestion.RES_YES){
				self.deleteAttachmentCont(fileId,callBack);
			}
		}
	});
}


