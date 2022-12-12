/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends EditFile
 * @requires core/extend.js
 * @requires controls/EditFile.js     

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {object} options
 */
function UserPhotoEdit(id,options){
	options = options || {};	
	
	options.labelCaption = "Фотография:";
	options.showHref = false;
	options.showPic = true;
	options.fileInfTemplateOptions = {
		"IMG_CLASS": "userPhoto"
	}
	
	this.m_view = options.view;
	
	var self = this;
	
	options.onDeleteFile = function(fileId){
		self.deletePhoto(fileId);
	};
	options.onFileAdded = function(fileId){
		self.photoAdded(fileId);
	}
	options.allowedFileExtList = "jpg,jpeg,png";
	
	UserPhotoEdit.superclass.constructor.call(this, id, options);
}
//ViewObjectAjx,ViewAjxList
extend(UserPhotoEdit, EditFile);

/* Constants */


/* private members */

/* protected*/


/* public methods */

UserPhotoEdit.prototype.deletePhoto = function(fileId){
	var ctrl_id = this.m_view.getElement("id");
	if(ctrl_id){
		var id = ctrl_id.getValue();
		if(!id){
			return;
		}
		var self = this;
		var pm = (new User_Controller()).getPublicMethod("delete_photo");
		pm.setFieldValue("user_id", id);
		pm.run({
			"ok":function(resp){
				var ctrl = self.m_view.getElement("photo");
				if(ctrl){
					ctrl.reset();
				}
			}
		});
	}
}

UserPhotoEdit.prototype.photoAdded = function(fileId){
	//alert("Photo added")
	if(!window["FileReader"]){
		return;
	}
	var fl = this.m_view.getElement("photo").getValue();
	if(!fl || !fl.length){
		return;
	}
	var reader = new FileReader();
	reader.readAsDataURL(fl[0]);
	reader.onload = function () {
		//console.log();//base64encoded string
		var n = document.getElementById(fileId+"-preview");
		if(n){
			n.src = reader.result;
			//"data:image/png;base64, "+
		}
		//status
		var n = document.getElementById(fileId+"-pic");
		if(n){
			n.setAttribute("class", "glyphicon glyphicon-ok");
		}
	};
	reader.onerror = function (error) {
		throw new Error(error);
	};
}

