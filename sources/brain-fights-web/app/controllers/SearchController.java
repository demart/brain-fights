package controllers;

import kz.aphion.brainfights.exceptions.AuthorizationException;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.DepartmentModel;
import kz.aphion.brainfights.models.ResponseWrapperModel;
import kz.aphion.brainfights.models.search.DepartmentSearchResultModel;
import kz.aphion.brainfights.models.search.UserSearchRequestModel;
import kz.aphion.brainfights.models.search.UserSearchResultModel;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.DepartmentService;
import kz.aphion.brainfights.services.UserService;
import play.Logger;
import play.mvc.Controller;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

/**
 * 
 * Контроллер для поиска противников для игры
 * 
 * @author artem.demidovich
 *
 */
public class SearchController extends Controller {

	/**
	 * Ищет по введенному тексту противников. Поиск по 
	 * 	1. Имени пользователя
	 * 	2. Почте пользователя
	 * 
	 * @param authToken токен авторизации
	 * @param searchText текст для поиска
	 */
	public static void searchUsers(String authToken, String searchText) {
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	//Изменяем время последней активности пользователя
	    	UserService.updateUserLastActivityTime (user);
			
	    	// Если отправили не Get а Post
	    	if (searchText == null || "".equals(searchText)) {
	    		UserSearchRequestModel model = null;
		    	try {

					String requestBody = params.current().get("body");
					Logger.debug("user search request body: %s", requestBody);
					Gson gson = new Gson();
					model = gson.fromJson(requestBody, UserSearchRequestModel.class);
				} catch (JsonSyntaxException jSE) {
					throw new PlatformException(ErrorCode.JSON_PARSE_ERROR, "user search requst model is incorrect");
				}   	
		    	if (model == null)
		    		throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user search requst model is empty.");
		    	searchText = model.searchText;
	    	}
	    	
	    	// Формируем список людей по указанному тексту, кроме указанного пользователя
	    	UserSearchResultModel model = UserService.searchUsersByText(user, searchText);
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
	 * Отображение организационной структуры.
	 * 	1. Иерархический поиск по структуре
	 * 	2. Отображение пользователей в орг структуре
	 * 
	 * @param authToken токен авторизации
	 * @param ordanizationUnitId идентификатор структуры
	 */
	public static void searchDepartments(String authToken, Long id) {
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	//Изменяем время последней активности пользователя
	    	UserService.updateUserLastActivityTime (user);
	    	
	    	DepartmentSearchResultModel model = new DepartmentService().getChildren(user, id);
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
	 * Возвращает информацию об указанном департаменте
	 * @param authToken
	 * @param id идентификатор департамента
	 */
	public static void searchDepartmentById(String authToken, Long id) {
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	//Изменяем время последней активности пользователя
	    	UserService.updateUserLastActivityTime (user);
	    	
	    	DepartmentModel model = new DepartmentService().getDepartment(user, id);
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
	
	
}
