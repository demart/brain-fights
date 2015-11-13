Ext.define('BrainFightsConsole.view.questions.QuestionsListController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.questions',

    windowMode : 'add',
    
    showAddWindow: function() {
        var win = this.lookupReference('questionsEditWindow');
        if (!win) {
            win = new BrainFightsConsole.view.questions.QuestionsEditWindow();
            this.getView().add(win);
        }
        this.lookupReference('questionsEditWindowForm').getForm().reset();
        //record = Ext.create('BrainFightsConsole.model.CategoryModel');
		//record.set(win.down("form").getValues());
		//win.down("form").loadRecord(record);
		this.windowMode = 'add';
        win.show();
    },
    
    onAddNewQuestion: function() {
    	 var formPanel = this.lookupReference('questionsEditWindowForm');
     	 var model = new BrainFightsConsole.model.QuestionModel();
     	 
     	 if (Ext.getCmp('nameQuestion').getValue() == "")
     		Ext.Msg.alert('Внимание', 'Пожалуйста, введите текст вопроса!');
     	 
     	 else if (Ext.getCmp('categoryComboForQuestions').getValue() == 0)
     		Ext.Msg.alert('Внимание', 'Пожалуйста, выберите категорию!');
     	 
     	 else if (Ext.getCmp('answer1').getValue() == "")
     		Ext.Msg.alert('Внимание', 'Пожалуйста, введите 1-ый вариант ответа!');
   
     	 else if (Ext.getCmp('answer2').getValue() == "")
      		Ext.Msg.alert('Внимание', 'Пожалуйста, введите 2-ой вариант ответа!');
     	 
     	 else if (Ext.getCmp('answer3').getValue() == "")
      		Ext.Msg.alert('Внимание', 'Пожалуйста, введите 3-ий вариант ответа!');
     	 
     	 else if (Ext.getCmp('answer4').getValue() == "")
      		Ext.Msg.alert('Внимание', 'Пожалуйста, введите 4-ый вариант ответа!');
     	 
     	 else if (Ext.getCmp('answerTrue').getValue() == 0)
       		Ext.Msg.alert('Внимание', 'Пожалуйста, выберите правильный вариант ответа!');     		 
      
     	 else {
	    	 model.data.id = 0;
	    	 model.data.text = Ext.getCmp('nameQuestion').getValue();
	    	 model.data.categoryId = Ext.getCmp('categoryComboForQuestions').getValue();
	     	 
	    	 model.data.answers = new Array();
	    	 model.data.answers[0] = {name: Ext.getCmp('answer1').getValue(), correct: false};
	    	 model.data.answers[1] = {name: Ext.getCmp('answer2').getValue(), correct: false};
	    	 model.data.answers[2] = {name: Ext.getCmp('answer3').getValue(), correct: false};
	    	 model.data.answers[3] = {name: Ext.getCmp('answer4').getValue(), correct: false};
	    	 
	    	 for (var i=0; i<4; i++) {
	    		 if (Ext.getCmp('answerTrue').getValue() == i)
	    			 model.data.answers[i-1].correct = true;
	    	 }
	    	 
	//    	 console.log(model);
	
	    	var data = model.getData();
	    	console.log(data);
	    	
	 
	
	    	Ext.Ajax.request({
			    url: '/rest/questions/store/create',
			    jsonData : data,
			    
			    success: function(response){
			    	Ext.MessageBox.alert('Успешно','Вопрос создан');
			    	Ext.getCmp('questionsEditWindowId').hide();
			    	Ext.getCmp('questionsGridId').getStore().reload();
			     	 
			    	
			    },
			    failure: function(batch) {
					Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
				}
			});
     	 }
    },
    
    onEditButtonQuestionClick: function() {
    	Ext.getCmp('viewQuestionInformationId').setTitle('Редактирование информации о вопросе');
    	
        Ext.getCmp('questionName').setVisible(false);
        Ext.getCmp('questionCreatedDate').setVisible(false);
        Ext.getCmp('questionModifiedDate').setVisible(false);
        Ext.getCmp('questionAnswer1').setVisible(false);
        Ext.getCmp('questionAnswer2').setVisible(false);
        Ext.getCmp('questionAnswer3').setVisible(false);
        Ext.getCmp('questionAnswer4').setVisible(false);
        Ext.getCmp('answerCorrect').setVisible(false);
        Ext.getCmp('editButtonQuestion').setVisible(false);
        Ext.getCmp('saveButtonQuestion').setVisible(true);
        Ext.getCmp('cancelButtonQuestion').setVisible(true);
        
        Ext.getCmp('nameQuestionText').setVisible(true);
        Ext.getCmp('answerTrueText').setVisible(true);
        Ext.getCmp('categoryComboForQuestionsText').setVisible(true);
        Ext.getCmp('answer4Text').setVisible(true);
        Ext.getCmp('answer3Text').setVisible(true);
        Ext.getCmp('answer2Text').setVisible(true);
        Ext.getCmp('answer1Text').setVisible(true);
        
        var grid = Ext.getCmp('questionsGridId');
        var record = grid.getSelectionModel().getSelection()[0];
        console.log(record);
        Ext.getCmp('nameQuestionText').setValue(record.data.text);
        Ext.getCmp('answer1Text').setValue(record.data.answers[0].name);
        Ext.getCmp('answer2Text').setValue(record.data.answers[1].name);
        Ext.getCmp('answer3Text').setValue(record.data.answers[2].name);
        Ext.getCmp('answer4Text').setValue(record.data.answers[3].name);
        Ext.getCmp('categoryComboForQuestionsText').setValue(record.data.categoryId);
        
        for (var i=0; i<4;i++) {
        	if(record.data.answers[i].correct == true) {
                Ext.getCmp('answerTrueText').setValue(i+1);
        	}
        }
    },
    
    onCancelButtonQuestionClick: function() {
        Ext.getCmp('questionName').setVisible(true);
        Ext.getCmp('questionCreatedDate').setVisible(true);
        Ext.getCmp('questionModifiedDate').setVisible(true);
        Ext.getCmp('questionAnswer1').setVisible(true);
        Ext.getCmp('questionAnswer2').setVisible(true);
        Ext.getCmp('questionAnswer3').setVisible(true);
        Ext.getCmp('questionAnswer4').setVisible(true);
        Ext.getCmp('answerCorrect').setVisible(true);
        Ext.getCmp('editButtonQuestion').setVisible(true);
        Ext.getCmp('saveButtonQuestion').setVisible(false);
        Ext.getCmp('cancelButtonQuestion').setVisible(false);
        
        Ext.getCmp('viewQuestionInformationId').setTitle('Просмотр информации о вопросе');
        
        Ext.getCmp('nameQuestionText').setVisible(false);
        Ext.getCmp('answerTrueText').setVisible(false);
        Ext.getCmp('categoryComboForQuestionsText').setVisible(false);
        Ext.getCmp('answer4Text').setVisible(false);
        Ext.getCmp('answer3Text').setVisible(false);
        Ext.getCmp('answer2Text').setVisible(false);
        Ext.getCmp('answer1Text').setVisible(false);
    },
    
    onSaveButtonQuestionClick: function() {
   	 var model = new BrainFightsConsole.model.QuestionModel();
	 model.data.text = Ext.getCmp('nameQuestionText').getValue();
	 model.data.categoryId = Ext.getCmp('categoryComboForQuestionsText').getValue();
	 
	 model.data.answers = new Array();
	 model.data.answers[0] = {name: Ext.getCmp('answer1Text').getValue(), correct: false};
	 model.data.answers[1] = {name: Ext.getCmp('answer2Text').getValue(), correct: false};
	 model.data.answers[2] = {name: Ext.getCmp('answer3Text').getValue(), correct: false};
	 model.data.answers[3] = {name: Ext.getCmp('answer4Text').getValue(), correct: false};
	 
	 for (var i=0; i<4; i++) {
		 if (Ext.getCmp('answerTrueText').getValue() == i)
			 model.data.answers[i-1].correct = true;
	 }
	 
     var grid = Ext.getCmp('questionsGridId');
     var record = grid.getSelectionModel().getSelection()[0];
     
     model.data.id = record.data.id;
     
 	var data = model.getData();
	console.log(data);
	


	Ext.Ajax.request({
	    url: '/rest/questions/store/update',
	    jsonData : data,
	    
	    success: function(response){
	    	Ext.MessageBox.alert('Успешно','Вопрос обновлен. Нажмите на вопрос, чтобы обновить информацию.');
	     	// grid.getStore().removeAll();
	     	 //addressClient.getStore().reload();
	     	 //addresses.getStore().removeAll();
	     	 //clients.getStore().reload();
	    	Ext.getCmp('questionsGridId').getStore().reload();
	    	Ext.getCmp('questionName').setVisible(true);
	        Ext.getCmp('questionCreatedDate').setVisible(true);
	        Ext.getCmp('questionModifiedDate').setVisible(true);
	        Ext.getCmp('questionAnswer1').setVisible(true);
	        Ext.getCmp('questionAnswer2').setVisible(true);
	        Ext.getCmp('questionAnswer3').setVisible(true);
	        Ext.getCmp('questionAnswer4').setVisible(true);
	        Ext.getCmp('answerCorrect').setVisible(true);
	        Ext.getCmp('editButtonQuestion').setVisible(true);
	        Ext.getCmp('saveButtonQuestion').setVisible(false);
	        Ext.getCmp('cancelButtonQuestion').setVisible(false);
	        
	        Ext.getCmp('viewQuestionInformationId').setTitle('Просмотр информации о вопросе');
	        
	        Ext.getCmp('nameQuestionText').setVisible(false);
	        Ext.getCmp('answerTrueText').setVisible(false);
	        Ext.getCmp('categoryComboForQuestionsText').setVisible(false);
	        Ext.getCmp('answer4Text').setVisible(false);
	        Ext.getCmp('answer3Text').setVisible(false);
	        Ext.getCmp('answer2Text').setVisible(false);
	        Ext.getCmp('answer1Text').setVisible(false);
	     	 


	    	
	    },
	    failure: function(batch) {
			Ext.MessageBox.alert('Внимание','Ошибка выполнения запроса');
		}
	});
    },
    
    showAllQuestion: function() {
    	var questionsGrid = Ext.getCmp('questionsGridId');
		questionsGrid.store.proxy.api.read = 'rest/questions/store/read';
		questionsGrid.getStore().reload();
		Ext.getCmp('categoryComboId').setValue(null);
    },
    
    deleteQuestion: function()  {
    	var store = Ext.getCmp('questionsGridId');
	var selectedRecord = store.getSelectionModel().getSelection()[0];
	console.log(selectedRecord);
	if (selectedRecord) {
		Ext.MessageBox.confirm('Внимание', 'Вы уверены что хотите удалить запись?', 
			function(btn,text) {
				if (btn == 'yes') {
					Ext.Ajax.request({
					    url: 'rest/questions/store/destroy',
					    params: {
					        id: selectedRecord.data.id,
					    },
					    success: function(response){
					    	store.getStore().reload();
            		        Ext.getCmp('questionName').setVisible(false);
            		        Ext.getCmp('questionCreatedDate').setVisible(false);
            		        Ext.getCmp('questionModifiedDate').setVisible(false);
            		        Ext.getCmp('questionAnswer1').setVisible(false);
            		        Ext.getCmp('questionAnswer2').setVisible(false);
            		        Ext.getCmp('questionAnswer3').setVisible(false);
            		        Ext.getCmp('questionAnswer4').setVisible(false);
            		        Ext.getCmp('answerCorrect').setVisible(false);
            		        Ext.getCmp('editButtonQuestion').setVisible(false);
            		        Ext.getCmp('saveButtonQuestion').setVisible(false);
            		        Ext.getCmp('cancelButtonQuestion').setVisible(false);
            		        
            		        Ext.getCmp('nameQuestionText').setVisible(false);
            		        Ext.getCmp('answerTrueText').setVisible(false);
            		        Ext.getCmp('categoryComboForQuestionsText').setVisible(false);
            		        Ext.getCmp('answer4Text').setVisible(false);
            		        Ext.getCmp('answer3Text').setVisible(false);
            		        Ext.getCmp('answer2Text').setVisible(false);
            		        Ext.getCmp('answer1Text').setVisible(false);
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
}
    
});