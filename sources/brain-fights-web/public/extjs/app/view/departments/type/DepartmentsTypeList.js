Ext.define('BrainFightsConsole.view.departments.type.DepartmentsTypeList' ,{
    extend: 'Ext.grid.Panel',
    controller: 'departments.type',
    alias: 'widget.departments.type.DepartmentsTypeList',
    requires: [
   		'Ext.MessageBox',
   		'Ext.toolbar.Paging',
   		'BrainFightsConsole.view.departments.type.DepartmentsTypeListController',
   		'BrainFightsConsole.view.departments.type.DepartmentsTypeEditWindow',
	],

	viewConfig: {
        stripeRows: true
    },
	title: 'Типы отделений',
    store: 'DepartmentsTypeStore',
    id: 'typeListId',
	stateful: false,
	
	tbar: [{
        text: 'Добавить',
        id: 'addNewTypeIdBtn',
        hidden: false,
        handler: 'showAddWindow'
    }, {
        text: 'Изменить',
        id: 'editTypeIdBtn',
        hidden: false,
        handler: 'showEditWindow'
    },{
        text: 'Удалить',
        id: 'deleteTypeIdBtn',
        hidden: false,
        handler: 'onDeleteRecord',
    }],
	
	columns: [
			{text: "№", dataIndex: 'id', width: 50},
			{text: "Имя", dataIndex: 'name' , flex: 1},
		    {text: "Дата создания", dataIndex: 'createdDate', xtype: 'datecolumn', format: 'd.m.Y H:i:s', width: 150, align: 'center'},
		    {text: "Дата изменения", dataIndex: 'modifiedDate', xtype: 'datecolumn', format: 'd.m.Y H:i:s', width: 150, align: 'center'},
			
	],
		
    bbar: {
    	xtype: 'pagingtoolbar',
        store: 'DepartmentsTypeStore',
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
        		Ext.getCmp('addNewTypeIdBtn').setVisible(false);
        		Ext.getCmp('editTypeIdBtn').setVisible(false);
        		Ext.getCmp('deleteTypeIdBtn').setVisible(false);


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