Ext.define('BrainFightsConsole.view.category.UploadImageWindow', {
    extend: 'Ext.window.Window',
    xtype: 'category-image-window',
    
    controller: 'category',
    
    requires: [
               'BrainFightsConsole.view.category.CategoryEditWindow',
          		'BrainFightsConsole.view.category.CategoryListController',
               ],
    
    title: 'Редактирование изображения',
    width: 490,
    height: 510,
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closable: true,
    id: 'catImageFile',
    reference: 'catImageFileReference',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
		        xtype : "component",
		        autoEl : {
		            tag : "iframe",
		            src : "/public/extjs/newCategoryImage.html"
		        },
		        tbar: [
		                  {
		                	  xtype: 'button',
		                	  text: 'Закрыть'
		                  }
		                  ]
		     },
      ],
      
      buttons: [
                {
                	xtype: 'button',
                	text: 'Закрыть',
                	hidden: false,
                	handler: 'closeWindowImageCategry'
                }
                ],


	listeners: {
		beforeclose: function() {
			Ext.getCmp('testLabelUpload').setText(document.getElementById('testTmpLabelUpload').innerHTML);
			Ext.getCmp('imageSetLabel').setSrc(document.getElementById('testTmpLabelUpload').innerHTML);
			Ext.getCmp('catImageFile').destroy();
		}
	}
});
