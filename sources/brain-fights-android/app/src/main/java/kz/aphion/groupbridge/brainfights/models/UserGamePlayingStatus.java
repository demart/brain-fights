package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 14.12.2015.
 */
public enum UserGamePlayingStatus {

    /**
     * Готов играть
     */
    READY,

    /**
     * Играет сейчас со мной
     */
    PLAYING,

    /**
     * Отпарвили игроку предложение
     */
    INVITED,

    /**
     * Игрок ожидает нашего решения
     */
    WAITING,

}
