Ext.define('BrainFightsConsole.view.users.UsersListController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.users',
    
    windowMode : 'add',
    
    showAddWindow: function() {
        var win = this.lookupReference('usersEditWindow');
        if (!win) {
            win = new BrainFightsConsole.view.users.UsersEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('usersEditWindowForm').getForm().reset();
        record = Ext.create('BrainFightsConsole.model.UsersModel');
		record.set(win.down("form").getValues());
		win.down("form").loadRecord(record);
		this.windowMode = 'add';
        win.show();
    },
    
    showEditWindow: function() {
        var win = this.lookupReference('usersEditWindow');
        if (!win) {
        	win = new BrainFightsConsole.view.users.UsersEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('usersEditWindowForm').getForm().reset();
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
    					    url: 'rest/users/store/destroy',
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
    
    onFormSubmit: function() {
        var formPanel = this.lookupReference('usersEditWindowForm'),
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
        	this.view.getStore().sync({
				success: function() {
					form.reset();
					view.lookupReference('usersEditWindow').hide();
					view.view.getStore().reload();
				},
				failure: function(batch) {
					Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
				}
			});
        }
    }
    
});