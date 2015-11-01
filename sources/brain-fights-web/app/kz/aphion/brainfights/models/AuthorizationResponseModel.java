package kz.aphion.brainfights.models;

/**
 * Модель для ответа на запрос авторизации
 * 1. Токен
 * 2. Профиль пользователя
 * 
 * @author artem.demidovich
 *
 */
public class AuthorizationResponseModel {

	/**
	 * Токен авторизации для обращения к резурсам
	 */
	public String authToken;
	
	/**
	 * Профиль пользователя
	 */
	public UserProfileModel userProfile;
	
	
	public AuthorizationResponseModel(){}
	
	
	public AuthorizationResponseModel(String authToken, UserProfileModel userProfileModel){
		this.authToken = authToken;
		this.userProfile = userProfileModel;
	}
	
}
