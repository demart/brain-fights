package kz.aphion.brainfights.models.game;

import java.util.List;

/**
 * Модель списка вопросов которых нужно ответить в раунде
 * 
 * @author artem.demidovich
 *
 */
public class GameRoundQuestionsModel {

	/**
	 * Идентификатор раунда
	 */
	public Long roundId;
	
	/**
	 * Вопросы в раунде
	 */
	public List<GameRoundQuestionModel> questions;
	
}
