/**
 * The main application controller. This is a good place to handle things like routes.
 */
Ext.define('BrainFightsConsole.controller.Root', {
    extend: 'Ext.app.Controller',
    
    config: {
        refs: {
            main: 'app-main',
        },
    },
    
    routes : {
    	'admins': 'onAdmins',
    	'category': 'onCategory',
    	'question': 'onQuestion',
    	'logout' : 'onLogoutRoute',
    	'users' : 'onUsers',
    },
    
    //Управление администраторами/менеджерами
    onAdmins : function() {
        console.log("onAdminsList route");
        this.getMain().getComponent('mainBody').removeAll(true);
        this.getMain().getComponent('mainBody').add(Ext.create('BrainFightsConsole.view.admins.AdminUsersList'));
    },
    
    //Управление пользователями
    onUsers : function() {
        console.log("onAdminsList route");
        this.getMain().getComponent('mainBody').removeAll(true);
        this.getMain().getComponent('mainBody').add(Ext.create('BrainFightsConsole.view.users.UsersList'));
    },
    
    //Управление категориями
    onCategory : function() {
        console.log("onCategoryList route");
        this.getMain().getComponent('mainBody').removeAll(true);
        this.getMain().getComponent('mainBody').add(Ext.create('BrainFightsConsole.view.category.CategoryList'));
    },
    
    //Управление вопросами
    onQuestion : function() {
        console.log("onQuestionList route");
        this.getMain().getComponent('mainBody').removeAll(true);
        this.getMain().getComponent('mainBody').add(Ext.create('BrainFightsConsole.view.questions.QuestionsList'));
		var questionsGrid = Ext.getCmp('questionsGridId');
		questionsGrid.store.proxy.api.read = 'rest/questions/store/read?categoryId=' + Ext.getCmp('categoryComboId').getValue();
		questionsGrid.getStore().reload();
    },
    
    onLogoutRoute : function() {
        console.log("onLogoutRoute route");
        
        Ext.Ajax.request({
    	    url: '/rest/login/out',
    	    method: 'POST',          
    	    params: { },
    	    success: function(response, conn, options, eOpts) {
    	    	var json = Ext.util.JSON.decode(response.responseText);
    	    	if (json.success) {}
    	    },
    	    failure: function(conn, response, options, eOpts){
    	    	console.log("не удалось выйти");
    	    }
    	});
    	
		window.document.location = "/login";
    },

});
