Ext.define('BrainFightsConsole.model.AnswersModel', {
    extend: 'Ext.data.Model',
    idProperty: 'answerId',
    fields: [
		{ name: 'answerId', type: 'int' },
		{ name: 'name'},
		{ name: 'correct'},

	],
	belongsTo: [
        { 
        	model: 'BrainFightsConsole.model.QuestionModel', 
        	associationKey: 'id',
        	primaryKey: 'answerId',
        	foreignKey: 'id',
		}
    ],
});