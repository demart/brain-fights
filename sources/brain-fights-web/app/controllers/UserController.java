package controllers;

import kz.aphion.brainfights.exceptions.AuthorizationException;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.AuthorizationRequestModel;
import kz.aphion.brainfights.models.AuthorizationResponseModel;
import kz.aphion.brainfights.models.DevicePushTokenRegisterModel;
import kz.aphion.brainfights.models.ResponseWrapperModel;
import kz.aphion.brainfights.models.UserFriendsResponseModel;
import kz.aphion.brainfights.models.UserProfileModel;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.ADService;
import kz.aphion.brainfights.services.UserService;
import kz.aphion.brainfights.services.notifications.NotificationService;
import play.Logger;
import play.mvc.Controller;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

/**
 * Контроллер для управления пользователем
 * 
 * @author artem.demidovich
 *
 */
public class UserController extends Controller {

    
    public static void testPush(String authToken) throws PlatformException {
    	User user = UserService.getUserByAuthToken(authToken);
    	NotificationService.sendPushNotificaiton(user, "Привет", "Я пушка");
    }
	
	/**
	 * Авторизация пользователя
	 */
	public static void authenticate(){
		try {

    		AuthorizationRequestModel model = null;
	    	try {

				String requestBody = params.current().get("body");
				Logger.debug("authenticate request body: %s", requestBody);
				Gson gson = new Gson();
				model = gson.fromJson(requestBody, AuthorizationRequestModel.class);
			} catch (JsonSyntaxException jSE) {
				throw new PlatformException(ErrorCode.JSON_PARSE_ERROR, "authenticate request model is incorrect");
			}   	
	    	if (model == null)
	    		throw new PlatformException(ErrorCode.VALIDATION_ERROR, "authenticate request model is empty.");
	    	AuthorizationResponseModel result = UserService.authenticate(model);
	    	renderJSON(ResponseWrapperModel.getSuccess(result));
	    	
		} catch (AuthorizationException aEx) {
			renderJSON(ResponseWrapperModel.getAuthorizationError(aEx.getCode(), aEx));
    	} catch (PlatformException sEx) {
    		renderJSON(ResponseWrapperModel.getServerError(sEx.getCode(), sEx));
    	} catch (Throwable ex) {
			ex.printStackTrace();
			renderJSON(ResponseWrapperModel.getServerError(ErrorCode.UNDEFINED_ERROR, ex));
		}

	}
	
	/**
	 * Возвращает профиль пользователя, если пользователь не передан,
	 * то по умолчанию возвращает профиль текущего пользователя
	 * 
	 * @param ssoToken Токен авторизации
	 * @param userId Идентификатор пользователя
	 * 
	 */
	public static void getProfile(String authToken, Long id){
		try {
			// Проверяем авторизован ли пользователь
	    	User authorizedUser = UserService.getUserByAuthToken(authToken);
	    	
	    	//Записываем время последней активности пользователя
	    	UserService.updateLastActivityTime(authorizedUser);
	    	
	    	UserProfileModel model;
	    	User user = null;
	    	// Если передали пользователя
	    	if (id != null) {
	    		user = User.findById(id);
	    		if (user == null)
	    			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "User not found");
	    	} 
	    	
	    	if (user == null) {
	    		// Мой личный профиль
	    		model = UserProfileModel.buildModel(authorizedUser);
	    	} else {
	    		// Профиль опонента
	    		model = UserProfileModel.buildModel(authorizedUser, user);
	    	}
	    	renderJSON(ResponseWrapperModel.getSuccess(model));
	    	
		} catch (AuthorizationException aEx) {
			renderJSON(ResponseWrapperModel.getAuthorizationError(aEx.getCode(), aEx));
    	} catch (PlatformException sEx) {
    		renderJSON(ResponseWrapperModel.getServerError(sEx.getCode(), sEx));
    	} catch (Throwable ex) {
			ex.printStackTrace();
			renderJSON(ResponseWrapperModel.getServerError(ErrorCode.UNDEFINED_ERROR, ex));
		}
	}
	
	/**
	 * Метод обновляет или записывает новый PUSH ключ для отправки уведомлений
	 * 
	 * @param ssoToken Токен авторизации
	 * 
	 */
	public static void registerOrUpdateDevicePushKey(String authToken){
		try {
			DevicePushTokenRegisterModel model = null;
	    	try {
				String requestBody = params.current().get("body");
				Logger.debug("device push registration request body: %s", requestBody);
				Gson gson = new Gson();
				model = gson.fromJson(requestBody, DevicePushTokenRegisterModel.class);
			} catch (JsonSyntaxException jSE) {
				throw new PlatformException(ErrorCode.JSON_PARSE_ERROR, "register or update device push request model is incorrect");
			}   	
	    	if (model == null)
	    		throw new PlatformException(ErrorCode.VALIDATION_ERROR, "register or update device push request model is empty.");
	    	
	    	// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	// Обновляем PUSH токен
	    	UserService.updateDevicePushToken(user, model);
	    	renderJSON(ResponseWrapperModel.getSuccess(null));
	    	
		} catch (AuthorizationException aEx) {
			renderJSON(ResponseWrapperModel.getAuthorizationError(aEx.getCode(), aEx));
    	} catch (PlatformException sEx) {
    		renderJSON(ResponseWrapperModel.getServerError(sEx.getCode(), sEx));
    	} catch (Throwable ex) {
			ex.printStackTrace();
			renderJSON(ResponseWrapperModel.getServerError(ErrorCode.UNDEFINED_ERROR, ex));
		}
	}
	
	
	// =================================================
	
	/**
	 * Возвращает список профилей друзей пользователя
	 * 
	 * @param authToken токен авторизации
	 */
	public static void getUserFriends(String authToken){
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	//Записываем время последней активности пользователя
	    	UserService.updateLastActivityTime(user);
	    	
	    	UserFriendsResponseModel models = UserService.getUserFriends(user);
	    	renderJSON(ResponseWrapperModel.getSuccess(models));
			
		} catch (AuthorizationException aEx) {
			renderJSON(ResponseWrapperModel.getAuthorizationError(aEx.getCode(), aEx));
    	} catch (PlatformException sEx) {
    		renderJSON(ResponseWrapperModel.getServerError(sEx.getCode(), sEx));
    	} catch (Throwable ex) {
			ex.printStackTrace();
			renderJSON(ResponseWrapperModel.getServerError(ErrorCode.UNDEFINED_ERROR, ex));
		}
	}
	
	
	/**
	 * Добавляет пользователя в друзья
	 * 
	 * @param authToken токен авторизации
	 * @param id идентификатор предполагаемого друга
	 */
	public static void addUserFriend(String authToken, Long id) {
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	//Записываем время последней активности пользователя
	    	UserService.updateLastActivityTime(user);

	    	// Добавляем пользователя
	    	UserService.addUserFriend(user, id);
	    	renderJSON(ResponseWrapperModel.getSuccess(null));
			
		} catch (AuthorizationException aEx) {
			renderJSON(ResponseWrapperModel.getAuthorizationError(aEx.getCode(), aEx));
    	} catch (PlatformException sEx) {
    		renderJSON(ResponseWrapperModel.getServerError(sEx.getCode(), sEx));
    	} catch (Throwable ex) {
			ex.printStackTrace();
			renderJSON(ResponseWrapperModel.getServerError(ErrorCode.UNDEFINED_ERROR, ex));
		}
		
	}
	
	/**
	 * Удаляет друга из друзей
	 * 
	 * @param authToken токен авторизации
	 * @param id идентификатор предполагаемого друга
	 */
	public static void removeUserFriend(String authToken, Long id) {
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	//Записываем время последней активности пользователя
	    	UserService.updateLastActivityTime(user);

	    	// Добавляем пользователя
	    	UserService.removeUserFriend(user, id);
	    	renderJSON(ResponseWrapperModel.getSuccess(null));
			
		} catch (AuthorizationException aEx) {
			renderJSON(ResponseWrapperModel.getAuthorizationError(aEx.getCode(), aEx));
    	} catch (PlatformException sEx) {
    		renderJSON(ResponseWrapperModel.getServerError(sEx.getCode(), sEx));
    	} catch (Throwable ex) {
			ex.printStackTrace();
			renderJSON(ResponseWrapperModel.getServerError(ErrorCode.UNDEFINED_ERROR, ex));
		}
		
	}	
	
	
}
