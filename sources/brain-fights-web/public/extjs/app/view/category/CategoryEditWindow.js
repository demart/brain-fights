Ext.define('BrainFightsConsole.view.category.CategoryEditWindow', {
    extend: 'Ext.window.Window',
    xtype: 'category-edit-window',
    
    reference: 'categoryEditWindow',
    
    title: 'Добавить новую категорию',
    width: 200,
    minWidth: 300,
    minHeight: 150,
    height: 550,
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closeAction: 'hide',
    
    items: [{
        xtype: 'form',
        reference: 'categoryEditWindowForm',
        
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
        
	        items: [
	                {
	                	xtype: 'label',
	                	hidden: true,
	                	text: '/public/images/no_image.jpg',
	                	id: 'testLabelUpload'
	                	
	                },
	                {
	                	xtype: 'label',
	                	hidden: true,
	                	text: '/public/images/no_image.jpg',
	                	id: 'testTmpLabelUpload'
	                	
	                },
	                {
	            flex: 1,
	            name: 'name',
	            itemId: 'name',
	            id: 'categoryNameEditForm',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            fieldLabel: 'Название',
	            allowBlank: false
	        }, 	
	        
	        {
	            reference: 'colorCombo',
	            flex: 1,
	            xtype: 'combo',
                fieldLabel: 'Цвет категории:',
                displayField: 'name',
                valueField: 'color',
                id: 'categoryColorEditWindow',
                anchor: '-15',
                labelWidth: 130,
                autoRender: true,
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
                minChars: 5,
                queryParam: 'q',
                queryMode: 'remote',
	            name: 'color',
	            value: 'Не указан',
                getDisplayValue: function() {
                    return Ext.String.htmlDecode(this.value);
                },
	            itemId: 'color',
	            afterLabelTextTpl: [
	                '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>'
	            ],
	            allowBlank: false,
	        },
	        {
	        	 xtype: 'image',
	        	 //text: 'Информация: Изображение не выбрано',
	        	 src: '/public/images/no_image.jpg',
	        	 id: 'imageSetLabel',
                 style: 'margin: 10px',
	        	 align: 'center',
	        	 hidden: false,
	         },

	         {
	        	 xtype: 'button',
	        	 text: 'Редактировать изображение',
	        	 id: 'imageEditorButtonId',
	        	 handler: 'imageEditor', 
	        	 hidden: false,
	        	 margin: '10 10 10 10',
	        	 align: 'center',
	         }
	        
	        ],
        }],

        buttons: [{
            text: 'Закрыть',
            handler: 'onFormCancel'
        }, {
            text: 'Сохранить',
            handler: 'onFormSubmit'
        }]
    }]
});
