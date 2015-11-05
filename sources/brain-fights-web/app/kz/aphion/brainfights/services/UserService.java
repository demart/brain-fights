package kz.aphion.brainfights.services;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.UUID;

import org.hibernate.dialect.FirebirdDialect;

import kz.aphion.brainfights.exceptions.AuthorizationException;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.AuthorizationRequestModel;
import kz.aphion.brainfights.models.AuthorizationResponseModel;
import kz.aphion.brainfights.models.DevicePushTokenRegisterModel;
import kz.aphion.brainfights.models.UserFriendsResponseModel;
import kz.aphion.brainfights.models.UserProfileModel;
import kz.aphion.brainfights.models.search.UserSearchResultModel;
import kz.aphion.brainfights.persistents.user.Department;
import kz.aphion.brainfights.persistents.user.User;
import play.Logger;
import play.db.jpa.JPA;

/**
 * Класс сервис для работы с пользователем
 * 
 * @author artem.demidovich
 *
 */
public class UserService {

	/**
	 * Авторизация пользователя и полученте токена для доступа к API
	 * 
	 * @param model Модель авторизации в мобильном приложении
	 * @return SSO Token авторизации
	 * @throws SushimiException Ошибки при попытке авторизоваться
	 */
	public static AuthorizationResponseModel authenticate(AuthorizationRequestModel model) throws PlatformException {
		List<User> users = JPA.em().createQuery("From User where login = :userLogin")
				.setParameter("userLogin", model.login).getResultList();
		if (users.size() == 0)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "User account not found");
		User user  = users.get(0);
		if (user == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "User account not found");
		
		if (user.getDeleted() == true || user.getDeleted() == null)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "User account was deleted");
		
		// Generate new token for auth
		String authToken = UUID.randomUUID().toString();
		user.setAuthToken(authToken);
				
		user.setModifiedDate(Calendar.getInstance());
		user.setLastActivityTime(Calendar.getInstance());
		user.setDeviceOsVersion(model.deviceOsVersion);
		user.setDeviceType(model.deviceType);
		user.setAppVersion(model.appVersion);
		
		if (model.devicePushToken != null || "".equals(model.devicePushToken.trim()))
			user.setDevicePushToken(model.devicePushToken);

		user.save();
		
		UserProfileModel userProfileModel = UserProfileModel.buildModel(user);
		
		return new AuthorizationResponseModel(authToken, userProfileModel);
	}

	/**
	 * Проверяет авторизован ли пользователь или нет
	 * @param authToken Токен авторизации
	 * @return Пользователь
	 * @throws PlatformException Ошибки при приверке токена авторизации
	 */
	public static User getUserByAuthToken(String authToken) throws PlatformException {
		List<User> users = JPA.em().createQuery("From User where authToken = :authToken")
				.setParameter("authToken", authToken).getResultList();
		if (users.size() == 0)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "Authorization token unavailable");
		User user  = users.get(0);
		if (user == null)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "Authorization token unavailable");
		if (user.getDeleted() == null || user.getDeleted() == true)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "User account was disabled or deleted");
		
		return user;
	}
	
	/**
	 * Метод обновляет или добавляет новый токен
	 * @param user
	 * @param model
	 * @return
	 * @throws PlatformException 
	 */
	public static void updateDevicePushToken(User user,
			DevicePushTokenRegisterModel model) throws PlatformException {
		
		if (model == null || model.devicePushToken == null || "".equals(model.devicePushToken.trim()))
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "model is null or devicePushToken is null");
		
		user.setDevicePushToken(model.devicePushToken);
		user.save();
	}

	/**
	 * Поиск пользователей по введенному текст на сервере.
	 * Выдает поиск пользователей без самого пользователя
	 * 
	 * Максимум будет возвращено 50 записей пользовалей + сколько всего для того чтобы можно 
	 * было показать на мобилке и сказать типа "ищи лучше"
	 * 
	 * @param searchText текст для поиска совпадений
	 * 
	 * @return модель результатов поиска
	 * @throws PlatformException 
	 * 
	 */
	public static UserSearchResultModel searchUsersByText(User user, String searchText) throws PlatformException {	
		if (searchText == null || "".equals(searchText.trim()))
			return new UserSearchResultModel();
		
		//  and (name like '%?%' or email like '%?%')
		
		Long totalCount = User.count("deleted = false and id <> ? and (name like ? or email like ?)", user.id, searchText, searchText);
		Logger.info("Found records:" + totalCount);
		
		List<User> users = JPA.em().createQuery("from User where deleted = false and id <> :userId and (name like :searchValue or email like :searchValue)")
			.setParameter("userId", user.id)
			.setParameter("searchValue", "%" + searchText + "%")
		.setMaxResults(50) // Максимально 50 записей за раз
		.getResultList();
		
		UserSearchResultModel model = new UserSearchResultModel();
		model.users = new ArrayList<>();
		
		for (User foundUser : users) {
			if (foundUser == null) 
				continue;
			
			UserProfileModel userProfile = UserProfileModel.buildModel(user, foundUser);
			model.users.add(userProfile);
		}
		
		model.totalCount = totalCount;
		model.count = model.users.size();
		
		return model;
	}

	/**
	 * Проверяет работает ли указанный пользователь в ветке этого департамента
	 * @param authorizedUser
	 * @param unit
	 * @return
	 * @throws PlatformException 
	 */
	public static Boolean isUserBelongsToDepartment(User authorizedUser, Department department) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "authorizedUser is null");
		if (department == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "department is null");
		
		if (department.getUsers() != null) {
			for (User user : department.getUsers()) {
				if (user.id == authorizedUser.id)
					return true;
			}
		}
		
		for (Department childDepartment : department.getChildren()) {
			Boolean isBelongsToDepartment = isUserBelongsToDepartment(authorizedUser, childDepartment);
			if (isBelongsToDepartment)
				return true;
		}
		
		return false;
	}

	/**
	 * Возвращает модель со списком друзей пользователя
	 * @param user
	 * @return
	 * @throws PlatformException 
	 */
	public static UserFriendsResponseModel getUserFriends(User user) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user is null");
		
		UserFriendsResponseModel model = new UserFriendsResponseModel();
		model.friends = new ArrayList<>();
		
		for (User friend : user.getFriends()) {
			if (friend == null)
				continue;
			
			if (friend.getDeleted() == false) {
				UserProfileModel userProfileModel = UserProfileModel.buildModel(user, friend);
				model.friends.add(userProfileModel);
			}
		}
		
		model.count = model.friends.size();
		return model;
	}

	/**
	 * Добавляет друга к пользователю, если друг уже добавлен ошибки не будет
	 * @param user пользователь
	 * @param id идентификатор предполагаемого друга
	 * @throws PlatformException 
	 */
	public static void addUserFriend(User user, Long id) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user is null");
		if (id == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "friend id is null");
		
		// Проверка на читерство :)
		if (user.id == id)
			return;
		
		for (User friend : user.getFriends()) {
			if (friend == null)
				continue;
			
			// Проверяем нет ли уже указанного пользователя в друзьях
			if (friend.id == id)
				return;
		}
		
		User friend = User.findById(id);
		if (friend == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "user with given Id not found");
		if (friend.getDeleted() == true)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "user with given Id was deleted");
		
		user.getFriends().add(friend);
		user.save();
	}

	/**
	 * Удаляет пользователя из друзей если он есть в друзьях
	 * @param user 
	 * @param id
	 * @throws PlatformException 
	 */
	public static void removeUserFriend(User user, Long id) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user is null");
		if (id == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "friend id is null");
		
		User friendToDelete = null;
		for (User friend : user.getFriends()) {
			if (friend.id == id) {
				friendToDelete = friend;
				break;
			}
		}
		
		if (user.getFriends() != null)
			if (user.getFriends().remove(friendToDelete))
				user.save();
	}
	
}
