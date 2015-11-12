Ext.define('BrainFightsConsole.model.CategoryModel', {
    extend: 'Ext.data.Model',
    idProperty: 'id',
    fields: [
		{ name: 'id', type: 'int'}, 
		{ name: 'name'},
		{ name: 'color'},
		{ name: 'image'},
		{ name: 'createdDate'},
		{ name: 'modifiedDate'},
		{ name: 'isDeleted'},
	],
});