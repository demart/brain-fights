package kz.aphion.groupbridge.brainfights.models;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by alimjan on 05.11.2015.
 */
public class GameModel {
    /**
     * Идентифкатор игры
     */
    public Long id;

    /**
     * Статус игры
     */
    @SerializedName("gameStatus")
    public GameStatus status;

    /**
     * Профиль игрока
     */
    public GamerModel me;

    /**
     * Профиль опонента
     */
    public GamerModel oponent;

    /**
     * Список игровых раундов
     */
    public List<GameRoundModel> gameRounds;

    /**
     * Последний раунд
     */
    public GameRoundModel lastRound;

    /**
     * Если статус WAITING_ROUND. пользователь получит список категорий для выбора
     */
    public List<GameRoundCategoryModel> categories;
}
