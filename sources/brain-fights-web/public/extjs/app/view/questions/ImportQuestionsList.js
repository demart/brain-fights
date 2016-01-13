Ext.define('BrainFightsConsole.view.questions.ImportQuestionsList' ,{
    extend: 'Ext.grid.Panel',
    controller: 'questions',
   
    requires: [
   		'Ext.MessageBox',
    	'BrainFightsConsole.view.questions.DownloadWindow',
    	'Ext.tip.ToolTip'
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
                text: 'Скачать шаблон',
                handler: function() {
                	window.open('/public/TemplateForImportQuestions.xlsx','download')
                }
            },
	       
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
                 
             {text: "Категория", dataIndex: 'categoryName', 
            	 renderer: function(value, metaData, record, row, col, store, gridView)  {
            		 if (record.get('categoryName') == "Отсутствует категория")
            			 return '<font color="red">' + record.get('categoryName') + '</font>';
            		 else
            			 return record.get('categoryName');
                 },                    	 
            	 width: 300},  
                 {text: "Вопрос", dataIndex: 'text' , 
                	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                		 metaData.tdAttr = 'data-qtip="' + record.get('text') + '"';
                		 if (record.get('text') == "Отсутствует текст вопроса")
                			 return '<font color="red">' + record.get('text') + '</font>';
                		 else
                			 return record.get('text');
                     },
                     flex: 1},
                                 {text: "Ответ #1", dataIndex: 'answer1' , 
                	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                		 metaData.tdAttr = 'data-qtip="' + record.get('answers')[0].name + '"';
                		 if (record.get('answers')[0].name == "Отсутствует ответ")
                			 return '<font color="red">' + record.get('answers')[0].name + '</font>';
                		 else if (record.get('answers')[0].correct == true)
                			 return '<b><font color="green">' + record.get('answers')[0].name + '</font></b>';
                		 else if (record.get('answers')[0].correct == false)
                			 return record.get('answers')[0].name;
                     },
                     autoSizeColumn: true, align: 'center'},
                 
                 {text: "Ответ #2", dataIndex: 'answer2' ,
                	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                		 metaData.tdAttr = 'data-qtip="' + record.get('answers')[1].name + '"';
                		 if (record.get('answers')[1].name == "Отсутствует ответ")
                			 return '<font color="red">' + record.get('answers')[1].name + '</font>';
                		 else if (record.get('answers')[1].correct == true)
                			 return '<b><font color="green">' + record.get('answers')[1].name + '</font></b>';
                		 else if (record.get('answers')[1].correct == false)
                			 return record.get('answers')[1].name;
                     },
                     autoSizeColumn: true, align: 'center'},
                 {text: "Ответ #3", dataIndex: 'answer3' ,
                    	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                    		 metaData.tdAttr = 'data-qtip="' + record.get('answers')[2].name + '"';
                    		 if (record.get('answers')[2].name == "Отсутствует ответ")
                    			 return '<font color="red">' + record.get('answers')[2].name + '</font>';
                    		 else if (record.get('answers')[2].correct == true)
                    			 return '<b><font color="green">' + record.get('answers')[2].name + '</font></b>';
                    		 else if (record.get('answers')[2].correct == false)
                    			 return record.get('answers')[2].name;
                         },
                         autoSizeColumn: true, align: 'center'},
                 {text: "Ответ #4", dataIndex: 'answer4' , 
                        	 renderer: function(value, metaData, record, row, col, store, gridView)  {
                        		 metaData.tdAttr = 'data-qtip="' + record.get('answers')[3].name + '"';
                        		 if (record.get('answers')[3].name == "Отсутствует ответ")
                        			 return '<font color="red">' + record.get('answers')[3].name + '</font>';
                        		 else if (record.get('answers')[3].correct == true)
                        			 return '<b><font color="green">' + record.get('answers')[3].name + '</font></b>';
                        		 else if (record.get('answers')[3].correct == false)
                        			 return record.get('answers')[3].name;
                             },
                             autoSizeColumn: true, align: 'center',
                             
                         
                 },
                             ],
        
		
    initComponent: function() {

        this.callParent(arguments);
    },
    
   
  



});