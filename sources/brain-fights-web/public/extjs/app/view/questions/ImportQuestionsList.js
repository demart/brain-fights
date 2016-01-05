Ext.define('BrainFightsConsole.view.questions.ImportQuestionsList' ,{
    extend: 'Ext.grid.Panel',
    controller: 'questions',
   
    requires: [
   		'Ext.MessageBox',
    	'BrainFightsConsole.view.questions.DownloadWindow',
	],

	id: 'questionsImportGridId',
	viewConfig: { 
		stripeRows: true,
        scroll: true,},
    xtype: 'grid',
    height: 400,
    store: 'ImportQuestionsStore',
	stateful: false,
	scroll: true,
	
	tbar: [
	        {
                      text: 'Загрузить файл',
                      handler: 'onWindowDonwloadOpen'
                  },
           {
            text: 'Сохранить',
            id: 'saveImportQuestionId',
            disabled : true,
            handler: 'onImportQuestions'
        }],
   
   columns: [
                 {text: "Вопрос", dataIndex: 'text' , 
                	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                		 if (record.get('text') == "Отсутствует текст вопроса")
                			 return '<font color="red">' + record.get('text') + '</font>';
                		 else
                			 return record.get('text');
                     },
                     flex: 1},
                 {text: "Категория", dataIndex: 'categoryName', 
                	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                		 if (record.get('categoryName') == "Отсутствует категория" || record.get('categoryName') == "Категория не найдена")
                			 return '<font color="red">' + record.get('categoryName') + '</font>';
                		 else
                			 return record.get('categoryName');
                     },                    	 
                	 flex: 1},  
                 {text: "Ответ #1", dataIndex: 'answer1' , 
                	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                		 if (record.get('answers')[0].name == "Отсутствует ответ")
                			 return '<font color="red">' + record.get('answers')[0].name + '</font>';
                		 else
                			 return record.get('answers')[0].name;
                     },
                     width: 80, align: 'center'},
                 
                 {text: "Ответ #2", dataIndex: 'answer2' ,
                	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                		 if (record.get('answers')[1].name == "Отсутствует ответ")
                			 return '<font color="red">' + record.get('answers')[1].name + '</font>';
                		 else
                			 return record.get('answers')[1].name;
                     },
                     width: 80, align: 'center'},
                 {text: "Ответ #3", dataIndex: 'answer3' ,
                    	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                    		 if (record.get('answers')[2].name == "Отсутствует ответ")
                    			 return '<font color="red">' + record.get('answers')[2].name + '</font>';
                    		 else
                    			 return record.get('answers')[2].name;
                         },
                         width: 80, align: 'center'},
                 {text: "Ответ #4", dataIndex: 'answer4' , 
                        	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                        		 if (record.get('answers')[3].name == "Отсутствует ответ")
                        			 return '<font color="red">' + record.get('answers')[3].name + '</font>';
                        		 else
                        			 return record.get('answers')[3].name;
                             },
                			width: 80, align: 'center'},
                 {text: "Правильный ответ", dataIndex: 'correctAnswer' , 
                				renderer: function(value, metaData, record, row, col, store, gridView)  {
                           		 if (record.get('correctAnswer') == "Отсутсвует правильный ответ")
                           			 return '<font color="red">' + record.get('correctAnswer') + '</font>';
                           		 else
                           			 return record.get('correctAnswer');
                                },
                				flex: 1, align: 'center'},
             ],
        
		
    initComponent: function() {
        this.callParent(arguments);
    },




});