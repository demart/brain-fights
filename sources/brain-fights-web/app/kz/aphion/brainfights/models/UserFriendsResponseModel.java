package kz.aphion.brainfights.models;

import java.util.List;

/**
 * Модель со списком друзей
 * 
 * @author artem.demidovich
 *
 */
public class UserFriendsResponseModel {

	/**
	 * Список друзер
	 */
	public List<UserProfileModel> friends;
	
	/**
	 * Кол-во друзей
	 */
	public Integer count;
	
}
