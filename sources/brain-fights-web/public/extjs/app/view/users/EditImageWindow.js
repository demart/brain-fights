Ext.define('BrainFightsConsole.view.users.EditImageWindow', {
    extend: 'Ext.window.Window',
    xtype: 'image-edit-window',
    
    reference: 'imageUsersEditWindow',
    
    title: 'Редактировать фотографию',
    width: 200,
    minWidth: 300,
    minHeight: 150,
    height: 450,
    layout: 'fit',
    id: 'imageUserEditWindowId',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closeAction: 'hide',
    
    items: [{
        xtype: 'form',
        reference: 'imageUserEditWindowForm',
        
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
	               	 text: '',
	               	 id: 'tmpUploadImageAvatar',
	               	 hidden: true,
	                },
	                {
	               	xtype: 'label',
	               	text: '',
	               	id: 'uploadImageAvatar',
	               	hidden: true,
	               },
	               {
	               	xtype: 'label',
	               	text: '',
	               	id: 'editControlAvatar',
	               	hidden: true,
	               },
	        {
	        	 xtype: 'image',
	        	 //text: 'Информация: Изображение не выбрано',
	        	 src: '/public/images/no_image.jpg',
	        	 id: 'imageSetLabelAvatar',
                 style: 'margin: 10px',
	        	 align: 'center',
	        	 hidden: false,
	         },

	         {
	        	 xtype: 'button',
	        	 text: 'Редактировать изображение',
	        	 id: 'imageAvatarEditorButtonId',
	        	 handler: 'imageEditorAvatar', 
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
