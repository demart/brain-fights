package kz.aphion.brainfights.models.game;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.persistents.game.Game;
import kz.aphion.brainfights.persistents.game.GameRound;
import kz.aphion.brainfights.persistents.game.GameStatus;
import kz.aphion.brainfights.persistents.game.Gamer;


/**
 * Модель отдельной игры 
 * 
 * @author artem.demidovich
 *
 */
public class GameModel {

	/**
	 * Идентифкатор игры
	 */
	public Long id;

	/**
	 * Статус игры
	 */
	public GameStatus status;
	
	/**
	 * Профиль игрока
	 */
	public GamerModel me;
	
	/**
	 * Профиль опонента
	 */
	public GamerModel oponent;
	
	/**
	 * Список игровых раундов
	 */
	public List<GameRoundModel> gameRounds;
	
	/**
	 * Последний раунд
	 */
	public GameRoundModel lastRound;

	/**
	 * Если статус WAITING_ROUND. пользователь получит список категорий для выбора
	 */
	public List<GameRoundCategoryModel> categories;


	// Игроки
	// Статус игры
	// Раунды и данные
	// Вопросы и ответы на них (если есть)
	// Категории если это новый раунд (возможно с вопросами)
	// Можно дружить или нет (это информация об опонента

	/**
	 * Формирует модель игры
	 * 
	 * @param game
	 * @param gamer
	 * @param oponent
	 * @return
	 * @throws PlatformException 
	 */
	public static GameModel buildModel(Game game, Gamer gamer, Gamer oponent, List<GameRoundCategoryModel> categories) throws PlatformException {
		GameModel model = new GameModel();
		model.id = game.id;
		model.status = game.getStatus();
		model.me = GamerModel.buildGamerModel(gamer.getUser(), gamer);
		model.oponent = GamerModel.buildGamerModel(gamer.getUser(), oponent);
		model.categories = categories;
		
		if (game.getRounds() != null)
			for (GameRound gameRound : game.getRounds()) {
				GameRoundModel gameRoundModel = GameRoundModel.buildModel(gameRound, gamer, oponent);
				
				if (model.gameRounds == null)
					model.gameRounds = new ArrayList<GameRoundModel>();
				
				model.lastRound = gameRoundModel; // Перезаписываем до самого последнего
				model.gameRounds.add(gameRoundModel);
			}
		
		return model;
	}
	
	
}
