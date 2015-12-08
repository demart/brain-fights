package kz.aphion.brainfights.models;


/**
 * Показывает состояние пользователя
 * 	Играет со мной
 * 	Не играем со мной
 * 	Пригражение отправил
 * 	Приглашение ждем
 * 
 * @author artem.demidovich
 *
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
