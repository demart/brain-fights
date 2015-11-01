package controllers;

import kz.aphion.brainfights.exceptions.AuthorizationException;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.ResponseWrapperModel;
import kz.aphion.brainfights.models.search.DepartmentSearchResultModel;
import kz.aphion.brainfights.models.search.UserSearchResultModel;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.DepartmentService;
import kz.aphion.brainfights.services.UserService;
import play.mvc.Controller;

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
	
	
}
