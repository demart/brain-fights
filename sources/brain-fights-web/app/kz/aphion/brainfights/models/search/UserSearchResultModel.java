package kz.aphion.brainfights.models.search;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.brainfights.models.UserProfileModel;

/**
 * 
 * Модель с результатами поиска пользователей
 * 
 * @author artem.demidovich
 *
 */
public class UserSearchResultModel {

	/**
	 * Список найденный пользователей
	 */
	public List<UserProfileModel> users;
 	
	/**
	 * Кол-во найденных пользователей
	 */
	public Integer count;
	
	/**
	 * Всего найдено пользователей
	 */
	public Long totalCount; 
	
	
	public UserSearchResultModel(){
		this.count = 0;
		this.totalCount = 0L;
		this.users = new ArrayList<>();
	}
	
	public UserSearchResultModel(Long totalCount, List<UserProfileModel> users){
		this.users = users;
		this.count = users != null ? users.size() : 0;
		this.totalCount = totalCount;
	}
	
}
