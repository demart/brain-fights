package kz.aphion.groupbridge.brainfights.models;

import java.util.List;

/**
 * Created by alimjan on 05.11.2015.
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
     * Категория вопросов
     */
    public GameRoundCategoryModel category;
}
