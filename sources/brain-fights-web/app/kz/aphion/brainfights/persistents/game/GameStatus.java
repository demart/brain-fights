package kz.aphion.brainfights.persistents.game;

/**
 * Статусы игры 
 * 
 * @author artem.demidovich
 *
 */
public enum GameStatus {

	/**
	 * Ожидаем начала игры
	 */
	WAITING,
	
	/**
	 * Играем
	 */
	STARTED,
	
	/**
	 * Игра закончена (с каким то результатом)
	 */
	FINISHED,
	
}
