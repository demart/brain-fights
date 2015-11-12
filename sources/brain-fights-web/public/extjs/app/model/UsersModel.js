Ext.define('BrainFightsConsole.model.UsersModel', {
    extend: 'Ext.data.Model',
    idProperty: 'id',
    fields: [
		{ name: 'id', type: 'int'}, 
		{ name: 'type'},
		{ name: 'name'}, 
		{ name: 'position'},
		{ name: 'login'},
		{ name: 'email'},
		{ name: 'password'},
		{ name: 'score'},
		{ name: 'totalGames'},
		{ name: 'activityTime', type: 'date'},
		{ name: 'registeredTime', type: 'date'},
	],
});