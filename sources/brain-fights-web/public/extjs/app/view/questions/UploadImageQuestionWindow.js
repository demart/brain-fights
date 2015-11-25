Ext.define('BrainFightsConsole.view.questions.UploadImageQuestionWindow', {
    extend: 'Ext.window.Window',
    xtype: 'question-image-window',
    
    requires: [
	'BrainFightsConsole.view.questions.QuestionsEditWindow',
               ],
    
    title: 'Редактирование изображения',
    width: 800,
    height: 650,
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closable: false,
    //closeAble: false,
    id: 'catQuestionFile',
   // reference: 'catImageFileReference',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
        xtype : "component",
        autoEl : {
            tag : "iframe",
            src : "newQuestionImage.html"
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
