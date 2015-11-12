package kz.aphion.brainfights.models.game;

import java.util.List;

import kz.aphion.brainfights.models.UserProfileModel;

/**
 * Модель с играми пользователя 
 * @author artem.demidovich
 *
 */
public class UserGamesModel {

	/**
	 * Модель пользователя
	 */
	public UserProfileModel user;
	
	/**
	 * Игры пользователя
	 */
	public List<UserGameModel> games;
	
	
}
