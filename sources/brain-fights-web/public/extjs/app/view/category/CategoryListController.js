Ext.define('BrainFightsConsole.view.category.CategoryListController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.category',
    
    windowMode : 'add',
    
    showAddCategoryWindow: function() {
        var win = this.lookupReference('categoryEditWindow');
        if (!win) {
            win = new BrainFightsConsole.view.category.CategoryEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('categoryEditWindowForm').getForm().reset();
        record = Ext.create('BrainFightsConsole.model.CategoryModel');
		record.set(win.down("form").getValues());
		Ext.getCmp('imageSetLabel').setSrc('/public/images/no_image.jpg');
		Ext.getCmp('testLabelUpload').setText('/public/images/no_image.jpg');
		
		//Ext.getCmp('imageSetLabel').setText('Информация: изображение не выбрано');
		
		win.down("form").loadRecord(record);
		this.windowMode = 'add';
        win.show();
    },
    
    showEditWindow: function() {
        var win = this.lookupReference('categoryEditWindow');
        if (!win) {
        	win = new BrainFightsConsole.view.category.CategoryEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('categoryEditWindowForm').getForm().reset();
        var selectedRecord = this.view.getSelectionModel().getSelection()[0];
    	win.down('form').loadRecord(selectedRecord);
    	this.windowMode = 'edit';
    	win.show();
    },  
    
    // Удалить запись
    onDeleteCategoryRecord : function() {
    	var store = Ext.getCmp('categoryStoreId');
    	var selectedRecord = store.getSelectionModel().getSelection()[0];
    	console.log(selectedRecord);
    	if (selectedRecord) {
    		Ext.MessageBox.confirm('Внимание', 'Вы уверены что хотите удалить запись?', 
				function(btn,text) {
    				if (btn == 'yes') {
    					Ext.Ajax.request({
    					    url: 'rest/category/store/destroy',
    					    params: {
    					        id: selectedRecord.data.id,
    					    },
    					    success: function(response){
    					    	store.getStore().reload();
    					    	Ext.getCmp('saveButton').setVisible(false);
    					    	Ext.getCmp('editButton').setVisible(false);
    					    	Ext.getCmp('cancelButton').setVisible(false);
    					        Ext.getCmp('categoryName').setVisible(false);
    					        Ext.getCmp('categoryColor').setVisible(false);
    					        Ext.getCmp('categoryCreatedDate').setVisible(false);
    					        Ext.getCmp('categoryModifiedDate').setVisible(false);
    					        Ext.getCmp('categoryNameText').setVisible(false);
    					        Ext.getCmp('categoryColorId').setVisible(false);
    					        Ext.getCmp('categoryEditorId').setTitle('Просмотр информации о категории');
    					        Ext.getCmp('editImageButtonCategory').setVisible(false);
    					        Ext.getCmp('categoryImage').setVisible(false);
    					    },
    					    failure: function(batch) {
    							Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
    						}
    					});
    				} else {
    				}
    			},
			this);
    	}
    },
    
    onFormCancel: function() {
        this.lookupReference('categoryEditWindowForm').getForm().reset();
        this.lookupReference('categoryEditWindow').hide();
    },
    
    onFormSubmit: function() {
    	if (Ext.getCmp('categoryNameEditForm').getValue() == "")
       		Ext.Msg.alert('Внимание', 'Пожалуйста, введите название категории!'); 
    	
    	if (Ext.getCmp('categoryColorEditWindow').getValue() == "Не указан")
       		Ext.Msg.alert('Внимание', 'Пожалуйста, выберите цвет категории!'); 
    	
    	else {
	        var formPanel = this.lookupReference('categoryEditWindowForm'),
	            form = formPanel.getForm();
	        var view = this;
	        if (form.isValid()) {
	        	var record = form.getRecord();
	         	var values = form.getValues();
	        	record.set(values);
	    		
	        	
	           	//if (this.windowMode == 'add') {
	        		//record.id = '0';
	        		record.data.id = '0';
	        		record.data.imageUrl = document.getElementById('testLabelUpload').innerHTML;
	        		console.log(document.getElementById('testLabelUpload').innerHTML);
	                var grid = Ext.getCmp('categoryStoreId');
	           		//grid.getStore().add(record);
	        	//}
	                
	                var data = record.getData();
	                console.log(data);
	                if (document.getElementById('testLabelUpload').innerHTML == '/public/images/no_image.jpg')
	               	 Ext.Msg.alert('Внимание', 'Выберите изображение категории!');
	                
	                else {
		                Ext.Ajax.request({
		    			    url: '/rest/category/store/create',
		    			    jsonData : data,
		    			    
		    			    success: function(response){
		    			    	Ext.MessageBox.alert('Успешно','Категория создана');
								view.lookupReference('categoryEditWindow').hide();
		    			    	Ext.getCmp('categoryStoreId').getStore().reload();
		    	
		    			     	 
		    			    	
		    			    },
		    			    failure: function(batch) {
		    					Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
		    				}
		    			});
	                }
	        /*	grid.getStore().sync({
					success: function() {
						form.reset();
						view.lookupReference('categoryEditWindow').hide();
						Ext.getCmp('ImageEditorWindowId').hide();
						//Ext.getCmp('testLabelUpload').destroy();
						grid.getStore().load();
						
					},
					failure: function(batch) {
						Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
					}
				});*/
	        }
    	}
    },
    
    onEditButtonClick: function() {
    	Ext.getCmp('saveButton').setVisible(true);
    	Ext.getCmp('editButton').setVisible(false);
    	Ext.getCmp('cancelButton').setVisible(true);
        Ext.getCmp('categoryName').setVisible(false);
        Ext.getCmp('categoryColor').setVisible(false);
        Ext.getCmp('categoryCreatedDate').setVisible(false);
        Ext.getCmp('categoryModifiedDate').setVisible(false);
        Ext.getCmp('categoryNameText').setVisible(true);
        Ext.getCmp('categoryColorId').setVisible(true);
        Ext.getCmp('categoryEditorId').setTitle('Редактирование информации о категории');
        Ext.getCmp('editImageButtonCategory').setVisible(true);
        
        var grid = Ext.getCmp('categoryStoreId');
        var record = grid.getSelectionModel().getSelection()[0];
        Ext.getCmp('categoryNameText').setValue(record.data.name);
        Ext.getCmp('categoryColorId').setValue(record.data.color);
    },
    
    onCancelButtonClick: function() {
    	Ext.getCmp('saveButton').setVisible(false);
    	Ext.getCmp('editButton').setVisible(true);
    	Ext.getCmp('cancelButton').setVisible(false);
        Ext.getCmp('categoryName').setVisible(true);
        Ext.getCmp('categoryColor').setVisible(true);
        Ext.getCmp('categoryCreatedDate').setVisible(true);
        Ext.getCmp('categoryModifiedDate').setVisible(true);
        Ext.getCmp('categoryNameText').setVisible(false);
        Ext.getCmp('categoryColorId').setVisible(false);
        Ext.getCmp('categoryEditorId').setTitle('Просмотр информации о категории');
        Ext.getCmp('editImageButtonCategory').setVisible(false);
        Ext.getCmp('categoryImage').setSrc(document.getElementById('defaultImageCategory').innerHTML);
        
    },
    
    onSaveButtonClick: function () {
    	 var model = new BrainFightsConsole.model.CategoryModel();
    	 model.data.name = Ext.getCmp('categoryNameText').getValue();
    	 model.data.color = Ext.getCmp('categoryColorId').getValue();
    	 
         var grid = Ext.getCmp('categoryStoreId');
         var record = grid.getSelectionModel().getSelection()[0];
         
         model.data.id = record.data.id;
         
         
		 if (document.getElementById('editImageControlCategory').innerHTML == 'yes') {
			 model.data.imageUrl = document.getElementById('nowImageCategory').innerHTML;
			 console.log('editedImage');
		 }
         
         
     	var data = model.getData();
    	console.log(data);
    	
 

    	Ext.Ajax.request({
		    url: '/rest/category/store/update',
		    jsonData : data,
		    
		    success: function(response){
		    	Ext.MessageBox.alert('Успешно','Категория обновлена. Нажмите на категорию, чтобы обновить информацию.');
				Ext.getCmp('editImageControlCategory').setText('no');
		    	grid.getStore().reload();
		    	Ext.getCmp('saveButton').setVisible(false);
		    	Ext.getCmp('editButton').setVisible(true);
		    	Ext.getCmp('cancelButton').setVisible(false);
		        Ext.getCmp('categoryName').setVisible(true);
		        Ext.getCmp('categoryColor').setVisible(true);
		        Ext.getCmp('categoryCreatedDate').setVisible(true);
		        Ext.getCmp('categoryModifiedDate').setVisible(true);
		        Ext.getCmp('categoryNameText').setVisible(false);
		        Ext.getCmp('categoryColorId').setVisible(false);
		        Ext.getCmp('categoryEditorId').setTitle('Просмотр информации о категории');
		        Ext.getCmp('editImageButtonCategory').setVisible(false);
		        Ext.getCmp('categoryImage').setVisible(true);
		     	 
		    	
		    },
		    failure: function(batch) {
				Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
			}
		});
    	 
    },
    
    imageEditor: function() {
    	Ext.getCmp('testTmpLabelUpload').setText(document.getElementById('testLabelUpload').innerHTML);
        var window = new BrainFightsConsole.view.category.UploadImageWindow();

        window.show();
    },
    
    onEditButtonImageCategoryClick: function() {
    	Ext.getCmp('tmpImageLabelCategory').setText(document.getElementById('nowImageCategory').innerHTML);
    	Ext.getCmp('editImageControlCategory').setText('no');
        var window = new BrainFightsConsole.view.category.UploadEditImageWindow();

        window.show();
    },
    
    closeWindowImageCategry: function () {
		Ext.getCmp('testLabelUpload').setText(document.getElementById('testTmpLabelUpload').innerHTML);
		Ext.getCmp('imageSetLabel').setSrc(document.getElementById('testTmpLabelUpload').innerHTML);
		Ext.getCmp('catImageFile').destroy();
    },
    
    closeEditImageWindowCategory: function () {
		Ext.getCmp('editImageControlCategory').setText('no');
		Ext.getCmp('nowImageCategory').setText(document.getElementById('tmpImageLabelCategory').innerHTML);
		Ext.getCmp('categoryImage').setSrc(document.getElementById('tmpImageLabelCategory').innerHTML);
		Ext.getCmp('editCategoryFile').destroy();
    }
    
});