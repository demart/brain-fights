Ext.define('BrainFightsConsole.model.AnswersModel', {
    extend: 'Ext.data.Model',
    idProperty: 'id',
    fields: [
		{ name: 'id', type: 'int' },
		{ name: 'name'},
		{ name: 'correct'},
	],
	belongsTo: [
        { 
        	model: 'BrainFightsConsole.model.QuestionModel', 
        	associationKey: 'id',
        	primaryKey: 'id',
        	foreignKey: 'id',
		}
    ],
});