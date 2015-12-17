package controllers;

import java.util.List;

import kz.aphion.brainfights.exceptions.AuthorizationException;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.DepartmentModel;
import kz.aphion.brainfights.models.DepartmentTypeModel;
import kz.aphion.brainfights.models.ResponseWrapperModel;
import kz.aphion.brainfights.models.UserProfileModel;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.DepartmentService;
import kz.aphion.brainfights.services.UserService;
import play.mvc.Controller;

/**
 * Контролле для предоставления статистики
 * 
 * @author artem.demidovich
 *
 */
public class StatisticController extends Controller {

	/**
	 * Рейтинг пользователей
	 */
	public static void getUserStatistics(String authToken, Integer page, Integer limit) {
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	//Изменяем время последней активности пользователя
	    	UserService.updateUserLastActivityTime (user);
			
	    	// Формируем список людей по указанному тексту, кроме указанного пользователя
	    	List<UserProfileModel> model = UserService.getUserStatistics(user, page, limit);	
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
	 * Рейтинг пользователей по департаментам
	 */
	public static void getUsersByDepartmentsStatistics(){
	}
	
	/**
	 * Рейтинг департаментов
	 * @param authToken токен авториазации
	 * @param departmentTypeId выбранный тип подразделения
	 */
	public static void getDepartmentStatistics(String authToken, Long departmentTypeId, Integer page, Integer limit){
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	        	
	    	//Изменяем время последней активности пользователя
	    	UserService.updateUserLastActivityTime (user);
			
	    	// Формируем список людей по указанному тексту, кроме указанного пользователя
	    	List<DepartmentModel> model = DepartmentService.getDepartmentStatisticsByType(user, departmentTypeId, page, limit);	
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
	 * Возвращает существующие типы подразделений для фильтрации
	 */
	public static void getDepartmentTypes(String authToken) {
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	//Изменяем время последней активности пользователя
	    	UserService.updateUserLastActivityTime (user);
			
	    	// Формируем список людей по указанному тексту, кроме указанного пользователя
	    	List<DepartmentTypeModel> model = DepartmentService.getDepartmentTypes(user);	
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
