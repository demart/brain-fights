Ext.define('BrainFightsConsole.store.UsersStore', {
    extend: 'Ext.data.Store',
    model: 'BrainFightsConsole.model.UsersModel',
    autoLoad: false,
    pageSize: 23,
    proxy: {
	    type: 'ajax',
        api: {
            read: 'rest/users/store/read',
            create: 'rest/users/store/create',
            update: 'rest/users/store/update',
            destroy: 'rest/users/store/destroy'
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