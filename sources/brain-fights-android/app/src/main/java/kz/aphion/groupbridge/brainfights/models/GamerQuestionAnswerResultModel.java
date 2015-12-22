package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 29.11.2015.
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

    /**
     * На сколько изменился рейтинг пользователя после этого ответа (если это последний ответ в игре)
     */
    public Integer gamerScore;
}
