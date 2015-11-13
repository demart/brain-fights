Ext.define('BrainFightsConsole.view.admins.AdminUsersListController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.admins',
    
    windowMode : 'add',
    
    showAddWindow: function() {
        var win = this.lookupReference('adminsEditWindow');
        if (!win) {
            win = new BrainFightsConsole.view.admins.AdminUsersEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('adminsEditWindowForm').getForm().reset();
        record = Ext.create('BrainFightsConsole.model.AdminUsersModel');
		record.set(win.down("form").getValues());
		win.down("form").loadRecord(record);
		this.windowMode = 'add';
        win.show();
    },
    
    showEditWindow: function() {
        var win = this.lookupReference('adminsEditWindow');
        if (!win) {
        	win = new BrainFightsConsole.view.admins.AdminUsersEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('adminsEditWindowForm').getForm().reset();
        var selectedRecord = this.view.getSelectionModel().getSelection()[0];
    	win.down('form').loadRecord(selectedRecord);
    	
    	if (selectedRecord.data.role == 'ADMINISTRATOR') {
    		Ext.getCmp('checkbox1').setValue(true);
    		Ext.getCmp('checkbox2').setValue(false);
    	}
    	else {
    		Ext.getCmp('checkbox1').setValue(false);
    		Ext.getCmp('checkbox2').setValue(true);
    	}
    	
    	if (selectedRecord.data.isEnabled == true) {
    		Ext.getCmp('checkbox3').setValue(true);
    		Ext.getCmp('checkbox4').setValue(false);
    	}
    	else {
    		Ext.getCmp('checkbox3').setValue(false);
    		Ext.getCmp('checkbox4').setValue(true);
    	}
    	
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
    					    url: 'rest/admin/users/store/destroy',
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
        this.lookupReference('adminsEditWindowForm').getForm().reset();
        this.lookupReference('adminsEditWindow').hide();
    },
    
    onFormSubmit: function() {
        var formPanel = this.lookupReference('adminsEditWindowForm'),
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
        	
			Ext.Ajax.request({
			    url: 'rest/check/name',
			    params: {
			        name: record.data.login,
			    },
			    success: function(response){
        	    	var json = Ext.util.JSON.decode(response.responseText);
        	    	console.log(json.status);
        	    	if (json.status == "SUCCESS") {
			        	Ext.getCmp('adminListId').getStore().sync({
							success: function() {
								form.reset();
								view.lookupReference('adminsEditWindow').hide();
								view.view.getStore().reload();
							},
							failure: function(batch) {
								Ext.MessageBox.alert('Внимание','Ошибка при добавление пользователя');
							}
						});
        	    	}
        	    	else 
        	    		Ext.MessageBox.alert('Внимание','Данный логин уже существует в системе');
			    },
			    failure: function(batch) {
					Ext.MessageBox.alert('Внимание','Ошибка при отправке запроса на проверку логина');
				}
			});

        }
    }
    
});