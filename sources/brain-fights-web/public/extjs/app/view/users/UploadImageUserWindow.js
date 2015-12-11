Ext.define('BrainFightsConsole.view.users.UploadImageUserWindow', {
    extend: 'Ext.window.Window',
    xtype: 'question-image-window',
    
    requires: [
	//'BrainFightsConsole.view.questions.QuestionsEditWindow',
               ],
    
    title: 'Редактирование изображения',
    width: 450,
    height: 450,
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closable: true,
    id: 'userImageFile',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
		        xtype : "component",
		        autoEl : {
		            tag : "iframe",
		            src : "/public/extjs/newUserImage.html"
		        },
		     },
      ],
      
      listeners: {
  		beforeclose: function() {
  			Ext.getCmp('editControlAvatar').setText('no');
  			Ext.getCmp('uploadImageAvatar').setText(document.getElementById('tmpUploadImageAvatar').innerHTML);
  			Ext.getCmp('imageSetLabelAvatar').setSrc(document.getElementById('tmpUploadImageAvatar').innerHTML);
  			Ext.getCmp('userImageFile').destroy();
  		}
  	}
});
