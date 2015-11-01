package kz.aphion.brainfights.models;

/**
 * Статусы ответа на запросы с мобильного (и не только) приложения
 * 
 * @author artem.demidovich
 *
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
