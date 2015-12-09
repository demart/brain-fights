Ext.define('BrainFightsConsole.model.DepartmentsTreeModel', {
    extend: 'Ext.data.TreeModel',
    fields: [
     { name: 'name'},  
     { name: 'id', type: 'int'},
     { name: 'score'},
     { name: 'count'},
     { name: 'typeId'},
    ]
}); 