Ext.define('BrainFightsConsole.view.users.UsersList' ,{
    extend: 'Ext.panel.Panel',
    controller: 'users',
    alias: 'widget.users.UsersList',
    requires: [
   		'Ext.MessageBox',
   		'Ext.toolbar.Paging',
   		'BrainFightsConsole.view.users.UsersListController',
   		'BrainFightsConsole.view.users.EditImageWindow',
   		'BrainFightsConsole.view.users.UploadImageUserWindow',
	],

	layout: 'border',
	bodyBorder: true,
	tempCategoryId: null,
	defaults: {
       // collapsible: true,
        split: true,
        bodyPadding: '0 0 0 0'
    },
    items: [ 		        {
    		title: 'Управление пользователями',
		        	region: 'north',
	                collapsible: false,
		        	items: [
		                    {
		                    	xtype: 'panel',
		                    	layout: 'fit',
		                    	bodyPadding: 5,
		                    	items: [{
		                    		xtype: 'fieldcontainer',
		                    		fieldLabel: 'Поиск пользователя',
		                    		labelWidth: 130,
		                    		combineErrors: true,
		                    		msgTarget : 'side',
		                    		layout: 'hbox',
		                    		defaults: {
		                    			flex: 1,
		                    			hideLabel: false,
		                    			labelWidth: 60,
		                    		},
		                    		items: [{
		                    			xtype: 'textfield',
		                    			id:'searchUsersField',
		                    			name: 'searchingUser',
		                    			margin: '0 15 0 0',
		                    			width: 150,
		                    			listeners:{
		                    				specialkey: function(f,o){
		                    					if(o.getKey()==13){
		                    						Ext.getCmp('searchButtonUsers').fireEvent('click');
		                    					}
		                    				}
		                    			},  
		                    		}, 

		                    		{
		                    			region: 'center',
		                    			items: [
		                    			        {
		                    				id: 'searchButtonUsers',
		                    				region: 'east',
		                    				xtype: 'button',
		                        			margin: '0 15 0 0',
		                    				text: 'Найти',
		                    				listeners: {
		                        				click : 'searchUsers' 
		                        			},
		                    			},
		                    			{
		                    				id: 'refreshButtonUsers',
		                    				region: 'east',
		                    				xtype: 'button',
		                        			margin: '0 15 0 0',
		                    				text: 'Сбросить фильтр',
		                    				listeners: {
		                        				click : 'showAllUsers' 
		                        			},
		                    			},
		            
		                    			        ]
		                    		},],
		                    	}],
		            },
		        	        ]
		        },
 
             {
			   	region: 'center',
			   	layout: 'fit',
			   	id: 'usersListId',
			   	scroll: true,
				xtype: 'grid',
				viewConfig: {
			        stripeRows: true
			    },
				//title: 'Пользователи',
			    store: 'UsersStore',
				stateful: false,
				
				tbar: [ {
			        text: 'Изменить фотографию',
			        handler: 'showImageWindow'
			    }],
				
				columns: [
						//{text: "№", dataIndex: 'id', width: 50},
						{text: "Логин", dataIndex: 'login' , width: 120},
						{text: "Имя", dataIndex: 'name' , flex: 3},
						{text: "Фотография", dataIndex: 'imageUrl', renderer: function (v) {
							return '<center><img src="' + v + '" width="60" height="60"><center>';
						}, align: 'center',  width: 100},
			            {text: "E-mail", dataIndex: 'email', align: 'left', width:250},
			            {text: "Отделение", dataIndex: 'department', align: 'left', width: 260},
			            {text: "Игр", dataIndex: 'totalGames', align: 'center',  width: 50},
			            {text: "Рейтинг", dataIndex: 'score', align: 'center', width: 80}
							],
					
			    bbar: {
			    	xtype: 'pagingtoolbar',
			        store: 'UsersStore',
			        displayInfo: true,
			        displayMsg: 'Показано записей {0} - {1} из {2}',
			        emptyMsg: "Нет данных для отображения",
			        items:[]
			    },
				
			
			    listeners: {
        	    	resize: function() {
        	            var height = Ext.getBody().getSize().height - 215;
        	    		console.log(height);
        	    	    var rows = Math.floor(height / 65.0);
        	    	    console.log(rows);
        	    	    this.store.pageSize = rows;
        	    		this.store.load();
        	    	},
			    	
			    	viewready: function() {
			    		this.store.load();
			    	}
			    }
    }],

    initComponent: function() {
        this.callParent(arguments);
    },
});