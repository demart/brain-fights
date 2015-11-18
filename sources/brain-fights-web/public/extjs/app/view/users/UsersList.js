Ext.define('BrainFightsConsole.view.users.UsersList' ,{
    extend: 'Ext.grid.Panel',
    controller: 'users',
    alias: 'widget.users.UsersList',
    requires: [
   		'Ext.MessageBox',
   		'Ext.toolbar.Paging',
   		'BrainFightsConsole.view.users.UsersListController',
   		'BrainFightsConsole.view.users.UsersEditWindow',
	],

	viewConfig: {
        stripeRows: true
    },
	title: 'Пользователи',
    store: 'UsersStore',
	stateful: false,
	
	tbar: [{
        text: 'Добавить',
        handler: 'showAddWindow'
    }, {
        text: 'Изменить',
        handler: 'showEditWindow'
    },{
        text: 'Удалить',
        handler: 'onDeleteRecord',
    }],
	
	columns: [
			{text: "№", dataIndex: 'id', width: 50},
			{text: "Логин", dataIndex: 'login' , width: 80},
			{text: "Имя", dataIndex: 'name' , flex: 3},
            {text: "E-mail", dataIndex: 'email', width:200},
            {text: "Игр", dataIndex: 'totalGames', width: 50},
			{text: "Был активен", dataIndex: 'activityTime', xtype: 'datecolumn', format: 'd.m.Y H:i:s', width: 150},
			{text: "Зарегистрирован", dataIndex: 'registeredTime', xtype: 'datecolumn', format: 'd.m.Y H:i:s', width: 150},
	],
		
    bbar: {
    	xtype: 'pagingtoolbar',
        store: 'UsersStore',
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
    		this.store.load();
    	}
    }


});