package kz.aphion.groupbridge.brainfights.models;

import java.util.List;

/**
 * Created by alimjan on 05.11.2015.
 */
public class GameRoundCategoryModel {
    /**
     * Идентификатор категории
     */
    public Long id;

    /**
     * Название категории
     */
    public String name;

    /**
     * Цвет кагории, не понятно как передавать пока
     */
    public String color;

    /**
     *  URL для скачивания картинки вопроса
     */
    public String imageUrl;

    /**
     * Картинка вопроса Base64
     */
    public String imageUrlBase64;

    /**
     * Список вопросовов в категории
     */
    public List<GameRoundQuestionModel> questions;
}
