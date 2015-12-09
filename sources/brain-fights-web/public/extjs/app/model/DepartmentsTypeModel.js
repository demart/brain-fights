Ext.define('BrainFightsConsole.model.DepartmentsTypeModel', {
    extend: 'Ext.data.Model',
    idProperty: 'id',
    fields: [
		{ name: 'id', type: 'int'}, 
		{ name: 'name'},
		{ name: 'createdDate'},
		{ name: 'modifiedDate'},
		

	],
});