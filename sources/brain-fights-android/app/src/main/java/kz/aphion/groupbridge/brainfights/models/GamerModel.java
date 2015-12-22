package kz.aphion.groupbridge.brainfights.models;

import java.util.Calendar;

/**
 * Created by alimjan on 05.11.2015.
 */
public class GamerModel {
    /**
     * Идентификатор игрока
     */
    public Long id;

    /**
     * Профиль пользователя
     */
    public UserProfile user;

    /**
     * Статус игрока
     */
    public GamerStatus status;

    /**
     * Время последнего обновления
     */
    public String lastUpdateStatusDate;

    /**
     * Кол-во правильных ответов
     */
    public Integer correctAnswerCount;
    /**
     * Результатов
     */
    public Integer resultScore;

    /**
     * Было ли просмотрено уведомление об окончании игры
     */
    public Boolean resultWasViewed;
}
