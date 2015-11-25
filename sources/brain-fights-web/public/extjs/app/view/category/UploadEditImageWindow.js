Ext.define('BrainFightsConsole.view.category.UploadEditImageWindow', {
    extend: 'Ext.window.Window',
    xtype: 'editcategory-image-window',
    
    requires: [
	'BrainFightsConsole.view.category.CategoryEditWindow',
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
    id: 'editCategoryFile',
   // reference: 'catImageFileReference',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
        xtype : "component",
        autoEl : {
            tag : "iframe",
            src : "editCategoryImage.html"
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
