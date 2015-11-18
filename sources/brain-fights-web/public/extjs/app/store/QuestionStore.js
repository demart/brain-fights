Ext.define('BrainFightsConsole.store.QuestionStore', {
    extend: 'Ext.data.Store',
    model: 'BrainFightsConsole.model.QuestionModel',
    autoLoad: false,
    pageSize: 23,
    proxy: {
	    type: 'ajax',
        api: {
            read: 'rest/questions/store/read',
            create: 'rest/questions/store/create',
            update: 'rest/questions/store/update',
            destroy: 'rest/questions/store/destroy'
        },
        reader: {
            type: 'json',
            rootProperty: 'data',
            successProperty: 'success',
            totalProperty: 'totalCount',
            idProperty: 'id'
        }
	},    
	root: {
		text: 'root',
		id: 'root'
	},
});