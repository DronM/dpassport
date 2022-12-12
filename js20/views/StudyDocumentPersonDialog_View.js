/**	
 * @author Andrey Mikhalevich <katrenplus@mail.ru>, 2022

 * @extends ViewObjectAjx
 * @requires core/extend.js  

 * @class
 * @classdesc
 
 * @param {string} id - Object identifier
 * @param {Object} options
 */
function StudyDocumentPersonDialog_View(id,options){	

	options = options || {};
	var model = (options.models&&options.models.StudyDocumentDialog_Model)? options.models.StudyDocumentDialog_Model : new StudyDocumentDialog_Model();
	options.templateOptions = {}
	var doc_id, file_id;
	if(model.getNextRow()){
		var fields = model.getFields();
		doc_id = fields["id"].getValue();
		for(var id in fields){
			var v = fields[id].getValue();
			
			if(id == "attachments"){
				if(v && v.length){
					file_id = v[0].id;
					v = v[0].dataBase64;					
				}
			
			}else if(fields[id].getDataType() == Field.prototype.DT_DATE){
				v = DateHelper.format("d/m/y", v);
			}
			
			options.templateOptions[id] = v;
		}
		options.templateOptions["name_full"] = fields["name_second"].getValue();
		var n = fields["name_first"].getValue();
		if(n && n.length){
			options.templateOptions["name_full"]+=" "+n;
		}
		var n = fields["name_middle"].getValue();
		if(n && n.length){
			options.templateOptions["name_full"]+=" "+n;
		}
		
	}
	options.template = window.getApp().getTemplate("StudyDocumentPersonDialog_View");
	StudyDocumentPersonDialog_View.superclass.constructor.call(this, id, "DIV", options);
	
	//downloadable attachment
	if(file_id && doc_id){
		var self = this;
		var n = document.getElementById(this.getId()+":attachment");
		if(n){
			EventHelper.add(n, "click", (function(docId, fileId, onDownloadAttachment){
				return function(e){
					onDownloadAttachment(docId, fileId);
					e.stopPropagation();
				}			
			})(doc_id, file_id, options.onDownloadAttachment));
		}
	}
}

extend(StudyDocumentPersonDialog_View, ControlContainer);

