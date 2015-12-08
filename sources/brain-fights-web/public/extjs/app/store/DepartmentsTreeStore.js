Ext.define('BrainFightsConsole.store.DepartmentsTreeStore', {
    extend: 'Ext.data.TreeStore',
    model: 'BrainFightsConsole.model.DepartmentsTreeModel',
    autoLoad: true,
    folderSort: true,
    
    proxy: {
	    type: 'ajax',
        api: {
            read: 'rest/departments/tree/store/read',
        },
	},    
});