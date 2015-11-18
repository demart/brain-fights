Ext.define('BrainFightsConsole.view.questions.QuestionsEditWindow', {
    extend: 'Ext.window.Window',
    xtype: 'questions-edit-window',
    
    reference: 'questionsEditWindow',
    
    
    title: 'Добавить/Изменить вопрос',
    width: 200,
    minWidth: 300,
    minHeight: 150,
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
        
        items: [{
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
	            reference: 'comboQuestRef',
	            flex: 1,
	            xtype: 'combo',
                fieldLabel: 'Выберите категорию',
                displayField: 'name',
                valueField: 'id',
                anchor: '-15',
                labelWidth: 130,
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
	            id: 'categoryComboForQuestions',
	            value: '0',
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
	            value: '0',
	            afterLabelTextTpl: [
	            	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            	            ],

	            allowBlank: false,
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
