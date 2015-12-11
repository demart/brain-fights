Ext.define('BrainFightsConsole.view.category.UploadEditImageWindow', {
    extend: 'Ext.window.Window',
    xtype: 'editcategory-image-window',
    
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
    id: 'editCategoryFile',
    closeAction: 'hide',
    imageLink: "/public/images/favicon.png",
    
    items: [
            {
		        xtype : "component",
		        autoEl : {
		            tag : "iframe",
		            src : "/public/extjs/editCategoryImage.html"
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
			Ext.getCmp('editImageControlCategory').setText('no');
			Ext.getCmp('nowImageCategory').setText(document.getElementById('tmpImageLabelCategory').innerHTML);
			Ext.getCmp('categoryImage').setSrc(document.getElementById('tmpImageLabelCategory').innerHTML);
			Ext.getCmp('editCategoryFile').destroy();
		}
	}
});
