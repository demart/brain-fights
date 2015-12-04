Ext.define('BrainFightsConsole.view.users.UploadImageUserWindow', {
    extend: 'Ext.window.Window',
    xtype: 'question-image-window',
    
    requires: [
	//'BrainFightsConsole.view.questions.QuestionsEditWindow',
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
    id: 'userImageFile',
   // reference: 'catImageFileReference',
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

    
]
});
