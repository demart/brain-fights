package kz.aphion.brainfights.models.game;

import kz.aphion.brainfights.persistents.game.GameRoundQuestionAnswer;
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
	 * Был ли ответ на вопрос или пользователь упустил свой шанс
	 */
	public Boolean isMissingAnswer;
	
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
	
	/**
	 * Строит модель ответов которые сделали пользвоатели, так как пользователь мог не ответить на вопрос
	 * если не успел по таймауту то получается что фактически ответа на вопрос нету, есть факт того что он 
	 * не успел ответить, по умолчанию считается что пользователь неправильно ответил на этот вопрос
	 * @param questionAnswer
	 * @return
	 */
	public static GameRoundQuestionAnswerModel buildModel(GameRoundQuestionAnswer questionAnswer) {
		GameRoundQuestionAnswerModel model = new GameRoundQuestionAnswerModel();
		if (questionAnswer.getAnswer() != null) { 
			model.id = questionAnswer.getAnswer().id;
			model.isCorrect = questionAnswer.getAnswer().getCorrect();
			model.text = questionAnswer.getAnswer().getName();
			model.isMissingAnswer = false;
		} else {
			model.id = 0l;
			model.isCorrect = false;
			model.isMissingAnswer = true;
			model.text = null;
		}
		return model;
	}
	
}
