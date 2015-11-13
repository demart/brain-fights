/**
 * This class is the main view for the application. It is specified in app.js as the
 * "autoCreateViewport" property. That setting automatically applies the "viewport"
 * plugin to promote that instance of this class to the body element.
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('BrainFightsConsole.view.main.Main', {
    extend: 'Ext.container.Container',
    
    xtype: 'app-main',
    
    controller: 'main',
    viewModel: {
        type: 'main'
    },

    requires: [
    ],
    
    id: 'mainViewportId',
    
    layout: {
        type: 'border'
    },
    
    items: [
            {
            	 region:'north',
     	        floatable: false,
     	        margin: '0 0 0 0',
     	        tbar : [
					{
						id: 'adminUsersBtn',
					    text:'Управление пользователями',
					    iconCls: null,
					    scale: 'small',
					    hidden: true,
					    listeners : {click : 'onAdminUsersBtnClick', },
					    
					},
					{
						id: 'categoryBtn',
					    text:'Управление категориями',
					    iconCls: null,
					    scale: 'small',
					    hidden: true,
					    listeners : {click : 'onCategoryBtnClick', },
					    
					},
					{
						id: 'questionBtn',
					    text:'Управление вопросами',
					    iconCls: null,
					    scale: 'small',
					    hidden: true,
					    listeners : {click : 'onQuestionBtnClick', },
					    
					},
     	         ],
            },
            {
            	region:'center',
            	floatable: false,
    	        margin: '0 0 0 0',
    	        id: 'mainBody',
    	        layout: 'fit',
            }

    ],
    
    initComponent: function() {
    	var view = this;
        this.callParent(arguments);
    },
    
    listeners : {
    	beforerender: function(viewport, eOpts) {
    		var role = document.getElementById('console_user_role').innerHTML;
        	console.log(role);
        	if (role == 'ADMINISTRATOR') {
        		Ext.getCmp('adminUsersBtn').setVisible(true);
        		Ext.getCmp('categoryBtn').setVisible(true);
        		Ext.getCmp('questionBtn').setVisible(true);
        	}
        	else {
        		Ext.getCmp('adminUsersBtn').setVisible(false);
        		Ext.getCmp('categoryBtn').setVisible(true);
        		Ext.getCmp('questionBtn').setVisible(true);
        	}

    	}
    },
    
    
});
