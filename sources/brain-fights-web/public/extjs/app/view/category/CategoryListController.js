Ext.define('BrainFightsConsole.view.category.CategoryListController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.category',
    
    windowMode : 'add',
    
    showAddWindow: function() {
        var win = this.lookupReference('categoryEditWindow');
        if (!win) {
            win = new BrainFightsConsole.view.category.CategoryEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('categoryEditWindowForm').getForm().reset();
        record = Ext.create('BrainFightsConsole.model.CategoryModel');
		record.set(win.down("form").getValues());
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
    onDeleteRecord : function() {
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
    	
    	if (Ext.getCmp('categoryColorEditWindow').getValue() == 0)
       		Ext.Msg.alert('Внимание', 'Пожалуйста, выберите цвет категории!'); 
    	
    	else {
	        var formPanel = this.lookupReference('categoryEditWindowForm'),
	            form = formPanel.getForm();
	        var view = this;
	        if (form.isValid()) {
	        	var record = form.getRecord();
	         	var values = form.getValues();
	        	record.set(values);
	    		
	        	
	           	if (this.windowMode == 'add') {
	        		record.id = '0';
	        		record.data.id = '0';
	                var grid = Ext.getCmp('categoryStoreId');
	           		grid.getStore().add(record);
	        	}
	        	grid.getStore().sync({
					success: function() {
						form.reset();
						view.lookupReference('categoryEditWindow').hide();
						grid.getStore().load();
						
					},
					failure: function(batch) {
						Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
					}
				});
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
    },
    
    onSaveButtonClick: function () {
    	 var model = new BrainFightsConsole.model.CategoryModel();
    	 model.data.name = Ext.getCmp('categoryNameText').getValue();
    	 model.data.color = Ext.getCmp('categoryColorId').getValue();
    	 
         var grid = Ext.getCmp('categoryStoreId');
         var record = grid.getSelectionModel().getSelection()[0];
         
         model.data.id = record.data.id;
         
     	var data = model.getData();
    	console.log(data);
    	
 

    	Ext.Ajax.request({
		    url: '/rest/category/store/update',
		    jsonData : data,
		    
		    success: function(response){
		    	Ext.MessageBox.alert('Успешно','Категория обновлена');
		     	// grid.getStore().removeAll();
		     	 //addressClient.getStore().reload();
		     	 //addresses.getStore().removeAll();
		     	 //clients.getStore().reload();
		    	grid.getStore().reload();
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
		     	 
		    	
		    },
		    failure: function(batch) {
				Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
			}
		});
    	 
    }
    
});