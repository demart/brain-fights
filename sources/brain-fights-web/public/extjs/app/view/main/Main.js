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
							    text:'Администраторы',
							    iconCls: null,
							    scale: 'small',
							    hidden: true,
							    listeners : {click : 'onAdminUsersBtnClick', },
							    
							},
							{
								id: 'usersBtn',
							    text:'Игроки',
							    iconCls: null,
							    scale: 'small',
							    hidden: true,
							    listeners : {click : 'onUsersBtnClick', },
							    
							},
							{
					        	id: 'departmentsBtn',
					            xtype:'button',
					            text:'Подразделения',
					            iconCls: null,
					            glyph: 61,
					            hidden: true,
					            scale: 'small',
					            menu:[
					                  {
					                	  text:'Справочник подразделений',
					                	  listeners: { click : 'onDepartmentsTypeBtnClick', }
					                  },
					                  {
					                	  text:'Структура компании',
					                	  listeners: { click : 'onDepartmentsBtnClick', },
					                  }
				                  ]
					        	},
							{
								id: 'categoryBtn',
							    text:'Категории',
							    iconCls: null,
							    scale: 'small',
							    hidden: true,
							    listeners : {click : 'onCategoryBtnClick', },
							    
							},
							{
					        	id: 'questionBtn',
					            xtype:'button',
					            text:'Вопросы',
					            iconCls: null,
					            glyph: 61,
					            hidden: true,
					            scale: 'small',
					            menu:[
									{
										text:'Вопросы',
									    listeners : {click : 'onQuestionBtnClick', },
									    
									}, 
									{
										id: 'questionImportBtn',
									    text:'Импорт вопросов',
									    listeners : {click : 'onQuestionImportBtnClick', },
									}, 
									]},
						
							
							
							'->',
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
        		Ext.getCmp('usersBtn').setVisible(true);
        		Ext.getCmp('departmentsBtn').setVisible(true);
        		window.document.location = "#question";
        		Ext.getCmp('authUserNameLabel').setText('Вы авторизовались, как ' + name + '.');
        	}
        	else {
        		Ext.getCmp('adminUsersBtn').setVisible(false);
        		Ext.getCmp('categoryBtn').setVisible(true);
        		Ext.getCmp('questionBtn').setVisible(true);
        		Ext.getCmp('usersBtn').setVisible(false);
        		Ext.getCmp('departmentsBtn').setVisible(false);
        		window.document.location = "#question";
        		Ext.getCmp('authUserNameLabel').setText('Вы авторизовались, как ' + name + '.');
        	}

    	}
    },
    
    
});
