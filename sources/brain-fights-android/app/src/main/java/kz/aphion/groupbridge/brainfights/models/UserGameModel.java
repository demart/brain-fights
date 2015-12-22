package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 28.11.2015.
 */
public class UserGameModel {
    /**
     * Идентификатор игры
     */
    public Long id;

    /**
     * Статус игры
     */
    public GameStatus gameStatus;

    /**
     * Мой статус в игре
     */
    public GamerStatus gamerStatus;

    /**
     * Я в игре
     */
    public GamerModel me;

    /**
     * Опонент
     */
    public GamerModel oponent;

}
