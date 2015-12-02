Ext.define('BrainFightsConsole.view.category.UploadImageWindow', {
    extend: 'Ext.window.Window',
    xtype: 'category-image-window',
    
    requires: [
	'BrainFightsConsole.view.category.CategoryEditWindow',
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
    id: 'catImageFile',
    reference: 'catImageFileReference',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
        xtype : "component",
        autoEl : {
            tag : "iframe",
            src : "newCategoryImage.html"
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
