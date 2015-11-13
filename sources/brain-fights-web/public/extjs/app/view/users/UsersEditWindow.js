Ext.define('BrainFightsConsole.view.users.UsersEditWindow', {
    extend: 'Ext.window.Window',
    xtype: 'users-edit-window',
    
    reference: 'usersEditWindow',
    
    title: 'Добавить/Изменить пользователя',
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
        reference: 'usersEditWindowForm',
        
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
	            flex: 1,
	            name: 'name',
	            itemId: 'name',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            fieldLabel: 'Имя',
	            allowBlank: false
	        }, {
	            flex: 1,
	            name: 'login',
	            itemId: 'login',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            fieldLabel: 'Логин',
	            allowBlank: false
	        },
	        {
	            flex: 1,
	            name: 'password',
	            itemId: 'password',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            fieldLabel: 'Пароль',
	            allowBlank: false
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
