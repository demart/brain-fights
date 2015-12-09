Ext.define('BrainFightsConsole.view.departments.DepartmentsTreeListController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.departments',
    
    editTypeDepartment: function() {
    	 var win = this.lookupReference('depEditWindow');
         if (!win) {
         	win = new BrainFightsConsole.view.departments.DepartmentsTreeEditWindow();
             this.getView().add(win);
         }
     	win.show();
    },

	onFormCancel: function() {
	    this.lookupReference('depEditWindow').hide();
	},

	onFormSubmit: function() {
	  var depId = Ext.getCmp('selectedRecordId').getText();
	  var typeId = Ext.getCmp('depComboId').getValue();
	  Ext.Ajax.request({
		    url: '/rest/departments/store/update?depId=' + depId + '&typeId=' + typeId,
		    method: 'POST',
		    
		    success: function(response){
		    	Ext.MessageBox.alert('Успешно','Тип подразделения обновлен');
			    Ext.getCmp('depEditWindowId').hide();
		    	var tree = Ext.getCmp('treeDepartmentsPanel');
				tree.store.reload();
			
		    },
		    failure: function(batch) {
				Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
			}
		});
	},
	
	refreshTree: function () {
		var tree = this.lookupReference('treeDepartmentsPanel');
		tree.store.reload();
	}

});