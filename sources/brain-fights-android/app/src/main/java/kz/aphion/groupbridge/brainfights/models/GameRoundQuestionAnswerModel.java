package kz.aphion.groupbridge.brainfights.models;

import java.util.List;

/**
 * Created by alimjan on 05.11.2015.
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
}
