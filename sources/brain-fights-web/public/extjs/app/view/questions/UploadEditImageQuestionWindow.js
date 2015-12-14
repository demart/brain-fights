Ext.define('BrainFightsConsole.view.questions.UploadEditImageQuestionWindow', {
    extend: 'Ext.window.Window',
    xtype: 'editquestion-image-window',
    
    controller: 'questions',
    
    requires: [
               'BrainFightsConsole.view.questions.QuestionsEditWindow',
               ],
    
    title: 'Редактирование изображения',
    width: 490,
    height: 510,
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closable: true,
    id: 'editQuestionFile',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
		        xtype : "component",
		        autoEl : {
		            tag : "iframe",
		            src : "/public/extjs/editQuestionImage.html"
		        },
		      },
      ],
      
      buttons: [
                {
                	xtype: 'button',
                	text: 'Закрыть',
                	hidden: false,
                	handler: 'closeEditImageWindowQuestion',
                }
                ],
      
      listeners: {
  		beforeclose: function() {
			Ext.getCmp('editImageControl').setText('no');
  			
  			Ext.getCmp('nowImageQuestion').setText(document.getElementById('tmpImageLabelQuestion').innerHTML);
  			Ext.getCmp('questionImage').setSrc(document.getElementById('tmpImageLabelQuestion').innerHTML);
  			Ext.getCmp('editQuestionFile').destroy();
  		}
  	}
});
