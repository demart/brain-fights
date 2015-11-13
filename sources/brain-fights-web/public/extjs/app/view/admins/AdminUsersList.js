Ext.define('BrainFightsConsole.view.admins.AdminUsersList' ,{
    extend: 'Ext.grid.Panel',
    controller: 'admins',
    alias: 'widget.admins.AdminUsersList',
    requires: [
   		'Ext.MessageBox',
   		'Ext.toolbar.Paging',
   		'BrainFightsConsole.view.admins.AdminUsersListController',
   		'BrainFightsConsole.view.admins.AdminUsersEditWindow',
	],

	viewConfig: {
        stripeRows: true
    },
	title: 'Пользователи',
    store: 'AdminUsersStore',
    id: 'adminListId',
	stateful: false,
	
	tbar: [{
        text: 'Добавить',
        id: 'addNewAdminIdBtn',
        hidden: false,
        handler: 'showAddWindow'
    }, {
        text: 'Изменить',
        id: 'editAdminIdBtn',
        hidden: false,
        handler: 'showEditWindow'
    },{
        text: 'Удалить',
        id: 'deleteAdminIdBtn',
        hidden: false,
        handler: 'onDeleteRecord',
    }],
	
	columns: [
			{text: "№", dataIndex: 'id', width: 50},
			{text: "Имя", dataIndex: 'name' , flex: 1},
			{text: "Логин", dataIndex: 'login' , flex: 1},
            {text: "Пароль", dataIndex: 'password', flex:1},
            {text: "Роль", dataIndex: 'role', flex: 1,
            	renderer : function(val) {
                    if (val == 'NONE') return 'Не указано';
                    if (val == 'CONTENT_MANAGER') return 'Менеджер';
                    if (val == 'ADMINISTRATOR') return 'Администратор';
                }		
                },
            {text: "Активирован?", dataIndex: 'isEnabled',  align: 'center', width: 110, xtype:'booleancolumn', trueText:'Да', falseText:'Нет'},
			{text: "Дата создания", dataIndex: 'createdDate', xtype: 'datecolumn', format: 'd.m.Y H:i:s', width: 150},
			
	],
		
    bbar: {
    	xtype: 'pagingtoolbar',
        store: 'AdminUsersStore',
        displayInfo: true,
        displayMsg: 'Показано записей {0} - {1} из {2}',
        emptyMsg: "Нет данных для отображения",
        items:[]
    },
	
    initComponent: function() {
        this.callParent(arguments);
    },

    listeners: {
    	viewready: function() {
    		var role = document.getElementById('console_user_role').innerHTML;
    		if (role != 'ADMINISTRATOR') {
        		Ext.getCmp('addNewAdminIdBtn').setVisible(false);
        		Ext.getCmp('editAdminIdBtn').setVisible(false);
        		Ext.getCmp('deleteAdminIdBtn').setVisible(false);


                Ext.MessageBox.show({
                	title: 'Нет прав для просмотра раздела',
                    msg: 'Перемещение в один из доступных разделов',
                    progressText: 'Перемещение....',
                    width:300,
                    wait:true,
                    waitConfig: {interval:200},
                    icon: Ext.MessageBox.WARNING, //custom class in msg-box.html
                   // animateTarget: 'mb7'
                });
                 setTimeout(function(){
                     //This simulates a long-running operation like a database save or XHR call.
                     //In real code, this would be in a callback function.
                     Ext.MessageBox.hide();
                     window.location = '#category';
                    
                     
                 }, 5000);
                 
    		}

    		this.store.load();
    	}
    }


});