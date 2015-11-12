package kz.aphion.brainfights.models.game;

import java.util.List;

import kz.aphion.brainfights.persistents.game.GameStatus;

/**
 * Группа игр по модели
 * @author artem.demidovich
 *
 */
public class UserGameGroupModel {
	
	/**
	 * Статус
	 */
	public GameStatus status;
	
	/**
	 * Игры пользователя
	 */
	public List<UserGameModel> games;
	
}
