Ext.define('BrainFightsConsole.view.questions.UploadEditImageQuestionWindow', {
    extend: 'Ext.window.Window',
    xtype: 'editquestion-image-window',
    
    requires: [
	'BrainFightsConsole.view.questions.QuestionsEditWindow',
               ],
    
    title: 'Редактирование изображения',
    width: 800,
    height: 750,
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closable: false,
    //closeAble: false,
    id: 'editQuestionFile',
   // reference: 'catImageFileReference',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
        xtype : "component",
        autoEl : {
            tag : "iframe",
            src : "editQuestionImage.html"
        },
        tbar: [
                  {
                	  xtype: 'button',
                	  text: 'Закрыть'
                  }
                  ]
            },

    
]
});
