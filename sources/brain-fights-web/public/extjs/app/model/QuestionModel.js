Ext.define('BrainFightsConsole.model.QuestionModel', {
    extend: 'Ext.data.Model',
    idProperty: 'id',
    fields: [
		{ name: 'id', type: 'int'}, 
		{ name: 'text'},
		{ name: 'type'},
		{ name: 'categoryId'},
		{ name: 'createdDate'},
		{ name: 'modifiedDate'},
		{ name: 'text'},
		{ name: 'image'},
	],
	
	hasMany: {
	    model: 'BrainFightsConsole.model.AnswersModel',
	    name: 'answers',
	    primaryKey: 'id',
		foreignKey: 'ownerId',
	},
});