package controllers;

import kz.aphion.brainfights.exceptions.AuthorizationException;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.ResponseWrapperModel;
import kz.aphion.brainfights.models.game.GameModel;
import kz.aphion.brainfights.models.game.GameRoundModel;
import kz.aphion.brainfights.models.game.GamerQuestionAnswerResultModel;
import kz.aphion.brainfights.models.game.UserGameModel;
import kz.aphion.brainfights.models.game.UserGamesModel;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.GameService;
import kz.aphion.brainfights.services.UserService;
import play.mvc.Controller;

/**
 * Контроллер для управления игрой
 * 
 * @author artem.demidovich
 *
 */
public class GameController extends Controller {
	
	/**
	 * Отправить приглашение на игру
	 * 	1. Если пользоватль не указан, то это рандом
	 *  2. Если пользователь указан то именно ему
	 *  
	 * @param userId Идентифкатор опонента
	 */
	public static void createInvitation(String authToken, Long userId){
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);

	    	// Создаем приглашение и отправляем уведомления
	    	UserGameModel model = null;
	    	if (userId != null) {
	    		model = GameService.createInvitation(user, userId);
	    	} else {
	    		model = GameService.createRandomInvitation(user);
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
	 * Принимает приглашение играть
	 * 	1. Изменить статус игры
	 * 	2. Отправить пуш уведомление и принятии приглашения
	 * 
	 * @param gameId Идентифкатор игры
	 */
	public static void acceptInvitation(String authToken, Long gameId){
		try {	
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);

	    	GameService.acceptInvitation(user, gameId);
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
	 * Отклонить приглашение играть
	 * 	1. Изменить статус игры
	 * 	2. Отправить пуш уведомление об отказе принять приглашение
	 * 
	 * @param gameId Идентификатор игры
	 */
	public static void declineInvitation(String authToken, Long gameId){
		// TODO
	}
	
	
	/**
	 * Предоставляет список игр пользователя
	 * 	1. Активные игры
	 * 	2. Ожидающие игры
	 * 		2.1 Отправленные запросы на игру
	 * 		2.2 Полученные запросы на игру
	 * 	3. Завершенные игры (последние 5 игр) - не удаленные
	 * 
	 */
	public static void getUserGames(String authToken) {
		try {	
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);

	    	UserGamesModel model = GameService.getUserGames(user);
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
	 * Возвращает информацию об игре
	 * 	1. Кол-во правильных ответов
	 * 	2. Информация об игроках
	 *  3. Информация о раундах и их результатах
	 * @param gameId Идентификатор игры
	 */
	public static void getGameInformation(String authToken, Long gameId){
		// Статус игры
		// Информацию об игроках
		// Информация о счете 
		// Ифнормация о раундах
			// Номер раунда
			// Список вопросов
			// Ответы пользователя
		// Доступные действия
			// Предлагаемые категории вопросов для нового раунда
		try {
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);

	    	GameModel model = GameService.getGameInformation(user, gameId);
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
	 * Генерирует новый раунд игры
	 * 	1. Выбирает вопросы из указанной группы
	 * 	2. Учитывает что каждый пользователь их еще не играл в ближайшие 2-3 недели
	 */	
	public static void generateGameRound(String authToken, Long gameId, Long categoryId){
		try {	
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);

	    	GameRoundModel model = GameService.generateGameRound(user, gameId, categoryId);
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
	 * Возвращает список вопросов и возможных ответов
	 * 	1. В ответ получается список вопросов и ответов
	 * 	2. Если какие-то вопросы уже пройдены то они с пометкой
	 * 	3. Если играет второй участник, то еще ответы первого участника
	 * 
	 * @param gameId идентификатор игры
	 * @param roundId идентификатор раунда
	 */
	public static void  getRoundQuestions(String authToken, Long gameId, Long roundId){
		try {	
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	GameRoundModel model = GameService.getRoundQuestions(user, gameId, roundId);
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
	 * Сохраняет ответ пользователя в игре и в раунде
	 * 	1. Сохранает ответ пользователя 
	 * 	2. Пересчитывает кол-во правильных ответов
	 * 	3.  
	 * 
	 * @param gameId Игра
	 * @param roundId Раунд
	 * @param questionId Вопрос
	 * @param answerId Ответ
	 */
	public static void answerQuestion(String authToken, Long gameId, Long roundId, Long questionId, Long answerId) {
		try {	
			// Проверяем авторизован ли пользователь
	    	User user = UserService.getUserByAuthToken(authToken);
	    	
	    	GamerQuestionAnswerResultModel model = GameService.answerQuestions(user, gameId, roundId, questionId, answerId);
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
