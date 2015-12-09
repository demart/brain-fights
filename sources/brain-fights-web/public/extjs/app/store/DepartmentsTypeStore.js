Ext.define('BrainFightsConsole.store.DepartmentsTypeStore', {
    extend: 'Ext.data.Store',
    model: 'BrainFightsConsole.model.DepartmentsTypeModel',
    autoLoad: false,
    pageSize: 20,
    proxy: {
	    type: 'ajax',
        api: {
            read: 'rest/departments/type/store/read',
            create: 'rest/departments/type/store/create',
            update: 'rest/departments/type/store/update',
            destroy: 'rest/departments/type/store/destroy'
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