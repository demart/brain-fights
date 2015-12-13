Ext.define('BrainFightsConsole.view.category.UploadEditImageWindow', {
    extend: 'Ext.window.Window',
    xtype: 'editcategory-image-window',
    
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
		     },
            ],
            
    buttons: [
              {
            	  xtype: 'button',
            	  text: 'Закрыть',
            	  hidden: false,
            	  handler: 'closeEditImageWindowCategory',
              }
              
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
