
function PersonDataBoxGridRow(id,options){
	options = options || {};	
	options.tagName = "DIV";
	options.attrs = options.attrs || {};
	options.attrs["class"] = "personDataBoxRow";
	PersonDataBoxGridRow.superclass.constructor.call(this, id, options);
}
extend(PersonDataBoxGridRow, GridRow);

function PersonDataBoxGridCell(id, options){
	options = options || {};	
	options.tagName = "DIV";
	options.attrs = options.attrs || {};
	options.attrs["class"] = "personDataBoxCell";
	PersonDataBoxGridCell.superclass.constructor.call(this, id, options);
}
extend(PersonDataBoxGridCell, GridCell);
