/** Copyright (c) 2022
	Andrey Mikhalevich, Katren ltd.
 */
function NameEdit(id,options){
	options = options || {};
	
//	options.regExpression = "^\[А-Яа-я]$";
	//options.regExpressionInvalidMessage = "Не соответствует шаблону";
	
	options.events = options.events || {};
	options.events.keyup = function(){
		var v = this.m_node.value;
		if(v && v.length==1 && v[0]!=v[0].toUpperCase()){
			this.m_node.value = v.toUpperCase();
		}
	};
	
	NameEdit.superclass.constructor.call(this,id,options);	
}
extend(NameEdit, EditString);

