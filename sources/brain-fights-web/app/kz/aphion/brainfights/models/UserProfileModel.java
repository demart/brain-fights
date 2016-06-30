package kz.aphion.brainfights.models;

import java.util.Calendar;

import javax.persistence.Column;

import play.db.jpa.JPA;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.DepartmentService;
import kz.aphion.brainfights.services.GameService;
import kz.aphion.brainfights.services.UserService;

/**
 * Профиль пользователя
 * 
 * @author artem.demidovich
 *
 */
public class UserProfileModel {

	// COMMON INFO
	
	public Long id;
	
	/**
	 * Тип пользователя
	 */
	public UserType type;
	
	/**
	 * Имя пользователя
	 */
	public String name;
	
	/**
	 * Должность пользователя
	 */
	public String position;
	
	/**
	 * Аватар пользователя
	 */
	public String imageUrl;
	
	/**
	 * Логин пользователя
	 */
	public String login;
	
	/**
	 * Почтовый ящик пользователя
	 */
	public String email;
	
	/**
	 * Подразделение где работает ползователь (скорее всего отдел)
	 */
	//public String organizationUnit;
	
	/**
	 * Полная цепочка организационный структуры от начала до отдела где работает пользователь
	 * Астана -> Упралвение око -> Департамент услуг -> Отдел ...
	 */
	//public String fullOrganizationPath;
	
	/**
	 * Иерархическая структура к которой относиться данный пользователь
	 */
	public DepartmentModel department;
	
	// STATISTIC
	
	/**
	 * Всего игр
	 */
	public Integer totalGames;
	
	/**
	 * Всего игр
	 */
	public Integer lastTotalGames;	
	
	/**
	 * Выиграно игр
	 */
	public Integer wonGames;
	
	/**
	 * Выиграно игр
	 */
	public Integer lastWonGames;	
	
	/**
	 * Проиграно игр
	 */
	public Integer loosingGames;
	
	/**
	 * Проиграно игр
	 */
	public Integer lastLoosingGames;	
	
	/**
	 * Игр в ничью
	 */
	public Integer drawnGames;
	
	/**
	 * Игр в ничью
	 */
	public Integer lastDrawnGames;	
	
	/**
	 * Рейтинг пользоваля
	 */
	public Integer score;
	
	/**
	 * Рейтинг пользоваля
	 */
	public Integer lastScore;	
	
	/**
	 * Позиция пользователя относиться всех остальных игроков
	 */
	public Integer gamePosition;
	
	/**
	 * Позиция пользователя относиться всех остальных игроков
	 */
	public Integer lastGamePosition;
		
	/**
	 * Время последнего пересчета статистики
	 */
	public String lastStatisticsUpdate;
	
	/**
	 * Состояние игрового процесса по отношению к пользователю.
	 * (Играем или не играем с пользователем)
	 */
	public UserGamePlayingStatus playStatus;
	
	/**
	 * Время последней активности
	 */
	public String lastActivityTime;
	
	
	/**
	 * Строит профиль пользоваля, по умолчанию выставляет USER TYPE = ME
	 * @param user пользователь
	 * @return
	 * @throws PlatformException
	 */
	public static UserProfileModel buildModel(User user) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user is null");
		
		UserProfileModel model = new UserProfileModel();
		
		// Common
		model.type = UserType.ME; // По умолчанию считаем что это профиль игрока
		model.id = user.getId();
		model.name = user.getName();
		model.email = user.getEmail();
		model.position = user.getPosition();
		//model.organizationUnit = user.getDepartment() != null ? user.getDepartment().getName() : "";
		//model.fullOrganizationPath = DepartmentService.getFullOrganzationStructure(user.getDepartment());
		
		// Дерево иерархии
		model.department = user.getDepartment() != null ? DepartmentService.getDepartmentTree(user.getDepartment()) : null;
		
		// Statictics
		model.drawnGames = user.getDrawnGames() != null ? user.getDrawnGames() : 0;
		model.loosingGames = user.getLoosingGames() != null ? user.getLoosingGames() : 0;
		model.wonGames = user.getWonGames() != null ? user.getWonGames() : 0;
		model.totalGames = user.getTotalGames() != null ? user.getTotalGames() : 0;
		model.score = user.getScore() != null ? user.getScore() : 0;
		model.gamePosition = UserService.getUserGamePosition(user); // TODO считать рейтинг чувака
		
		model.playStatus = UserGamePlayingStatus.READY;
		model.imageUrl = user.getImageUrl();
		
		// Last Statistics
		model.lastDrawnGames = user.getLastDrawnGames();
		model.lastGamePosition = user.getLastPosition();
		model.lastLoosingGames = user.getLastLoosingGames();
		model.lastScore = user.getLastScore();
		model.lastTotalGames = user.getLastTotalGames();
		model.lastWonGames = user.getLastWonGames();
		model.lastStatisticsUpdate = user.getLastStatisticsUpdateDateISO8601();
		model.lastActivityTime = user.getLastActivityTimeISO8601();
		
		return model;
	}
	
	/**
	 * Строим профиль пользователя для мобильных приложений. Также на основе параметров выставляется отношение
	 * 	1. Мой профиль
	 * 	2. Мой друг
	 * 	3. Просто опонент
	 * 
	 * @param authorizedUser авторизованный пользователь
	 * @param user другой пользователь
	 * @return
	 * @throws PlatformException
	 */
	public static UserProfileModel buildModel(User authorizedUser, User user) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "authorizedUser user is null");

		UserProfileModel model = buildModel(user);
		
		// Если тот же самый пользователь
		if (authorizedUser.id == user.id) {
			model.type = UserType.ME;
		} else { 
			// Если друг
			if (authorizedUser.getFriends() != null) {
				for (User friend : authorizedUser.getFriends()) {
					if (friend.id == user.id) {
						model.type = UserType.FRIEND;
						break;
					}
				}
			}
			if (model.type == UserType.ME) { 
				// Не друг, просто опонент
				model.type = UserType.OPONENT;
			}
		}
		
		// Если потенциальный противник
		if (model.type != UserType.ME) {
			model.playStatus = GameService.getUserGamePlayingStatus(authorizedUser, user);
		}
		
		return model;
	}
}
