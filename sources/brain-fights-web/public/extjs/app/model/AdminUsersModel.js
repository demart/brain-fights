Ext.define('BrainFightsConsole.model.AdminUsersModel', {
    extend: 'Ext.data.Model',
    idProperty: 'id',
    fields: [
		{ name: 'id', type: 'int'}, 
		{ name: 'name'},
		{ name: 'login'},
		{ name: 'password'},
		{ name: 'role'},
		{ name: 'isEnabled'},
		{ name: 'createdDate', type: 'date'},
	],
});