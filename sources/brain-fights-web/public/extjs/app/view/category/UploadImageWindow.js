Ext.define('BrainFightsConsole.view.category.UploadImageWindow', {
    extend: 'Ext.window.Window',
    xtype: 'category-image-window',
    
    requires: [
               'BrainFightsConsole.view.category.CategoryEditWindow',
               ],
    
    title: 'Редактирование изображения',
    width: 450,
    height: 450,
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

	listeners: {
		beforeclose: function() {
			Ext.getCmp('testLabelUpload').setText(document.getElementById('testTmpLabelUpload').innerHTML);
			Ext.getCmp('imageSetLabel').setSrc(document.getElementById('testTmpLabelUpload').innerHTML);
			Ext.getCmp('catImageFile').destroy();
		}
	}
});
