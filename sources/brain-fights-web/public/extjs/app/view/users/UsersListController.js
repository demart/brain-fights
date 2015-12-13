Ext.define('BrainFightsConsole.view.users.UsersListController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.users',
    
 
    showImageWindow: function() {
    	console.log("image editor");
    	var grid = Ext.getCmp('usersListId');
    	var record = grid.getSelectionModel().getSelection()[0];
    	  var win = this.lookupReference('imageUsersEditWindow');
          if (!win) {
              win = new BrainFightsConsole.view.users.EditImageWindow();
              this.getView().add(win);
          }
      	Ext.getCmp('imageSetLabelAvatar').setSrc(record.data.imageUrl);
      	Ext.getCmp('uploadImageAvatar').setText(record.data.imageUrl);
      	Ext.getCmp('tmpUploadImageAvatar').setText(record.data.imageUrl);
      	Ext.getCmp('editControlAvatar').setText('no');
      	win.show();
    },
    
    onFormCancel: function() {
        Ext.getCmp('imageUserEditWindowId').hide();
    },
    
    imageEditorAvatar: function() {
      	Ext.getCmp('tmpUploadImageAvatar').setText(document.getElementById('uploadImageAvatar').innerHTML);
    	var window = new BrainFightsConsole.view.users.UploadImageUserWindow();
    	window.show();
    },
    
    onFormSubmit: function() {
    	var model = new BrainFightsConsole.model.UsersModel();
    	var grid = Ext.getCmp('usersListId');
    	var record = grid.getSelectionModel().getSelection()[0];
    	model.data.id = record.data.id;
    	
    	console.log(document.getElementById('editControlAvatar').innerHTML);
    	
    	if (document.getElementById('editControlAvatar').innerHTML == 'yes'){
    		model.data.imageUrl = document.getElementById('uploadImageAvatar').innerHTML;
    		var data = model.getData();
        	
        	Ext.Ajax.request({
    		    url: '/rest/users/image/store/create',
    		    jsonData : data,
    		    
    		    success: function(response){
    		    	Ext.MessageBox.alert('Успешно','Фотография обновлена.');
    		        Ext.getCmp('imageUserEditWindowId').hide();
    		        grid.getStore().reload();
    	
    		    	
    		    },
    		    failure: function(batch) {
    				Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
    			}
    		});
    	}
    	else
    		Ext.Msg.alert('Внимание', 'Фотография не изменена!');
    	    },
    
    searchUsers: function () {
    	console.log("search");
    	var text = Ext.getCmp('searchUsersField');
    	var grid = Ext.getCmp('usersListId');
    	grid.store.proxy.api.read = 'rest/search/users/store/read?name=' + text.getValue();
    	grid.getStore().reload();
    },
    
    showAllUsers: function() {
    	var questionsGrid = Ext.getCmp('usersListId');
		questionsGrid.store.proxy.api.read = 'rest/users/store/read';
		questionsGrid.getStore().reload();
		//Ext.getCmp('categoryComboId').setValue(null);
    	var text = Ext.getCmp('searchUsersField');
    	text.reset();
    },
    
    closeImageWindowUsers: function() {
			Ext.getCmp('editControlAvatar').setText('no');
  			Ext.getCmp('uploadImageAvatar').setText(document.getElementById('tmpUploadImageAvatar').innerHTML);
  			Ext.getCmp('imageSetLabelAvatar').setSrc(document.getElementById('tmpUploadImageAvatar').innerHTML);
  			Ext.getCmp('userImageFile').destroy();
    }
    
});