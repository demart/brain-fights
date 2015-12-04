Ext.define('BrainFightsConsole.store.DepartmentComboStore', {
    extend: 'Ext.data.Store',
    model: 'BrainFightsConsole.model.DepartmentModel',
    autoLoad: false,
    pageSize: 8,
    proxy: {
	    type: 'ajax',
        api: {
            read: 'rest/department/combo/store/read',
            create: 'rest/category/store/create',
            update: 'rest/category/store/update',
            //destroy: 'rest/category/store/destroy'
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