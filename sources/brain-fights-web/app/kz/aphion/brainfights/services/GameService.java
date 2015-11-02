package kz.aphion.brainfights.services;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.game.GameRoundQuestionsModel;
import kz.aphion.brainfights.models.game.UserGameModel;
import kz.aphion.brainfights.models.game.UserGamesModel;
import kz.aphion.brainfights.persistents.game.Game;
import kz.aphion.brainfights.persistents.game.GameRound;
import kz.aphion.brainfights.persistents.game.GameRoundQuestion;
import kz.aphion.brainfights.persistents.game.GameRoundStatus;
import kz.aphion.brainfights.persistents.game.GameStatus;
import kz.aphion.brainfights.persistents.game.Gamer;
import kz.aphion.brainfights.persistents.game.GamerStatus;
import kz.aphion.brainfights.persistents.game.question.Category;
import kz.aphion.brainfights.persistents.game.question.Question;
import kz.aphion.brainfights.persistents.user.User;
import play.Logger;
import play.db.jpa.JPA;

/**
 * Сервис для обеспечения игрового процесса
 * 
 * @author artem.demidovich
 *
 */
public class GameService {

	/**
	 * Создает приглашение пользователю
	 * 
	 * @param authorizedUser
	 * @param oponentId
	 * @throws PlatformException 
	 */
	public static void createInvitation(User authorizedUser, Long oponentId) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser is null");
		
		if (authorizedUser.id == oponentId)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser.id and oponent.id can't be the same");
		
		User friend = User.findById(oponentId);
		if (friend == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "oponent with given Id not found");
		if (friend.getDeleted() == true)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "oponent with given Id was deleted");
		
		// Проверка есть ли уже игра с этим игроком
		if (authorizedUser.getGamers() != null && authorizedUser.getGamers().size() > 0) {
			for (Gamer gamer : authorizedUser.getGamers()) {
				
				// Если игра уже закончилась в ней проверять смысла нет
				if (gamer.getGame().getStatus() == GameStatus.FINISHED)
					continue;
				
				for (Gamer oponent : gamer.getGame().getGamers()) {
					// Если уже есть игра с чуваком, то завершаем процесс создания приглашения
					if (oponent.getUser().id == friend.id) {
						// TODO 
						return;
					}
						
				}
			}
		}
		

		createInvitationWithPushNotification(authorizedUser, friend);
		// TODO Send PUSH notification to oponent
	
	}
	
	/**
	 * Создает случайное приглашение пользователю
	 * 
	 * @param authorizedUser
	 * @param oponentId
	 * @throws PlatformException 
	 */
	public static void createRandomInvitation(User authorizedUser) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser is null");
		
		// TODO Добавить ограничение по ID пользователей с кем уже играю
		
		// Retrieve random records
		User oponentUser = User.find("deleted = false and id <> " + authorizedUser.id + "  order by RANDOM()").first();
		if (oponentUser == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "oponent with given Id not found");
		if (oponentUser.getDeleted() == true)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "oponent with given Id was deleted");
		
		// Проверка есть ли уже игра с этим игроком
		if (authorizedUser.getGamers() != null && authorizedUser.getGamers().size() > 0) {
			for (Gamer gamer : authorizedUser.getGamers()) {
				
				// Если игра уже закончилась в ней проверять смысла нет
				if (gamer.getGame().getStatus() == GameStatus.FINISHED)
					continue;
				
				for (Gamer oponent : gamer.getGame().getGamers()) {
					// Если уже есть игра с чуваком, то завершаем процесс создания приглашения
					if (oponent.getUser().id == oponentUser.id) {
						// TODO 
						return;
					}
						
				}
			}
		}
		
		createInvitationWithPushNotification(authorizedUser, oponentUser);
		// TODO Send PUSH notification to oponent
		
	}
	
	
	private static void createInvitationWithPushNotification(User authorizedUser, User oponentUser) {
		// Создвем приглашению на игру
		Game game = new Game();
		game.setInvitationSentDate(Calendar.getInstance());
		game.setStatus(GameStatus.WAITING);
		
		game.save();
		
		// Основной игрок
		Gamer gamer = new Gamer();
		gamer.setUser(authorizedUser);
		gamer.setGame(game);
		gamer.setScore(0);
		gamer.setCorrectAnswerCount(0);
		gamer.setLastUpdateStatusDate(Calendar.getInstance());
		gamer.setStatus(GamerStatus.WAITING_OPONENT_DECISION);
		gamer.setGameInitiator(true);
		
		gamer.save();
		
		// Опонент в текущей игре
		Gamer oponent = new Gamer();
		oponent.setUser(oponentUser);
		oponent.setGame(game);
		oponent.setScore(0);;
		oponent.setCorrectAnswerCount(0);
		oponent.setLastUpdateStatusDate(Calendar.getInstance());
		oponent.setStatus(GamerStatus.WAITING_OWN_DECISION);
		oponent.setGameInitiator(false);
		
		oponent.save();
	}
	
	

	/**
	 * Принимает соглашение
	 * @param user
	 * @param gameId
	 * @throws PlatformException 
	 */
	public static void acceptInvitation(User authorizedUser, Long gameId) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser is null");
		
		Game game = Game.findById(gameId);
		if (game == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game not found");
		
		if (game.getStatus() != GameStatus.WAITING)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game are not in waiting acceptance");
		
		Gamer invitationSender = null;
		Gamer invitationReceiver = null;
		
		for (Gamer gamer : game.getGamers()) {			
			// Игрок которому нужно принять приглашение
			if (gamer.getStatus() == GamerStatus.WAITING_OWN_DECISION)
				invitationReceiver = gamer;
			
			// Игрок отправивший приглашение на игру
			if (gamer.getStatus() == GamerStatus.WAITING_OPONENT_DECISION)
				invitationSender = gamer;
		}
		
		if (invitationSender == null || invitationReceiver == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "invitaion state is incorrect");
		
		if (invitationReceiver.getStatus() != GamerStatus.WAITING_OWN_DECISION)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "invitaion state is incorrect");
		
		
		// Изменяем параметры игры
		game.setStatus(GameStatus.STARTED);
		game.setInvitationAcceptedDate(Calendar.getInstance());
		
		game.save();
		
		// Настраиваем игрока
		invitationSender.setLastUpdateStatusDate(Calendar.getInstance());
		invitationSender.setStatus(GamerStatus.WAITING_OPONENT);
		
		invitationSender.save();
		
		// Настраиваем игрока
		invitationReceiver.setLastUpdateStatusDate(Calendar.getInstance());
		invitationReceiver.setStatus(GamerStatus.WAITING_ROUND);
		
		invitationReceiver.save();
		
		// TODO Отправить PUSH уведомление о том что игрок принял приглашение
		
	}

	/**
	 * Возвращает список игр пользователя
	 * 	1. Активные игры
	 * 	2. Ожидающие принятия
	 * 	3. Завершенные игры (Топ 5)
	 * @param user игрок
	 * @return
	 * @throws PlatformException 
	 */
	public static UserGamesModel getUserGames(User authorizedUser) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser is null");
		
		List<GamerStatus> statuses = new ArrayList<>();
		statuses.add(GamerStatus.WAITING_OPONENT);
		statuses.add(GamerStatus.WAITING_OPONENT_DECISION);
		statuses.add(GamerStatus.WAITING_OWN_DECISION);
		statuses.add(GamerStatus.WAITING_ROUND);
		statuses.add(GamerStatus.WAITING_ANSWERS);
		
		List<Gamer> notCompletedGames = JPA.em().createQuery("from Gamer where user.id = :userId and status in (:statuses)")
				.setParameter("userId", authorizedUser.id)
				.setParameter("statuses", statuses)
				.getResultList();
		
		List<GamerStatus> completedStatuses = new ArrayList<>();
		completedStatuses.add(GamerStatus.DRAW);
		completedStatuses.add(GamerStatus.LOOSER);
		completedStatuses.add(GamerStatus.SURRENDED);
		completedStatuses.add(GamerStatus.WINNER);
		
		// Достаем законченные игры (последние 5 штук)
		List<Gamer> completedGames = JPA.em().createQuery("from Gamer where user.id = :userId and status in (:statuses) order by lastUpdateStatusDate DESC")
				.setMaxResults(5)
				.setParameter("userId", authorizedUser.id)
				.setParameter("statuses", completedStatuses)
				.getResultList();
		
		System.out.println("notCompleted Games count: " + notCompletedGames.size());
		System.out.println("Completed Games count: " + completedGames.size());
		
		
		UserGamesModel gamesModel = new UserGamesModel();
		gamesModel.games = new ArrayList<>();
		
		for (Gamer gamer : notCompletedGames) {
			UserGameModel model = UserGameModel.buildModel(authorizedUser, gamer);
			gamesModel.games.add(model);
		}
		
		for (Gamer gamer : completedGames) {
			UserGameModel model = UserGameModel.buildModel(authorizedUser, gamer);
			gamesModel.games.add(model);
		}
		
		return gamesModel;
	}

	/**
	 * Метод создает новый раунд в игре но основе указанной категории.
	 * 
	 * @param user
	 * @param gameId
	 * @param categoryId
	 * @throws PlatformException 
	 */
	public static GameRoundQuestionsModel generateGameRound(User user, Long gameId, Long categoryId) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user is null");
		
		Game game = Game.findById(gameId);
		if (game == null || game.getDeleted() == null || game.getDeleted() == true)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "game is null or not found");
		
		if (game.getStatus() == GameStatus.FINISHED || game.getStatus() == GameStatus.WAITING)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "game is not in STARTED state");
		
		if (game.getRounds() != null && game.getRounds().size() >= 6)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game already has 6 game round");
		
		if (categoryId == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "category id is null");
		Category category = Category.findById(categoryId);
		if (category == null || category.getDeleted() == null || category.getDeleted() == true)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "category not found or deleted");
		
		// Достаем игрока
		Gamer gamer = null;
		for (Gamer gameGamer : game.getGamers()) {
			if (gameGamer.getUser().id == user.id)
				gamer = gameGamer;
		}
		if (gamer == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "gamer not found");
		if (gamer.getStatus() != GamerStatus.WAITING_ROUND)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "gamer status is not WAITING ROUND");
		
		// Создаем раунд
		GameRound gameRound = new GameRound();
		gameRound.setGame(game);
		gameRound.setCategory(category);
		gameRound.setStatus(GameRoundStatus.WAITING_ANSWER);
		gameRound.setQuestions(new ArrayList<GameRoundQuestion>());
		gameRound.save();
		
		// Генерируем вопросы к раунду
		List<Question> questions = JPA.em().createQuery("from Question where deleted = false and category.id = :categoryId order by RANDOM()")
				.setMaxResults(3)
				.setParameter("categoryId", category.id)
				.getResultList();

		Logger.info("Question count: " + questions.size());
		
		for (Question question : questions) {
			
			GameRoundQuestion grq = new GameRoundQuestion();
			grq.setGameRound(gameRound);
			grq.setQuestion(question);
			grq.save();
			
			gameRound.getQuestions().add(grq);
		}
		
		// Выставляем статус ожидания ответов пользователя
		gamer.setStatus(GamerStatus.WAITING_ANSWERS);
		gamer.save();
		
		
		// Вернуть модель вопросов
		GameRoundQuestionsModel model = new GameRoundQuestionsModel();
		
		return model;
	}
	
}
