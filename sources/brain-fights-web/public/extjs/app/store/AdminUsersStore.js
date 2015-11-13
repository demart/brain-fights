Ext.define('BrainFightsConsole.store.AdminUsersStore', {
    extend: 'Ext.data.Store',
    model: 'BrainFightsConsole.model.AdminUsersModel',
    autoLoad: false,
    pageSize: 23,
    proxy: {
	    type: 'ajax',
        api: {
            read: 'rest/admin/users/store/read',
            create: 'rest/admin/users/store/create',
            update: 'rest/admin/users/store/update',
            destroy: 'rest/admin/users/store/destroy'
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