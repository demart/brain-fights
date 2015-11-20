Ext.define('BrainFightsConsole.store.CategoryComboStore', {
    extend: 'Ext.data.Store',
    model: 'BrainFightsConsole.model.CategoryModel',
    autoLoad: false,
    pageSize: 300,
    proxy: {
	    type: 'ajax',
        api: {
            read: 'rest/category/combo/store/read',
            create: 'rest/category/combo/store/create',
            update: 'rest/category/combo/store/update',
            destroy: 'rest/category/combo/store/destroy'
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