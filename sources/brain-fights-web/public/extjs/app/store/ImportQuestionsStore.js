Ext.define('BrainFightsConsole.store.ImportQuestionsStore', {
    extend: 'Ext.data.Store',
    model: 'BrainFightsConsole.model.QuestionModel',
    autoLoad: false,

    proxy: {
	    type: 'ajax',
        
        reader: {
            type: 'json',
            rootProperty: 'data',
            successProperty: 'success',
            totalProperty: 'totalCount',
            idProperty: 'id'
        }
	},

});