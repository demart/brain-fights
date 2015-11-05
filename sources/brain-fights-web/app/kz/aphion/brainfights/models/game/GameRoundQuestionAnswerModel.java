package kz.aphion.brainfights.models.game;

import kz.aphion.brainfights.persistents.game.question.Answer;

/**
 * Модель ответа на вопрос
 * 
 * @author artem.demidovich
 *
 */
public class GameRoundQuestionAnswerModel {

	/**
	 * Идентификатор ответа
	 */
	public Long id;
	
	/**
	 * Текст вопроса
	 */
	public String text;
	
	/**
	 *  Правильный ли ответ
	 */
	public Boolean isCorrect;
	
	/**
	 * Создает модель ответа
	 * 
	 * @param answer
	 * @return
	 */
	public static GameRoundQuestionAnswerModel buildModel(Answer answer){
		GameRoundQuestionAnswerModel model = new GameRoundQuestionAnswerModel();
		model.id = answer.id;
		model.isCorrect = answer.getCorrect();
		model.text = answer.getName();
		return model;
	}
	
}
