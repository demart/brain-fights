package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 04.11.2015.
 */
public enum ResponseStatus {
    /**
     * Ошибка авторизации
     */
    AUTHORIZATION_ERROR,

    /**
     * Операция успешно выполнена
     */
    SUCCESS,

    /**
     * Данные не найдены
     */
    NO_CONTENT,

    /**
     * Ошибки в запросе (валидация)
     */
    BAD_REQUEST,

    /**
     * Ошибка сервера
     */
    SERVER_ERROR
}
