Ext.define('BrainFightsConsole.view.questions.UploadEditImageQuestionWindow', {
    extend: 'Ext.window.Window',
    xtype: 'editquestion-image-window',
    
    requires: [
               'BrainFightsConsole.view.questions.QuestionsEditWindow',
               ],
    
    title: 'Редактирование изображения',
    width: 450,
    height: 450,
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
		        tbar: [
		                  {
		                	  xtype: 'button',
		                	  text: 'Закрыть'
		                  }
		               ]
		      },
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
