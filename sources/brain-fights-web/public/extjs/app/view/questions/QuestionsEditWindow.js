Ext.define('BrainFightsConsole.view.questions.QuestionsEditWindow', {
    extend: 'Ext.window.Window',
    xtype: 'questions-edit-window',
    
    reference: 'questionsEditWindow',
    
    
    title: 'Добавить/Изменить вопрос',
    width: 200,
    minWidth: 300,
   // minHeight: 150,
   height: 650,
    id: 'questionsEditWindowId',
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closeAction: 'hide',
    
    items: [{
        xtype: 'form',
        reference: 'questionsEditWindowForm',
        
        border: false,
        bodyPadding: 10,
        
        fieldDefaults: {
            msgTarget: 'side',
            labelAlign: 'top',
            labelWidth: 100,
            labelStyle: 'font-weight:bold'
        },
        
        items: [
	                {
	                	xtype: 'label',
	                	hidden: true,
	                	text: '/public/images/no_image.jpg',
	                	id: 'testLabelUploadQuestion'
	                	
	                },
	                {
	                	xtype: 'label',
	                	hidden: true,
	                	text: '/public/images/no_image.jpg',
	                	id: 'testTmpLabelUploadQuestion'
	                	
	                },
                {
            xtype: 'fieldcontainer',
            labelStyle: 'font-weight:bold;padding:0;',
            layout: 'fit',
            defaultType: 'textfield',
            fieldDefaults: {
                labelAlign: 'top'
            },
        
	        items: [{
	            flex: 1,
	            name: 'text',
	            xtype: 'textfield',
	            id: 'nameQuestion',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            fieldLabel: 'Название вопроса',
	            allowBlank: false
	        },
	        {
	        	xtype: 'label',
	        	hidden: true,
	        	id: 'valueRadioGroup',
	        	text: ''
	        },
	        
	        {
	        	xtype: 'radiogroup',
	        	fieldLabel: 'Тип вопроса',
	        	id: 'typeQuestion',
	        	items: [
	        	        {
	        	        	boxLabel: 'Текст',
	        	        	name: 'type',
	        	        	inputValue: '1'
	        	        },
	        	        {
	        	        	boxLabel: 'Картинка',
	        	        	name: 'type',
	        	        	inputValue: '2'
	        	        }
	        	        ],
	        	listeners: {
	                change: function (field, newValue, oldValue) {
	                	 switch (parseInt(newValue['type'])) {
	                	 case 1:
	                		 console.log("text");
	                		 Ext.getCmp('valueRadioGroup').setText('text');
	                		 Ext.getCmp('imageQuestionEditorButtonId').setVisible(false);
	                		 Ext.getCmp('imageSetQuestionLabel').setVisible(false);
	                		 break;
	                	 case 2:
	                		 console.log("image");
	                		 Ext.getCmp('valueRadioGroup').setText('image');
	                		 Ext.getCmp('imageQuestionEditorButtonId').setVisible(true);
	                		 Ext.getCmp('imageSetQuestionLabel').setVisible(true);
	                		 break;
	                	 }
	                }
	                }
	        },
	        
		    {
	            reference: 'comboQuestRef',
	            flex: 1,
	            xtype: 'combo',
                fieldLabel: 'Выберите категорию',
                displayField: 'name',
                valueField: 'id',
                anchor: '-15',
                labelWidth: 130,
                pageSize: 10,
                store: {
                    model: 'BrainFightsConsole.model.CategoryModel',
                    pageSize: 10,
                    proxy: {
                        type: 'ajax',
                        url: '/rest/category/forcombo/store/read',
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
	            id: 'categoryComboForQuestions',
	            value: 'Не указана',
	            afterLabelTextTpl: [
	            	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            	            ],
	            allowBlank: false,
	        },
	        {
	            flex: 1,
	            name: 'answer1',
	            id: 'answer1',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            fieldLabel: 'Ответ #1',
	            allowBlank: false
	        },
	        {
	            flex: 1,
	            name: 'answer2',
	            id: 'answer2',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            fieldLabel: 'Ответ #2',
	            allowBlank: false
	        },
	        {
	            flex: 1,
	            name: 'answer3',
	            id: 'answer3',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            fieldLabel: 'Ответ #3',
	            allowBlank: false
	        },
	        {
	            flex: 1,
	            name: 'answer4',
	            id: 'answer4',
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
                id: 'answerTrue',
                anchor: '-15',
                labelWidth: 130,
                autoRender: true,
                hidden: false,
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
	            value: 'Не указан',
	            afterLabelTextTpl: [
	            	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            	            ],

	            allowBlank: false,
	        },
	        

	         {
	        	 xtype: 'button',
	        	 text: 'Редактировать изображение',
	        	 id: 'imageQuestionEditorButtonId',
	        	 handler: 'imageQuestionEditor', 
	        	 hidden: true,
	        	 margin: '10 10 10 10',
	        	 align: 'center',
	         } ,
		        {
	        	 xtype: 'image',
	        	 //text: 'Информация: Изображение не выбрано',
	        	 src: '/public/images/no_image.jpg',
	        	 id: 'imageSetQuestionLabel',
                style: 'margin: 10px',
	        	 align: 'center',
	        	 
	        	 height: 100,
	        	 hidden: true,
	         },
	        
        ],
	        
        }],

        buttons: [{
            text: 'Отмена',
            handler: 'onFormCancel'
        }, {
            text: 'Сохранить',
            handler: 'onAddNewQuestion'
        }]
    }]
});
