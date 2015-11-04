package kz.aphion.brainfights.models.game;

import kz.aphion.brainfights.persistents.game.GameRoundStatus;
import kz.aphion.brainfights.persistents.game.GameStatus;
import kz.aphion.brainfights.persistents.game.GamerStatus;


/**
 * Модель содержит результат ответа пользователя на вопрос
 * 
 * 
 * @author artem.demidovich
 *
 */
public class GamerQuestionAnswerResultModel {

	/**
	 * Статус игры после ответа
	 */
	public GameStatus gameStatus;
	
	/**
	 * Статус раунда после ответа
	 */
	public GameRoundStatus gameRoundStatus;
	
	/**
	 * Статус для игрока после ответа
	 */
	public GamerStatus gamerStatus;
	
}
