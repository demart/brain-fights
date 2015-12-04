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
		{ name: 'department'},
		{ name: 'imageUrl'},
		{ name: 'score', type: 'int'},
		{ name: 'totalGames'},
		{ name: 'activityTime', type: 'date'},
		{ name: 'registeredTime', type: 'date'},
	],
});