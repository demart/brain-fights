Ext.define('BrainFightsConsole.view.questions.QuestionsList' ,{
    extend: 'Ext.panel.Panel',
    controller: 'questions',
    alias: 'widget.questions.QuestionsList',
    requires: [
   		'Ext.MessageBox',
   		'Ext.layout.container.Border',
   		'Ext.toolbar.Paging',
   		
   	    'BrainFightsConsole.view.questions.QuestionsListController',
   	    'BrainFightsConsole.view.questions.QuestionsEditWindow',
   	    'BrainFightsConsole.model.QuestionModel',
   	    'BrainFightsConsole.view.questions.UploadImageQuestionWindow',
   	    'BrainFightsConsole.view.questions.UploadEditImageQuestionWindow',
    	//'BrainFightsConsole.view.questions.ImportQuestionsWindow',
    	//'BrainFightsConsole.view.questions.DownloadWindow',
    	
	],

	layout: 'border',
	bodyBorder: true,
	tempCategoryId: null,
	defaults: {
       // collapsible: true,
        split: true,
        bodyPadding: '0 0 0 0'
    },
    items: [ 
            

            
            
             {          
            	title: 'Управление вопросами',
                collapsible: false,
                region: 'north',
                margin: '0 0 0 0',
               // height: '10%',

             
                items: [
                        {
                        	xtype: 'panel',
                        	layout: 'fit',
                        	bodyPadding: 5,
                            width: 500,
                        	items: [{
                	            reference: 'categoryCombo',
                	            flex: 1,
                	            xtype: 'combo',
                                fieldLabel: 'Категория вопроса:',
                                displayField: 'name',
                                valueField: 'id',
                                anchor: '-15',
                                labelWidth: 130,
                                autoRender: true,
                                pageSize: 10,
                                store: {
            	                    model: 'BrainFightsConsole.model.CategoryModel',
            	                    pageSize: 10,
            	                    proxy: {
            	                        type: 'ajax',
            	                        url: '/rest/category/combo/store/read',
            	                        reader: {
            	                        	type: 'json',
            	                            rootProperty: 'data',
            	                            successProperty: 'success',
            	                            totalProperty: 'totalCount',
            	                            idProperty: 'id'
            	                        }
            	                    },
            	                    autoDestroy: true
            	                },
                                minChars: 5,
                                queryParam: 'q',
                                queryMode: 'remote',
                	            name: 'name',
                	            id: 'categoryComboId',
		
          
                        	listeners: {

              		
                        	    viewready: function(){
                        	       this.store.load();
                        	       this.view.refresh();
                        	    },
                        	    
                        	    select: function () {
                            		var questionsGrid = Ext.getCmp('questionsGridId');
                            		
                            		if (Ext.getCmp('categoryComboId').getValue() == 0) {
                            			questionsGrid.store.proxy.api.read = 'rest/questions/store/read';
                                		questionsGrid.getStore().reload();
                            		}
                            			
                            		else {
                           			questionsGrid.store.proxy.api.read = 'rest/questions/store/read?categoryId=' + Ext.getCmp('categoryComboId').getValue();
                            		questionsGrid.getStore().reload();
                            		}
                        	    	//console.log (record.data.id);
                            		
                    		        Ext.getCmp('questionName').setVisible(false);
                    		        Ext.getCmp('questionCreatedDate').setVisible(false);
                    		        Ext.getCmp('questionModifiedDate').setVisible(false);
                    		        Ext.getCmp('questionAnswer1').setVisible(false);
                    		        Ext.getCmp('questionAnswer2').setVisible(false);
                    		        Ext.getCmp('questionAnswer3').setVisible(false);
                    		        Ext.getCmp('questionAnswer4').setVisible(false);
                    		        Ext.getCmp('answerCorrect').setVisible(false);
                    		        Ext.getCmp('editButtonQuestion').setVisible(false);
                    		        Ext.getCmp('saveButtonQuestion').setVisible(false);
                    		        Ext.getCmp('cancelButtonQuestion').setVisible(false);
                    		        
                    		        Ext.getCmp('nameQuestionText').setVisible(false);
                    		        Ext.getCmp('answerTrueText').setVisible(false);
                    		        Ext.getCmp('categoryComboForQuestionsText').setVisible(false);
                    		        Ext.getCmp('answer4Text').setVisible(false);
                    		        Ext.getCmp('answer3Text').setVisible(false);
                    		        Ext.getCmp('answer2Text').setVisible(false);
                    		        Ext.getCmp('answer1Text').setVisible(false);
                		        	Ext.getCmp('questionImage').setVisible(false);
                    		        Ext.getCmp('editImageButtonQuestion').setVisible(false);
                		        	
                        	    },
                        	    
                            	 },

            
                      
                }]
                
   
            },
            {
            	xtype: 'panel',
            	layout: 'fit',
            	bodyPadding: 5,
            	items: [{
            		xtype: 'fieldcontainer',
            		fieldLabel: 'Поиск по вопросу',
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
            			id:'searchQuestionField',
            			name: 'searchingQuestion',
            			margin: '0 15 0 0',
            			width: 150,
            			listeners:{
            				specialkey: function(f,o){
            					if(o.getKey()==13){
            						Ext.getCmp('searchButton').fireEvent('click');
            					}
            				}
            			},  
            		}, 

            		{
            			region: 'center',
            			items: [
            			        {
            				id: 'searchButton',
            				region: 'east',
            				xtype: 'button',
                			margin: '0 15 0 0',
            				text: 'Найти',
            				listeners: {
                				click : 'searchQuestion' 
                			},
            			},
            			{
            				id: 'refreshButton',
            				region: 'east',
            				xtype: 'button',
                			margin: '0 15 0 0',
            				text: 'Сбросить фильтр',
            				listeners: {
                				click : 'showAllQuestion' 
                			},
            			},
    
            			        ]
            		},],
            	}],
    },
                        
                        
                        ],
             },
            {
            	//title: 'Вопросы',
                region: 'west',
                flex: 2,
                scroll: true,
                layout: 'fit',
                items: [{
                	id: 'questionsGridId',
                	viewConfig: { 
                		stripeRows: true,
                        scroll: true,},
                    xtype: 'grid',
                    minHeight: 400,
                    store: 'QuestionStore',
                	stateful: false,
                	scroll: true,
                 	
                	tbar: [
                	       { text: 'Добавить новый вопрос', handler: 'showAddWindow' },
                	     
                	       { text: 'Удалить вопрос', handler: 'deleteQuestion'},
        	        ],
                	

                	columns: [
                			//{text: "№", dataIndex: 'id', width: 100},
                            {text: "Вопрос", dataIndex: 'text' , flex: 1},
                            {text: "Категория", dataIndex: 'categoryName', flex: 1},
                            {text: "Тип", dataIndex: 'type', align: 'center', width: 100,
                            	renderer : function(val) {
                                    if (val == 'TEXT') return 'Текст';
                                    if (val == 'IMAGE') return 'Картинка';
                                },		
                                }

                	],
                	

                	listeners: {
                		viewready: function() {
            	            var height = Ext.getBody().getSize().height - 265;
            	    		console.log(height);
            	    	    var rows = Math.floor(height / 25.0);
            	    	    console.log(rows);
            	    	    this.store.pageSize = rows;
            	    		this.store.load();
            	    	},
            	    	
            	    	resize: function() {
            	            var height = Ext.getBody().getSize().height - 265;
            	    		console.log(height);
            	    		var rows = Math.floor(height / 25.0);
            	    	    console.log(rows);
            	    	    this.store.pageSize = rows;
            	    		this.store.load();
            	    	},
            	    	
                		
                		cellclick: function(iView, iCellEl, iColIdx, iStore, iRowEl, iRowIdx, iEvent) {
            		        var record = iView.getRecord(iRowEl);
            		        console.log(record);
            		        Ext.getCmp('questionName').setVisible(true);
            		        Ext.getCmp('questionCreatedDate').setVisible(true);
            		        Ext.getCmp('questionModifiedDate').setVisible(true);
            		        Ext.getCmp('questionAnswer1').setVisible(true);
            		        Ext.getCmp('questionAnswer2').setVisible(true);
            		        Ext.getCmp('questionAnswer3').setVisible(true);
            		        Ext.getCmp('questionAnswer4').setVisible(true);
            		        Ext.getCmp('answerCorrect').setVisible(true);
            		        Ext.getCmp('editButtonQuestion').setVisible(true);
            		        Ext.getCmp('saveButtonQuestion').setVisible(false);
            		        Ext.getCmp('cancelButtonQuestion').setVisible(false);
            		        
            		        Ext.getCmp('nameQuestionText').setVisible(false);
            		        Ext.getCmp('answerTrueText').setVisible(false);
            		        Ext.getCmp('categoryComboForQuestionsText').setVisible(false);
            		        Ext.getCmp('answer4Text').setVisible(false);
            		        Ext.getCmp('answer3Text').setVisible(false);
            		        Ext.getCmp('answer2Text').setVisible(false);
            		        Ext.getCmp('answer1Text').setVisible(false);
            		        Ext.getCmp('editImageButtonQuestion').setVisible(false);
            		        
            		        Ext.getCmp('viewQuestionInformationId').setTitle('Просмотр информации о вопросе');
            		        
            		        
            		        Ext.getCmp('questionName').setText('        <b>Название:</b> ' + record.data.text + '<br><br>', false);
            		        Ext.getCmp('questionCreatedDate').setText(' <b>Дата создания: </b> ' + Ext.util.Format.date(record.data.createdDate, 'm/d/Y H:i') + '<br><br>', false);
            		        Ext.getCmp('questionModifiedDate').setText('<b>Дата изменения:</b> ' + Ext.util.Format.date(record.data.modifiedDate, 'm/d/Y H:i') + '<br><br>', false);
            		     
            		        
            		        Ext.getCmp('questionAnswer1').setText('<b>Ответ #1: </b> ' + record.data.answers[0].name + '<br><br>', false);
            		        Ext.getCmp('questionAnswer2').setText('<b>Ответ #2: </b> ' + record.data.answers[1].name + '<br><br>', false);
            		        Ext.getCmp('questionAnswer3').setText('<b>Ответ #3: </b> ' + record.data.answers[2].name + '<br><br>', false);
            		        Ext.getCmp('questionAnswer4').setText('<b>Ответ #4: </b> ' + record.data.answers[3].name + '<br><br>', false);
                		
            		        if (record.data.type == "IMAGE") {
            		        	Ext.getCmp('questionImage').setVisible(true);
            		        	Ext.getCmp('questionImage').setSrc(record.data.image);
            		        	Ext.getCmp('questionCreatedDate').setText(' <br><br><b>Дата создания: </b> ' + Ext.util.Format.date(record.data.createdDate, 'm/d/Y H:i') + '<br><br>', false);
                   		       	Ext.getCmp('nowImageQuestion').setText(record.data.image);
            		        	Ext.getCmp('defaultImageQuestion').setText(record.data.image);
            		        }
            		        
            		        else  {
            		        	Ext.getCmp('questionImage').setVisible(false);
            		        	Ext.getCmp('nowImageQuestion').setText('no');
            		        }
            		        
            		        for (var i=0; i<4; i++) {
            		        	if (record.data.answers[i].correct == true)
            		        		Ext.getCmp('answerCorrect').setText('<b> Правильный ответ #' + '<font color="red">' + (i+1) + '</font>' + '</b><br>', false);
            		        }
                		}
                	}
                		
                },
],
bbar:            	 {
 	xtype: 'pagingtoolbar',
     store: 'QuestionStore',
     displayInfo: true,
     dock: 'bottom',
     displayMsg: 'Показано записей {0} - {1} из {2}',
     emptyMsg: "",
     items:[]
 },
            },
{
region: 'center',
title: 'Просмотр информации о вопросе',
flex: 1,
layout: 'fit',
scroll: true,
id: 'viewQuestionInformationId',
items: [
{
    defaultType: 'textfield',
    style: 'margin: 10px',
    style: 'margin: 10px',
    height: 800,
    defaults: {
    	labelWidth: 140,
    	width: 370,
       	grow      : true,
       	growMin: 230,
     },

	items: [
				{
					text: 'no',
					xtype: 'label',
					hidden: true,
					id: 'defaultImageQuestion',
				},
				
				{
				    text: '',
					xtype: 'label',
				    hidden: true,
				    id: 'questionName',
				    allowBlank:false,
				    
				},
				{
				    //text: '',
					xtype: 'image',
				    hidden: true,
				    //height: 100,
				    id: 'questionImage',
				    allowBlank:false,
				    
				},
				{
					xtype: 'label',
					hidden: true,
					text: 'no',
					id: 'nowImageQuestion',
				},
				{
					xtype: 'label',
					hidden: true,
					id: 'tmpImageLabelQuestion',
				},
				{
					xtype: 'label',
					hidden: true,
					id: 'editImageControl'
				},
				{
					xtype: 'button',
					text: 'Редактировать изоображение',
        			margin: '10 15 0 80',
					width: 200,
					hidden: true,
					id: 'editImageButtonQuestion',
					handler: 'onEditButtonImageQuestionClick',
				},
				{
				    text: '',
					xtype: 'label',
				    hidden: true,
				    id: 'questionCreatedDate',
				    allowBlank:false
				},
				{
				    text: '',
					xtype: 'label',
				    hidden: true,
				    id: 'questionModifiedDate',
				    allowBlank:false
				},
				{
				    text: '',
					xtype: 'label',
				    hidden: true,
				    id: 'questionAnswer1',
				    allowBlank:false
				},
				{
				    text: '',
					xtype: 'label',
				    hidden: true,
				    id: 'questionAnswer2',
				    allowBlank:false
				},
				{
				    text: '',
					xtype: 'label',
				    hidden: true,
				    id: 'questionAnswer3',
				    allowBlank:false
				},
				{
				    text: '',
					xtype: 'label',
				    hidden: true,
				    id: 'questionAnswer4',
				    allowBlank:false
				},
				{
				    text: '',
					xtype: 'label',
				    hidden: true,
				    id: 'answerCorrect',
				    allowBlank:false
				},
				{
		            flex: 1,
		            name: 'text',
		            xtype: 'textfield',
		           // labelWidth: 200,
		            id: 'nameQuestionText',

		            hidden: true,
		            afterLabelTextTpl: [
		                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
		            ],
		            fieldLabel: 'Вопрос           :',
		            allowBlank: false
		        },
		        
			    {
		            reference: 'product',
		            flex: 1,
		            xtype: 'combo',
		            hidden: true,
	                fieldLabel: 'Выберите категорию',
	                displayField: 'name',
	                valueField: 'id',
	                anchor: '-15',
	                //labelWidth: 130,
	                pageSize: 300,
	                store: {
	                    model: 'BrainFightsConsole.model.CategoryModel',
	                    pageSize: 300,
	                    proxy: {
	                        type: 'ajax',
	                        url: '/rest/category/store/read',
	                        reader: {
	                        	type: 'json',
	                            rootProperty: 'data',
	                            successProperty: 'success',
	                            totalProperty: 'totalCount',
	                            idProperty: 'id'
	                        }
	                    },
	                    autoDestroy: true
	                },
	                minChars: 5,
	                queryParam: 'q',
	                queryMode: 'remote',
		            name: 'id',
		            //itemId: '',
		            id: 'categoryComboForQuestionsText',
		            value: '0',
		            allowBlank: true,
		            afterLabelTextTpl: [
		        		                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
		        		            ],
		        },
		        {
		            flex: 1,
		            name: 'answer1',
		            id: 'answer1Text',
		            hidden: true,
		            afterLabelTextTpl: [
		                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
		            ],
		            fieldLabel: 'Ответ #1      :',
		            allowBlank: false
		        },
		        {
		            flex: 1,
		            name: 'answer2',
		            id: 'answer2Text',
		            hidden: true,
		            afterLabelTextTpl: [
		                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
		            ],
		            fieldLabel: 'Ответ #2',
		            allowBlank: false
		        },
		        {
		            flex: 1,
		            name: 'answer3',
		            id: 'answer3Text',
		            hidden: true,
		            afterLabelTextTpl: [
		                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
		            ],
		            fieldLabel: 'Ответ #3',
		            allowBlank: false
		        },
		        {
		            flex: 1,
		            name: 'answer4',
		            id: 'answer4Text',
		            hidden: true,
		            afterLabelTextTpl: [
		                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
		            ],
		            fieldLabel: 'Ответ #4',
		            allowBlank: false
		        },
		        {
		            //reference: 'colorCombo',
		            flex: 1,
		            xtype: 'combo',
	                fieldLabel: 'Правильный ответ:',
	                displayField: 'answerTrue',
	                valueField: 'id',
	                id: 'answerTrueText',
	                anchor: '-15',
	                //labelWidth: 130,
	                autoRender: true,
	                hidden: true,
	                store: {
	                    fields: [
	                         {name: 'id'},
	                         {name: 'answerTrue'},
	                    ],
	                    data: [
	                           ['1', '1'],
	                           ['2', '2'],
	                           ['3', '3'],
	                           ['4', '4'],
	                     ],
	                },
	                getDisplayValue: function() {
	                    return Ext.String.htmlDecode(this.value);
	                },
	                minChars: 5,
	                queryParam: 'q',
	                queryMode: 'remote',
		            name: 'answerTrue',
		            itemId: 'answerTrue',
		            allowBlank: false,
		            afterLabelTextTpl: [
		        		                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
		        		            ],
		        },
				
				
				{
					xtype: 'button',
					text: 'Редактировать',
					hidden: true,
					width: 130,
        			margin: '10 15 0 80',
					id: 'editButtonQuestion',
					handler: 'onEditButtonQuestionClick',
				},
				{
					xtype: 'button',
					text: 'Сохранить',
        			margin: '10 15 0 80',
					width: 130,
					hidden: true,
					id: 'saveButtonQuestion',
					handler: 'onSaveButtonQuestionClick',
				},
				{
					xtype: 'button',
					text: 'Отменить',
        			margin: '10 15 0 0',
					width: 130,
					hidden: true,
					id: 'cancelButtonQuestion',
					handler: 'onCancelButtonQuestionClick',
				},
	        
	        ],
}
        
        
        ]
}
            
            
            
            ],
         
            			initComponent: function() {
            				this.callParent(arguments);
            			},

});