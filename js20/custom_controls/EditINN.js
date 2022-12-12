/** Copyright (c) 2022
	Andrey Mikhalevich, Katren ltd.
 */
function EditINN(id,options){
	options = options || {};
	options.labelCaption = options.labelCaption || "ИНН:";
	options.title = options.title || "ИНН организации или ИП";	
	options.placeholder = options.placeholder || "ИНН организации или ИП";
	options.maxLength = 12;
	
	EditINN.superclass.constructor.call(this,id,options);	
}
extend(EditINN, EditNum);

EditINN.prototype.validate = function(){
	if(!EditINN.superclass.validate.call(this)){
		return false;
	}
	var res = true;
	var v = this.getValue();
	if(v.length!=10 && v.length!=12){
		this.setNotValid("Должно быть 10 или 12 символов");
		res = false;
	}
	return res;
}

