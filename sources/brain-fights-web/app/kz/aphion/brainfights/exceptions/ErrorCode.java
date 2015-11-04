package kz.aphion.brainfights.exceptions;

public class ErrorCode {

	/**
	 * Ошибка возникающая при разборе JSON объектов поступающих на сервер
	 */
	public static final String JSON_PARSE_ERROR = "001";
	
	/**
	 * Ошибка возникающая при валидации сообщений поступающих на сервер
	 */
	public static final String VALIDATION_ERROR = "002";
	
	/**
	 * Не определенная ошибка, не обрабатываемая в коде
	 */
	public static final String UNDEFINED_ERROR = "003";
	
	/**
	 * Данные не найдены
	 */
	public static final String DATA_NOT_FOUND = "004";
	
	/**
	 * Ошибка авторизации
	 */
	public static final String AUTH_ERROR = "005";	
}

