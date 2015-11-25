package kz.aphion.brainfights.models;

/**
 * Модель для регистрации или обновления PUSH ключа для отправки уведомлений
 * 
 * @author artem.demidovich
 *
 */
public class DevicePushTokenRegisterModel {

	/**
	 * Token
	 */
	public String devicePushToken;
	
	/**
	 * Старый токен который был ассоциирован с указанным телефоном и учетной записью
	 */
	public String invalidPushToken;
	
}
