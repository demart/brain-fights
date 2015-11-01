package kz.aphion.brainfights.persistents.game;

public enum GameRoundStatus {

	/**
	 * Ожидает ответов от обоих участников
	 * 
	 */
	WAITING_ANSWER,
	
	/**
	 * Раунд закончен (Все участники ответили)
	 */
	COMPLETED
	
}
