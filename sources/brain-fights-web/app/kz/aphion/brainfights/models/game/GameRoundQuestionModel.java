package kz.aphion.brainfights.models.game;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.brainfights.persistents.game.GameRoundQuestion;
import kz.aphion.brainfights.persistents.game.GameRoundQuestionAnswer;
import kz.aphion.brainfights.persistents.game.Gamer;
import kz.aphion.brainfights.persistents.game.question.Answer;
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
	
	/**
	 *  URL для скачивания картинки вопроса
	 */
	public String imageUrl;
	
	/**
	 * Картинка вопроса Base64
	 */
	public String imageUrlBase64;
	
	/**
	 * Возможные ответы на вопросы
	 */
	public List<GameRoundQuestionAnswerModel> answers;
	
	/**
	 * Ответ выбранный пользователем (Если он отвечал уже
	 */
	public GameRoundQuestionAnswerModel answer;

	/**
	 * Ответ другого пользователя если он уже прошел свою часть
	 */
	public GameRoundQuestionAnswerModel oponentAnswer;
	
	/**
	 * Создает модель вопроса и возможных ответов
	 * 
	 * @param gameRoundQuestion
	 * @return
	 */
	public static GameRoundQuestionModel buildModel(GameRoundQuestion gameRoundQuestion, Gamer gamer, Gamer oponent) {
		GameRoundQuestionModel model = new GameRoundQuestionModel();
		model.id = gameRoundQuestion.id;
		// Question
		model.type = gameRoundQuestion.getQuestion().getType();
		model.text = gameRoundQuestion.getQuestion().getText();
		model.imageUrl = gameRoundQuestion.getQuestion().getImageUrl();
		model.answers = new ArrayList<>();
		
		// Формируе список ответов на вопросы
		for (Answer questionAnswer : gameRoundQuestion.getQuestion().getAnswers()) {
			GameRoundQuestionAnswerModel answerModel = GameRoundQuestionAnswerModel.buildModel(questionAnswer);
			model.answers.add(answerModel);
		}
		
		// TODO Проверить если пользователь уже отвечал на вопросы
		// TODO Проверить если опонент уже отвечал на вопросы
		
		// Читаем список уже отвеченных ответов на вопросы
		if (gameRoundQuestion.getQuestionAnswers() != null)
			for (GameRoundQuestionAnswer exitstingsAuestionAnswers : gameRoundQuestion.getQuestionAnswers()) {
				// Найдет ответ игрока
				if (exitstingsAuestionAnswers.getGamer().id == gamer.id) {
					GameRoundQuestionAnswerModel answer =  GameRoundQuestionAnswerModel.buildModel(exitstingsAuestionAnswers.getAnswer());
					model.answer = answer; 
				}
				
				// Найден ответ опонента
				if (exitstingsAuestionAnswers.getGamer().id == oponent.id) {
					GameRoundQuestionAnswerModel answer =  GameRoundQuestionAnswerModel.buildModel(exitstingsAuestionAnswers.getAnswer());
					model.oponentAnswer = answer;
				}
			}
		
		return model;
	}
	
	
}
