/**
 * This class is the main view for the application. It is specified in app.js as the
 * "autoCreateViewport" property. That setting automatically applies the "viewport"
 * plugin to promote that instance of this class to the body element.
 *
 * TODO - Replace this content of this view to suite the needs of your application.
 */
Ext.define('BrainFightsConsole.view.main.MainController', {
    extend: 'Ext.app.ViewController',

    requires: [
        'Ext.MessageBox'
    ],

    alias: 'controller.main',
    
    routes : {
    },
 
    // Управление администраторами/менеджерами
    onAdminUsersBtnClick : function() {
    	console.log('Admin Users clicked');
    	this.redirectTo('admins');
    },
    
    onQuestionImportBtnClick: function() {
    	console.log('Import questions clicked');
    	this.redirectTo('importQuestions');
    },
    
    //Управление типами подразделений
    onDepartmentsTypeBtnClick : function () {
    	console.log('Departments type');
    	this.redirectTo('departmentsType');
    },
    
    onDepartmentsBtnClick: function () {
    	console.log('Departments clicked');
    	this.redirectTo('departments');
    },
    
    //Управление пользователями
    onUsersBtnClick: function() {
    	console.log('Users clicked');
    	this.redirectTo('users');
    },
    
    // Управление категориями
    onCategoryBtnClick : function() {
    	console.log('Category clicked');
    	this.redirectTo('category');
    },
    
    // Управление вопросами
    onQuestionBtnClick : function() {
    	console.log('Question clicked');
    	this.redirectTo('question');
    },
    
    //Выход
    onLogoutClick: function() {
    	console.log('Logout clicked');
    	this.redirectTo('logout');
    },
 
});
