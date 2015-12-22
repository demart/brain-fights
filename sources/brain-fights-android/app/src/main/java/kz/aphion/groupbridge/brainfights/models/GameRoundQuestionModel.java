package kz.aphion.groupbridge.brainfights.models;

import java.util.List;

/**
 * Created by alimjan on 05.11.2015.
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
}
