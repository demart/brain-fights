package kz.aphion.brainfights.models.game;

import kz.aphion.brainfights.persistents.game.question.QuestionType;

/**
 * Модель вопроса в раунде
 * 
 * @author artem.demidovich
 *
 */
public class GameRoundQuestionModel {

	/**
	 * Идентификатор вопроса
	 */
	public Long id;
	
	/**
	 * Тип вопроса
	 */
	public QuestionType type;
	
	/**
	 * Текст вопроса
	 */
	public String text;
	

}
