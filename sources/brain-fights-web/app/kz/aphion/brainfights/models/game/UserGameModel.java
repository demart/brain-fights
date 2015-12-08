package kz.aphion.brainfights.models.game;

import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.persistents.game.GameStatus;
import kz.aphion.brainfights.persistents.game.Gamer;
import kz.aphion.brainfights.persistents.game.GamerStatus;
import kz.aphion.brainfights.persistents.user.User;

/**
 * Модель описания игры 
 * 
 * @author artem.demidovich
 *
 */
public class UserGameModel {

	/**
	 * Идентификатор игры
	 */
	public Long id;
	
	/**
	 * Статус игры
	 */
	public GameStatus gameStatus;
	
	/**
	 * Мой статус в игре
	 */
	public GamerStatus gamerStatus;
	
	/**
	 * Я в игре
	 */
	public GamerModel me;
	
	/**
	 * Опонент
	 */
	public GamerModel oponent;
	
	/**
	 * Просмотрено ли это сообщение пользователем
	 */
	public Boolean seen;

	/**
	 * Очки в результате игры
	 */
	public Integer scrore;
	
	/**
	 * Строит модель описывающую игру
	 * 
	 * @param gamer
	 * @return
	 * @throws PlatformException 
	 */
	public static UserGameModel buildModel(User authorizedUser, Gamer gamer) throws PlatformException {
		if (gamer == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game is null");
		
		UserGameModel model = new UserGameModel();
		
		model.gamerStatus = gamer.getStatus();
		
		model.id = gamer.getGame().id;
		model.gameStatus = gamer.getGame().getStatus();
		
		model.me = GamerModel.buildGamerModel(authorizedUser, gamer);
		
		for (Gamer g : gamer.getGame().getGamers()) {
			if (g.id != gamer.id) {
				model.oponent = GamerModel.buildGamerModel(authorizedUser, g);
			}
		} 
		
		return model;
	}
	
}
