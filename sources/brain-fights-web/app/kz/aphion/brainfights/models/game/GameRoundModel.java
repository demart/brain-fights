package kz.aphion.brainfights.models.game;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.brainfights.persistents.game.GameRound;
import kz.aphion.brainfights.persistents.game.GameRoundQuestion;
import kz.aphion.brainfights.persistents.game.GameRoundStatus;
import kz.aphion.brainfights.persistents.game.Gamer;

/**
 * Модель списка вопросов которых нужно ответить в раунде
 * 
 * @author artem.demidovich
 *
 */
public class GameRoundModel {

	/**
	 * Идентификатор раунда
	 */
	public Long id;
	
	/**
	 * Вопросы в раунде
	 */
	public List<GameRoundQuestionModel> questions;
	/**
	 * Название категории вопросов
	 */
	public String categoryName;
	/**
	 * статус раунда
	 */
	public GameRoundStatus status;
	/**
	 * Создает модель раунда
	 * 
	 * @param gameRound
	 * @param gamer 
	 * @param oponent
	 * @return
	 */
	public static GameRoundModel buildModel(GameRound gameRound, Gamer gamer, Gamer oponent) {
		GameRoundModel model = new  GameRoundModel();
		model.id = gameRound.id;
		
		model.questions = new ArrayList();
		for (GameRoundQuestion gameRoundQuestion : gameRound.getQuestions()) {
			GameRoundQuestionModel gameRoundQuestionModel = GameRoundQuestionModel.buildModel(gameRoundQuestion, gamer, oponent);
			model.questions.add(gameRoundQuestionModel);
		}
		model.categoryName=gameRound.getCategory().getName();
		model.status = gameRound.getStatus();
		return model;
	}
	
}
