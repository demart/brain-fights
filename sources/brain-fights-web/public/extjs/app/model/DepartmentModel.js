Ext.define('BrainFightsConsole.model.DepartmentModel', {
    extend: 'Ext.data.Model',
    idProperty: 'id',
    fields: [
		{ name: 'id', type: 'int'}, 
		{ name: 'name'},
	],
});