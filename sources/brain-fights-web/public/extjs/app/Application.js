/**
 * The main application class. An instance of this class is created by app.js when it calls
 * Ext.application(). This is the ideal place to handle application launch and initialization
 * details.
 */
Ext.define('BrainFightsConsole.Application', {
    extend: 'Ext.app.Application',
    name: 'BrainFightsConsole',

    views: [
    ],

    controllers: [
        'Root',
        'Main',
        
    ],

    stores: [
             'UsersStore',
             'AdminUsersStore',
             'CategoryStore',
             'QuestionStore',
             'CategoryComboStore',
        
    ],
    
    launch: function () {
    	/*Ext.create('Ext.container.Viewport', {});*/
    }
});
