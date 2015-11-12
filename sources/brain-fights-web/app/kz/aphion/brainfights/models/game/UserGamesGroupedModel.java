package kz.aphion.brainfights.models.game;

import java.util.List;

import kz.aphion.brainfights.models.UserProfileModel;

/**
 * Модель со списком игр сгруппированных по статусу
 * 
 * @author artem.demidovich
 *
 */
public class UserGamesGroupedModel {

	/**
	 * Профиль пользователя
	 */
	public UserProfileModel user;
	
	/**
	 * Группы игр пользователя
	 */
	public List<UserGameGroupModel> gameGroups;
	
}
