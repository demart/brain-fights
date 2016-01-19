Ext.define('BrainFightsConsole.view.category.CategoryList' ,{
    extend: 'Ext.panel.Panel',
    controller: 'category',
    alias: 'widget.category.CategoryList',
    requires: [
   		'Ext.MessageBox',
   		'Ext.toolbar.Paging',
   		'BrainFightsConsole.view.category.CategoryListController',
   		'BrainFightsConsole.view.category.CategoryEditWindow',
   		'BrainFightsConsole.model.CategoryModel',
   		'BrainFightsConsole.view.category.UploadImageWindow',
   		'BrainFightsConsole.model.ImageModel',
   		'BrainFightsConsole.view.category.UploadEditImageWindow',
	],



	layout: 'border',
	bodyBorder: true,
	defaults: {
        //collapsible: true,
        split: true,
        bodyPadding: '0 0 0 0'
    },
    items: [ 
            

            
            
             {          
            	title: 'Управление категориями',
               // collapsible: false,
                region: 'west',
                margin: '0 0 0 0',
                id: 'panelGridCategory',
               // width: 450,
                flex: 2,
                autoHeight: true,
                layout: 'fit',
                scroll: true,
                items: [
                        {
                	viewConfig: {
                        stripeRows: true,
                        scroll: true,
                    },
                    store: 'CategoryStore',
                	stateful: false,
                	id: 'categoryStoreId',
                	region: 'center',
                    xtype: 'grid',
                    controller: 'category',
                	scroll: true,
                	
                	tbar: [{
                        text: 'Создать новую категорию',
                        id: 'addCategoryIdBtn',
                        hidden: false,
                        handler: 'showAddCategoryWindow'
                    },
                    {
                    	text: 'Удалить категорию',
                    	handler: 'onDeleteCategoryRecord',
                    },

                    ],
                	
                	columns: [
                				{text: "Название", dataIndex: 'name' , flex: 1},
                				{text: "Вопросов", dataIndex: 'questionsCount', align: 'center', widht: 100}

                		],
                			

                	    
                	    listeners: {
                	    	viewready: function() {
                	    		this.store.load();
                	    	},
                	    	
                	    	
                	    	
                	    	cellclick: function(iView, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
                		        var record = iView.getRecord(iRowEl);
                		        console.log(record);
                		        Ext.getCmp('categoryName').setVisible(true);
                		        Ext.getCmp('categoryImage').setVisible(true);
                		        Ext.getCmp('categoryColor').setVisible(true);
                		        Ext.getCmp('categoryCreatedDate').setVisible(true);
                		        Ext.getCmp('categoryModifiedDate').setVisible(true);
                		        Ext.getCmp('editButton').setVisible(true);
                		        Ext.getCmp('saveButton').setVisible(false);
                		        Ext.getCmp('cancelButton').setVisible(false);
                		        Ext.getCmp('categoryNameText').setVisible(false);
                		        Ext.getCmp('categoryColorId').setVisible(false);
                		        Ext.getCmp('categoryEditorId').setTitle('Просмотр информации о категории');
                		        Ext.getCmp('categoryName').setText('<b>Название категории:</b> ' + record.data.name + '<br><br>', false);
                		        Ext.getCmp('categoryImage').setSrc(record.data.imageUrl);
                		        Ext.getCmp('categoryColor').setText('<b>Цвет:</b> ' + '<font color="' + record.data.color + '">' + record.data.color + '<font><br><br>', false);
                		        Ext.getCmp('categoryCreatedDate').setText('<br><b>Дата создания:</b> ' + Ext.util.Format.date(record.data.createdDate, 'm/d/Y H:i') + '<br><br>', false);
                		        Ext.getCmp('categoryModifiedDate').setText('<b>Дата изменения:</b> ' + Ext.util.Format.date(record.data.modifiedDate, 'm/d/Y H:i') + '<br><br>', false);
                		    	Ext.getCmp('nowImageCategory').setText(record.data.imageUrl);
                		        Ext.getCmp('editImageButtonCategory').setVisible(false);
                		        Ext.getCmp('defaultImageCategory').setText(record.data.imageUrl);
                	    	}
                	    }

            
                      
                },

                
                   ],
                  
                
   
            },
            {
            	title: 'Просмотр информации о категории',
            	id: 'categoryEditorId',
                region: 'center',
                flex: 1,
                layout: 'fit',
                scroll: true,
           //     height: 300,
             // minHeight: 100,
              //  maxHeight: 250,
                items: [
                        {
                            defaultType: 'textfield',
                            style: 'margin: 10px',
                            style: 'margin: 10px',
                            autoHeight: true,
                            scroll: true,
                            autoScroll: true,
                            width: 500,
                            defaults: {
                            	scroll: true,
                            	labelWidth: 140,
            					width: 380,
            			       	grow      : true,
            			       	growMin: 240,
                            },
                        	items: [
                        	        {
                        	        	text: '',
                        	        	xtype: 'label',
                        	        	hidden: true,
                        	        	id: 'defaultImageCategory',
                        	        },
                        	        {
									    text: '',
										xtype: 'label',
									    hidden: true,
									    id: 'categoryName',
									    allowBlank:false,
									    
									},
									{
									    text: '',
										xtype: 'image',
									    hidden: true,
									    align: 'center',
									    id: 'categoryImage',
									    allowBlank:false,
									    
									},
									{
										xtype: 'label',
										hidden: true,
										text: 'no',
										id: 'nowImageCategory',
									},
									{
										xtype: 'label',
										hidden: true,
										id: 'tmpImageLabelCategory',
									},
									{
										xtype: 'label',
										hidden: true,
										id: 'editImageControlCategory'
									},
									{
										xtype: 'button',
										text: 'Редактировать изоображение',
					        			margin: '10 15 0 80',
										width: 200,
										hidden: true,
										id: 'editImageButtonCategory',
										handler: 'onEditButtonImageCategoryClick',
									},
									{
									    text: '',
										xtype: 'label',
									    hidden: true,
									    id: 'categoryCreatedDate',
									    allowBlank:false
									},
									{
									    text: '',
										xtype: 'label',
									    hidden: true,
									    id: 'categoryModifiedDate',
									    allowBlank:false
									},
									{
									    text: '',
										xtype: 'label',
									    hidden: true,
									    id: 'categoryColor',
									    allowBlank:false
									},

									
									{
									    //text: '',
										//xtype: 'label',
										fieldLabel: 'Название ',
									    hidden: true,
									    id: 'categoryNameText',
									    allowBlank:false,
									    
									},
	
							        {
							            reference: 'colorCombo',
							            flex: 1,
							            xtype: 'combo',
						                fieldLabel: 'Цвет категории:',
						                displayField: 'name',
						                valueField: 'color',
						                id: 'categoryColorId',
						                anchor: '-15',
						                //labelWidth: 130,
						                autoRender: true,
						                hidden: true,
						                store: {
						                    fields: [
						                         {name: 'color'},
						                         {name: 'name'},
						                    ],
						                    data: [
						                           ['grey', '<font color="grey">Серый</font>'],
						                           ['red', '<font color="red">Красный</font>'],
						                           ['yellow', '<font color="yellow">Желтый</font>'],
						                           ['green', '<font color="green">Зеленый</font>'],
						                           ['black', '<font color="black">Черный</font>'],
						                           ['pink', '<font color="pink">Розовый</font>'],
						                     ],
						                },
						                getDisplayValue: function() {
						                    return Ext.String.htmlDecode(this.value);
						                },
						                minChars: 5,
						                queryParam: 'q',
						                queryMode: 'remote',
							            name: 'color',
							            itemId: 'color',
							            allowBlank: false,
							        },
									
									
									{
										xtype: 'button',
										text: 'Редактировать',
										width: 130,
										hidden: true,
										margin: '10 15 0 80',
										id: 'editButton',
										handler: 'onEditButtonClick',
									},
									{
										xtype: 'button',
										text: 'Сохранить',
										width: 130,
										hidden: true,
										id: 'saveButton',
										margin: '10 15 0 80',
										handler: 'onSaveButtonClick',
									},
									{
										xtype: 'button',
										text: 'Отменить',
										width: 130,
										hidden: true,
										id: 'cancelButton',
										margin: '10 15 0 0',
										handler: 'onCancelButtonClick',
									}
									                        	        
                        	        
                        	        
                        	        ],
                        }
                        
                        ]
            }         
            
            
            
            ],
         
            			initComponent: function() {
            				this.callParent(arguments);
            			},

});