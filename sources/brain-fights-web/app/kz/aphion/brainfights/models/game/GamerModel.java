package kz.aphion.brainfights.models.game;

import java.util.Calendar;

import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.UserProfileModel;
import kz.aphion.brainfights.persistents.game.Gamer;
import kz.aphion.brainfights.persistents.game.GamerStatus;
import kz.aphion.brainfights.persistents.user.User;

/**
 * Модель игрока
 * 
 * @author artem.demidovich
 *
 */
public class GamerModel {
	
	/**
	 * Идентификатор игрока
	 */
	public Long id;
	
	/**
	 * Профиль пользователя
	 */
	public UserProfileModel user;
	
	/**
	 * Статус игрока
	 */
	public GamerStatus status;
	
	/**
	 * Время последнего обновления
	 * Формат ISO 8601
	 */
	public String lastUpdateStatusDate;
	
	/**
	 * Кол-во правильных ответов
	 */
	public Integer correctAnswerCount;
	
	/**
	 * Результатов
	 */
	public Integer resultScore;
	
	/**
	 * Было ли просмотрено уведомление об окончании игры
	 */
	public Boolean resultWasViewed;
	
	
	public static GamerModel buildGamerModel(User authorizedUser, Gamer gamer) throws PlatformException {
		GamerModel model = new GamerModel();
		
		model.id = gamer.id;
		model.lastUpdateStatusDate = gamer.getLastUpdateStatusDateISO8601();
		model.user = UserProfileModel.buildModel(authorizedUser, gamer.getUser()); 
		model.status = gamer.getStatus();
		model.correctAnswerCount = gamer.getCorrectAnswerCount();
		model.resultScore = gamer.getScore();
		model.resultWasViewed = gamer.getIsResultWasViewed();
		
		return model;
	}
	
}
