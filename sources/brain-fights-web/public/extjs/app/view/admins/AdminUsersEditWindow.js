Ext.define('BrainFightsConsole.view.admins.AdminUsersEditWindow', {
    extend: 'Ext.window.Window',
    xtype: 'admin-edit-window',
    
    reference: 'adminsEditWindow',
    
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
        reference: 'adminsEditWindowForm',
        
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
	        },
	        {
	            xtype: 'radiogroup',
	            fieldLabel : 'Роль пользователя',
	           // defaultType: 'radiogroup',
	            columns: 1,
	            vertical: true,
	            allowBlank: false,
	            afterLabelTextTpl: [
	            	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            	            ],
	            items: [
	                {
	                    boxLabel  : 'Администратор',
	                    name      : 'role',
	                    inputValue: 'ADMINISTRATOR',
	                    //checked: true,
	                    id        : 'checkbox1'
	                }, {
	                    boxLabel  : 'Менеджер',
	                    name      : 'role',
	                    inputValue: 'CONTENT_MANAGER',
	                    //checked   : true,
	                    id        : 'checkbox2'
	                }]
	        },
	        {
	            xtype: 'radiogroup',
	            fieldLabel : 'Активировать?',
	           // defaultType: 'radiogroup',
	            columns: 1,
	            vertical: true,
	            allowBlank: false,
	            afterLabelTextTpl: [
	            	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            	            ],
	            items: [
	                {
	                    boxLabel  : 'Да',
	                    name      : 'isEnabled',
	                    inputValue: 'true',
	                    //checked: true,
	                    id        : 'checkbox3'
	                }, {
	                    boxLabel  : 'Нет',
	                    name      : 'isEnabled',
	                    inputValue: 'false',
	                    //checked   : true,
	                    id        : 'checkbox4'
	                }]
	        },
	        
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
