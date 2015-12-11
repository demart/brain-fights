Ext.define('BrainFightsConsole.view.departments.DepartmentsTreeEditWindow', {
    extend: 'Ext.window.Window',
    xtype: 'dep-edit-window',
    
    reference: 'depEditWindow',
    id: 'depEditWindowId',
    
    title: 'Изменить подразделение',
    width: 200,
    minWidth: 300,
    minHeight: 150,
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closeAction: 'hide',
    
    items: [{
        xtype: 'form',
        reference: 'depEditWindowForm',
        
        border: false,
        bodyPadding: 10,
        
        fieldDefaults: {
            msgTarget: 'side',
            labelAlign: 'top', 
            labelWidth: 100,
            labelStyle: 'font-weight:bold'
        },
        
        items: [{
            xtype: 'fieldcontainer',
            labelStyle: 'font-weight:bold;padding:0;',
            layout: 'fit',
            defaultType: 'textfield',
            fieldDefaults: {
                labelAlign: 'top'
            },
        
	        items: [{
	            reference: 'depCombo',
	            flex: 1,
	            xtype: 'combo',
                fieldLabel: 'Тип подразделения',
                displayField: 'name',
                valueField: 'id',
                anchor: '-15',
                labelWidth: 130,
                autoRender: true,
                pageSize: 10,
                store: {
                    model: 'BrainFightsConsole.model.DepartmentsTypeModel',
                    pageSize: 10,
                    proxy: {
                        type: 'ajax',
                        url: '/rest/departments/combo/type/store/read',
                        reader: {
                        	type: 'json',
                            rootProperty: 'data',
                            successProperty: 'success',
                            totalProperty: 'totalCount',
                            idProperty: 'id'
                        }
                    },
                    autoDestroy: true
                },
                minChars: 5,
                queryParam: 'q',
                queryMode: 'remote',
	            name: 'name',
	            id: 'depComboId',
	        }
	        ],
        }],

        buttons: [{
            text: 'Отмена',
            handler: 'onFormCancel'
        }, {
            text: 'Сохранить',
            handler: 'onFormSubmit'
        }]
    }]
});
