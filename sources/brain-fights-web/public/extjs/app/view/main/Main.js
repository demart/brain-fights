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
     	        
     	        items: [
     	                
     	                {
     	                	region: 'west',
     	                	buttonAlign: 'right',
     	                
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
							    
							}, '->',
							{
								id: 'authUserNameLabel',
								xtype:'label',
							    text:'',
							    scale: 'medium',
							    align: 'right',
							    //margin: '0 200 0 0',
							    hidden: false,
							}, '-' , {
								id: 'logoutBtn',
								xtype:'button',
					        	//margin: '0 80 0 0',
							    text:'Выход',
							    scale: 'medium',
							    hidden: false,
							    buttonAlign: 'right',
							    listeners : {click : 'onLogoutClick', },
							},
							
		     	         ],
     	                }
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
    		var name = document.getElementById('console_user_name').innerHTML;
        	console.log(role);
        	if (role == 'ADMINISTRATOR') {
        		Ext.getCmp('adminUsersBtn').setVisible(true);
        		Ext.getCmp('categoryBtn').setVisible(true);
        		Ext.getCmp('questionBtn').setVisible(true);
        		window.document.location = "#admins";
        		Ext.getCmp('authUserNameLabel').setText('Вы авторизовались, как ' + name + '. Вы являетесь администратором.');
        	}
        	else {
        		Ext.getCmp('adminUsersBtn').setVisible(false);
        		Ext.getCmp('categoryBtn').setVisible(true);
        		Ext.getCmp('questionBtn').setVisible(true);
        		window.document.location = "#category";
        		Ext.getCmp('authUserNameLabel').setText('Вы авторизовались, как ' + name + '. Вы являетесь менеджером.');
        	}

    	}
    },
    
    
});
