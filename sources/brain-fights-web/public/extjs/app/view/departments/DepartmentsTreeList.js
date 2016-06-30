Ext.define('BrainFightsConsole.view.departments.DepartmentsTreeList' ,{
    extend: 'Ext.panel.Panel',
    controller: 'departments',
    alias: 'widget.departments.DepartmentsTreeList',
    requires: [
   		'Ext.MessageBox',
   		'Ext.tree.Panel',
   		'Ext.toolbar.Paging',
   		'BrainFightsConsole.view.departments.DepartmentsTreeListController',
   		'BrainFightsConsole.view.departments.DepartmentsTreeEditWindow'
	],

	layout: 'border',
	bodyBorder: true,
	autoDestroy: true,
	
	defaults: {
        //collapsible: true,
        split: true,
        bodyPadding: 10
    },
    
    items: [{
    	title: 'Структура компании',
    	region:'center',
        floatable: false,
        layout: 'fit',
        scroll: true,
        margin: '5 0 0 0',
        flex: 1,
       // minWidth: 250,
       // maxWidth: 400,
       
        items: [
                 {
        	xtype: 'treepanel',
        	reference: 'treeDepartmentsPanel',
        	id: 'treeDepartmentsPanel',
        	useArrows: true,
            rootVisible: false,
            multiSelect: false,
            singleExpand: false,
            collapsed : false,
            collapsible : false,
        	store: 'DepartmentsTreeStore',
			height: 400,
			viewConfig: {
				/*
				getRowClass: function(record, rowIndex, rowParams, store) {
		        	  if (record.get('type') == "Не указан") return 'noTypeDepartment';
		        	 }
		        	 */
			},
        	columns: [{
                xtype: 'treecolumn',
                text: 'Отделения',
                flex: 2,
                sortable: true,
                dataIndex: 'name'
            },
            {
            	text: 'Тип',
            	dataIndex: 'type',
            	renderer: function (v) {
            		if (v == "Не указан")
            			return '<b><span style="color: red;">' + v + '</span></b>';
            		else
            			return '<b><span style="color: green;">' + v + '</span></b>';
            	},
            	width: 250,
            },
            {
            	text: 'Игроков',
            	dataIndex: 'count',
            	width: 80,
            	align: 'center',
            },
            {
            	text: 'Рейтинг',
            	dataIndex: 'score',
            	width: 80,
            	align: 'center'
            },
            
            
            ],
            
            tbar: [
                   {
                	   text: 'Изменить тип подразделения',
                	   handler: 'editTypeDepartment',
                   },
                   {
                	   text: 'Обновить',
                	   handler: 'refreshTree',
                   },
                   {
                	 text: 'Синхронизировать',
                	 handler: 'sinchronization'
                   },
                   {
                       text: 'Свернуть структуру',
                       handler: function(){
        	    		console.log('collapse');
        	           Ext.getCmp('treeDepartmentsPanel').collapseAll();
        	        },
                   },
                   {
                       text: 'Развернуть структуру',
                       handler: function(){
        	    		console.log('expand');
        	           Ext.getCmp('treeDepartmentsPanel').expandAll();
        	        },
                   },
                   {
                	   text: '',
                	   hidden: true,
                	   id: 'selectedRecordId',
                   },
                   {
                	   text: '',
                	   hidden: true,
                	   id: 'selectedRecordTypeId',
                   },
                   {
                	   text: '',
                	   hidden: true,
                	   id: 'selectedRecordNameId'
                   }
                   
                   ],
        listeners: {
              	    
        	itemclick : function(view, record, item, index, e, options) {
        		Ext.getCmp('selectedRecordId').setText(record.data.id);
        		console.log(Ext.getCmp('selectedRecordId').getText());
        		Ext.getCmp('selectedRecordTypeId').setText(record.data.typeId);
        		console.log(Ext.getCmp('selectedRecordTypeId').getText());
        		Ext.getCmp('selectedRecordNameId').setText(record.data.type);
        	
        	},
        	
        	
        	
        	        },
        	        
       
        
        }],
    }],
    
    
    initComponent: function() {
        this.callParent(arguments);
    },



});