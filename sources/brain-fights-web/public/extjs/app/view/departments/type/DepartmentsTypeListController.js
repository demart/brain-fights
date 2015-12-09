Ext.define('BrainFightsConsole.view.departments.type.DepartmentsTypeListController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.departments.type',
    
    windowMode : 'add',
    
    showAddWindow: function() {
        var win = this.lookupReference('typeEditWindow');
        if (!win) {
            win = new BrainFightsConsole.view.departments.type.DepartmentsTypeEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('typeEditWindowForm').getForm().reset();
        record = Ext.create('BrainFightsConsole.model.DepartmentsTypeModel');
		record.set(win.down("form").getValues());
		win.down("form").loadRecord(record);
		this.windowMode = 'add';
        win.show();
    },
    
    showEditWindow: function() {
        var win = this.lookupReference('typeEditWindow');
        if (!win) {
        	win = new BrainFightsConsole.view.departments.type.DepartmentsTypeEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('typeEditWindowForm').getForm().reset();
        var selectedRecord = this.view.getSelectionModel().getSelection()[0];
    	win.down('form').loadRecord(selectedRecord);

    	
    	this.windowMode = 'edit';
    	win.show();
    },  
    
    // Удалить запись
    onDeleteRecord : function() {
    	var store = this.view.getStore();
    	var selectedRecord = this.view.getSelectionModel().getSelection()[0];
    	console.log(selectedRecord);
    	if (selectedRecord) {
    		Ext.MessageBox.confirm('Внимание', 'Вы уверены что хотите удалить запись?', 
				function(btn,text) {
    				if (btn == 'yes') {
    					
    					Ext.Ajax.request({
    					    url: 'rest/departments/type/store/destroy',
    					    params: {
    					        id: selectedRecord.data.id,
    					    },
    					    success: function(response){
    					    	store.reload();
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
        this.lookupReference('typeEditWindowForm').getForm().reset();
        this.lookupReference('typeEditWindow').hide();
    },
    
    onFormSubmit: function() {
        var formPanel = this.lookupReference('typeEditWindowForm'),
            form = formPanel.getForm();
        var view = this;
        if (form.isValid()) {
        	var record = form.getRecord();
         	var values = form.getValues();
        	record.set(values);
    		

        	if (this.windowMode == 'add') {
        		record.id = '0';
        		record.data.id = '0';
           		this.view.getStore().add(record);
        	}
        	

			        	Ext.getCmp('typeListId').getStore().sync({
							success: function() {
								form.reset();
								view.lookupReference('typeEditWindow').hide();
								view.view.getStore().reload();
							},
							failure: function(batch) {
								Ext.MessageBox.alert('Внимание','Ошибка при добавление пользователя');
							}
						});
        	    	

        }
    }
    
});