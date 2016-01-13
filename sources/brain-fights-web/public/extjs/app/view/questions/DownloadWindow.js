Ext.define('BrainFightsConsole.view.questions.DownloadWindow', {
    extend: 'Ext.window.Window',
    xtype: 'download-edit-window',
    
    reference: 'downloadQuestionsWindow',
    controller: 'questions',
    
    
    title: 'Загрузка файла',
    width: 400,
   // minWidth: 300,
   // minHeight: 150,
   height: 130,
    id: 'downloadQuestionsWindowId',
    layout: 'fit',
    resizable: true,
    modal: true,
    defaultFocus: 'name',
    closeAction: 'hide',
    
    items: [
{
    xtype: 'form',
    reference: 'questionsDownloadWindowForm',
    id: 'formDownload',
    
    border: false,
    bodyPadding: 10,
    
    defaults: {
        anchor: '100%',
        allowBlank: false,
        msgTarget: 'side',
        labelWidth: 50
    },
    items: [
            
{
    xtype: 'filefield',
   // id: 'photo',
    emptyText: 'Выберите файл вопросов',
    fieldLabel: 'Файл',
    name: 'photo',
    buttonText: 'Выбрать файл',
  
}
  
            
            
            ],
}],
        
        
        
        buttons: [
            {
            text: 'Отмена',
            handler: 'onWindowDownloadCancel'
        }, {
            text: 'Загрузить файл',
            handler: function(){
            	//console.log(Ext.getCmp('form-file').getValue())
                var form = Ext.getCmp('formDownload').getForm();
                if(form.isValid()){
                    form.submit({
                        url: '/rest/upload',
                        waitMsg: 'Загрузка...',
                       
                        success: function(form, action) {
	                       	 console.log(action.result);
	                       	 if (action.result.status == "BAD_REQUEST")
	                       		 Ext.Msg.alert('Ошибка', 'Ошибка чтения файла. Доступные форматы: xlsx, csv');
	                       	 else if (action.result.status == "SUCCESS") {
	                       		Ext.getCmp('downloadQuestionsWindowId').hide();
                       		 var store = Ext.getCmp('questionsImportGridId');
                       		 store.getStore().removeAll();
                       		 store.getStore().add(action.result.data);
                       		 Ext.getCmp('saveImportQuestionId').enable();
                       		 Ext.Msg.alert('Внимание', 'Обработано вопросов ' + action.result.modelsQuestions + ' из ' + action.result.downloadQuestions);
                    
	                       	 }
	                         else
	                       		 Ext.Msg.alert('Ошибка', 'Файл не загрузился');
	                       	 
                        },
                     
                         failure: function(form, action) {
                        	 console.log(action.result);
                        	 if (action.result.status == "BAD_REQUEST")
                        		 Ext.Msg.alert('Ошибка', 'Ошибка чтения файла. Доступные форматы: xlsx, csv');
                        	 else if (action.result.status == "SUCCESS") {

                        		 Ext.getCmp('downloadQuestionsWindowId').hide();
                        		 var store = Ext.getCmp('questionsImportGridId');
                        		 store.getStore().removeAll();
                        		 store.getStore().add(action.result.data);
                        		 Ext.getCmp('saveImportQuestionId').enable();
                        		 Ext.Msg.alert('Внимание', 'Обработано вопросов ' + action.result.modelsQuestions + ' из ' + action.result.downloadQuestions);
                        	 }
                        	 else
                        		 Ext.Msg.alert('Ошибка', 'Файл не загрузился');
                         }
                 
                       
                    });
                }
            }
        }]
    
});
