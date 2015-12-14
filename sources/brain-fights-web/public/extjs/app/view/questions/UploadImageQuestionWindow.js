Ext.define('BrainFightsConsole.view.questions.UploadImageQuestionWindow', {
    extend: 'Ext.window.Window',
    xtype: 'question-image-window',
    
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
    id: 'catQuestionFile',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
		        xtype : "component",
		        autoEl : {
		            tag : "iframe",
		            src : "/public/extjs/newQuestionImage.html"
		        },

		       },
		    ],
		    
	  buttons: [
	            {
	            	xtype: 'button',
	            	text: 'Закрыть',
	            	hidden: false,
	            	handler: 'closeImageWindowQuestion'
	            }
	            ],
		
	  listeners: {
		   		beforeclose: function() {
		   			Ext.getCmp('testLabelUploadQuestion').setText(document.getElementById('testTmpLabelUploadQuestion').innerHTML);
		   			Ext.getCmp('imageSetQuestionLabel').setSrc(document.getElementById('testTmpLabelUploadQuestion').innerHTML);
		   			Ext.getCmp('catQuestionFile').destroy();
		   		}
		   	}
});
