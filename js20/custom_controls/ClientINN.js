/** Copyright (c) 2022
	Andrey Mikhalevich, Katren ltd.
 */
function ClientINN(id,options){
	options = options || {};
	options.isEnterprise = true;
	options.labelCaption = "ИНН:";
	options.placeholder = "ИНН организации";	
	
	this.m_mainView = options.mainView;
	
	var self = this;
	options.buttonSelect = new ButtonOrgSearch(id+":btnOrgSearch",{
		"viewContext":self.m_mainView,
		"onGetData":function(model){
			this.applyResult(model);
			self.m_mainView.getElement("name_full").reset();
			self.m_mainView.getElement("name").fillFullName();
			if(self.m_mainView&&self.m_mainView.m_mainView&&self.m_mainView.m_mainView.calcFillPercent)self.m_mainView.m_mainView.calcFillPercent();
		}
		
	});
	
	ClientINN.superclass.constructor.call(this,id,options);	
}
extend(ClientINN,EditINN);

