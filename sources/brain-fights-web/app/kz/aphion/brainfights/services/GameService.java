package kz.aphion.brainfights.services;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.UserProfileModel;
import kz.aphion.brainfights.models.game.GameModel;
import kz.aphion.brainfights.models.game.GameRoundCategoryModel;
import kz.aphion.brainfights.models.game.GameRoundModel;
import kz.aphion.brainfights.models.game.GamerQuestionAnswerResultModel;
import kz.aphion.brainfights.models.game.UserGameGroupModel;
import kz.aphion.brainfights.models.game.UserGameModel;
import kz.aphion.brainfights.models.game.UserGamesGroupedModel;
import kz.aphion.brainfights.models.game.UserGamesModel;
import kz.aphion.brainfights.persistents.game.Game;
import kz.aphion.brainfights.persistents.game.GameRound;
import kz.aphion.brainfights.persistents.game.GameRoundQuestion;
import kz.aphion.brainfights.persistents.game.GameRoundQuestionAnswer;
import kz.aphion.brainfights.persistents.game.GameRoundStatus;
import kz.aphion.brainfights.persistents.game.GameStatus;
import kz.aphion.brainfights.persistents.game.Gamer;
import kz.aphion.brainfights.persistents.game.GamerStatus;
import kz.aphion.brainfights.persistents.game.question.Answer;
import kz.aphion.brainfights.persistents.game.question.Category;
import kz.aphion.brainfights.persistents.game.question.Question;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.notifications.NotificationService;
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
	public static UserGameModel createInvitation(User authorizedUser, Long oponentId) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser is null");
		
		if (authorizedUser.id == oponentId)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser.id and oponent.id can't be the same");
		
		User friend = User.findById(oponentId);
		if (friend == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "oponent with given Id not found");
		if (friend.getDeleted())
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "oponent with given Id was deleted");
		
		// Проверка есть ли уже игра с этим игроком
		if (authorizedUser.getGamers() != null && authorizedUser.getGamers().size() > 0) {
			for (Gamer gamer : authorizedUser.getGamers()) {
				
				// Если удалили игрока
				if (gamer.getDeleted())
					continue;
				
				// Если игра уже закончилась в ней проверять смысла нет
				if (gamer.getGame().getStatus() == GameStatus.FINISHED)
					continue;
				
				for (Gamer oponent : gamer.getGame().getGamers()) {
					// Если уже есть игра с чуваком, то завершаем процесс создания приглашения
					if (oponent.getUser().id == friend.id) {
						// TODO 
						throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user already plays with you");
					}
						
				}
			}
		}
		

		Game game = createInvitationWithPushNotification(authorizedUser, friend);
		// TODO Send PUSH notification to oponent
		Gamer gamer = null;
		for (Gamer gamerObject : game.getGamers())
			if (gamerObject.getUser().id == authorizedUser.id)
				gamer = gamerObject;
		
		// PUSH уведомление
		Logger.info("PUSH " + friend.getName() + " вам пришло приглашение сыграть игру!");
		NotificationService.sendPushNotificaiton(friend, "Кайдзен", friend.getName() + " вам пришло приглашение сыграть игру!");
		
		UserGameModel model = UserGameModel.buildModel(authorizedUser, gamer);
		return model;
		
	}
	
	/**
	 * Создает случайное приглашение пользователю
	 * 
	 * @param authorizedUser
	 * @param oponentId
	 * @throws PlatformException 
	 */
	public static UserGameModel createRandomInvitation(User authorizedUser) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser is null");
		
		// Статусы активных игр
		List<GamerStatus> statuses = new ArrayList<GamerStatus>();
		statuses.add(GamerStatus.WAITING_ANSWERS);
		statuses.add(GamerStatus.WAITING_OPONENT);
		statuses.add(GamerStatus.WAITING_OPONENT_DECISION);
		statuses.add(GamerStatus.WAITING_OWN_DECISION);
		statuses.add(GamerStatus.WAITING_ROUND);
		
		// TODO Добавить ограничение по ID пользователей с кем уже играю
		List<Gamer> myGamerPresents = JPA.em().createQuery("from Gamer where deleted = false and status in (:statuses) and user.id = :userId")
		.setParameter("statuses", statuses)
		.setParameter("userId", authorizedUser.id)
		.getResultList();
		
		List<Long> exceptionUsersToPlayRandomGame = new ArrayList<Long>();
		for (Gamer myGamerPresent : myGamerPresents) {
			exceptionUsersToPlayRandomGame.add(myGamerPresent.getOponent().getUser().id);
		}
		exceptionUsersToPlayRandomGame.add(authorizedUser.id);
		
		// Retrieve random records
		User oponentUser = User.find("deleted = false and id not in (:exceptions)  order by RANDOM()")
				.setParameter("exceptions", exceptionUsersToPlayRandomGame)
				.first();
		
		if (oponentUser == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "we didn't find anybody for you to play, maybe you already playing with all players");
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
						throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user already plays with you");
					}
				}
			}
		}
		
		Game game = createInvitationWithPushNotification(authorizedUser, oponentUser);

		Gamer gamer = null;
		for (Gamer gamerObject : game.getGamers())
			if (gamerObject.getUser().id == authorizedUser.id)
				gamer = gamerObject;
		
		// PUSH уведомление
		Logger.info("PUSH " + oponentUser.getName() + " вам пришло приглашение сыграть игру!");
		NotificationService.sendPushNotificaiton(oponentUser, "Кайдзен", oponentUser.getName() + " вам пришло приглашение сыграть игру!");
		
		UserGameModel model = UserGameModel.buildModel(authorizedUser, gamer);
		return model;
	}
	
	
	private static Game createInvitationWithPushNotification(User authorizedUser, User oponentUser) {
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
		
		gamer.setOponent(oponent);
		gamer.save();
		
		oponent.setOponent(gamer);
		oponent.save();
		
		if (game.getGamers() == null)
			game.setGamers(new ArrayList<Gamer>());
		game.getGamers().add(gamer);
		game.getGamers().add(oponent);
		
		return game;
	}
	
	

	/**
	 * Принимает соглашение
	 * @param user
	 * @param gameId
	 * @param accept Принять соглашение или нет
	 * @throws PlatformException 
	 */
	public static UserGameModel acceptInvitation(User authorizedUser, Long gameId, Boolean accept) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser is null");
		
		Game game = Game.findById(gameId);
		if (game == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game not found");
		if (game.getDeleted())
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
		
		if (accept) {
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
			Logger.info("PUSH " + invitationSender.getUser().getName() + " игрок принял ваше приглашение!");
			NotificationService.sendPushNotificaiton(invitationSender.getUser(), "Кайдзен", invitationSender.getUser().getName() + " игрок принял ваше приглашение!");
		} else {
			// Изменяем параметры игры
			game.setStatus(GameStatus.WAITING);
			game.setInvitationAcceptedDate(Calendar.getInstance());
			game.setDeleted(true);
			
			game.save();
			
			// Настраиваем игрока
			invitationSender.setLastUpdateStatusDate(Calendar.getInstance());
			invitationSender.setDeleted(true);
			
			invitationSender.save();
			
			// Настраиваем игрока
			invitationReceiver.setLastUpdateStatusDate(Calendar.getInstance());
			invitationReceiver.setDeleted(true);
			
			invitationReceiver.save();
			
			// TODO Отправить PUSH уведомление о том что игрок не принял приглашение
			Logger.info("PUSH " + invitationSender.getUser().getName() + " игрок отказался принять ваше приглашение!");
			NotificationService.sendPushNotificaiton(invitationSender.getUser(), "Кайдзен", invitationSender.getUser().getName() + " игрок отказался принять ваше приглашение!");
			
		}
		
		UserGameModel model = UserGameModel.buildModel(authorizedUser, invitationReceiver);
		return model;
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
		gamesModel.user = UserProfileModel.buildModel(authorizedUser);
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
	 * Возвращает список игр пользователя сгруппированные по статусу
	 * 	1. Активные игры
	 * 	2. Ожидающие принятия
	 * 	3. Завершенные игры (Топ 5)
	 * @param user игрок
	 * @return
	 * @throws PlatformException 
	 */
	public static UserGamesGroupedModel getUserGamesGrouped(User authorizedUser) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "autorizedUser is null");
		
		List<GamerStatus> waitingStatuses = new ArrayList<>();
		waitingStatuses.add(GamerStatus.WAITING_OPONENT_DECISION);
		waitingStatuses.add(GamerStatus.WAITING_OWN_DECISION);
		
		List<Gamer> waitingGames = JPA.em().createQuery("from Gamer where user.id = :userId and status in (:statuses) and deleted = false")
				.setParameter("userId", authorizedUser.id)
				.setParameter("statuses", waitingStatuses)
				.getResultList();
		
		List<GamerStatus> inProgressStatuses = new ArrayList<>();
		inProgressStatuses.add(GamerStatus.WAITING_OPONENT);
		inProgressStatuses.add(GamerStatus.WAITING_ROUND);
		inProgressStatuses.add(GamerStatus.WAITING_ANSWERS);
		
		List<Gamer> inProgressGames = JPA.em().createQuery("from Gamer where user.id = :userId and status in (:statuses) and deleted = false")
				.setParameter("userId", authorizedUser.id)
				.setParameter("statuses", inProgressStatuses)
				.getResultList();
		
		List<GamerStatus> completedStatuses = new ArrayList<>();
		completedStatuses.add(GamerStatus.DRAW);
		completedStatuses.add(GamerStatus.LOOSER);
		completedStatuses.add(GamerStatus.SURRENDED);
		completedStatuses.add(GamerStatus.WINNER);
		
		// Достаем законченные игры (последние 5 штук)
		List<Gamer> completedGames = JPA.em().createQuery("from Gamer where user.id = :userId and status in (:statuses) and deleted = false order by lastUpdateStatusDate DESC")
				.setMaxResults(5)
				.setParameter("userId", authorizedUser.id)
				.setParameter("statuses", completedStatuses)
				.getResultList();
		
		System.out.println("waiting Games count: " + waitingGames.size());
		System.out.println("in progress Games count: " + inProgressGames.size());
		System.out.println("Completed Games count: " + completedGames.size());
		
		UserGamesGroupedModel gamesModel = new UserGamesGroupedModel();
		gamesModel.user = UserProfileModel.buildModel(authorizedUser);
		gamesModel.gameGroups = new ArrayList<>();
		
		if (inProgressGames.size() > 0) {
			UserGameGroupModel model = new UserGameGroupModel();
			model.status = GameStatus.STARTED;
			model.games = new ArrayList<>();
			for (Gamer gamer : inProgressGames) {
				UserGameModel gameModel = UserGameModel.buildModel(authorizedUser, gamer);
				model.games.add(gameModel);
			}
			gamesModel.gameGroups.add(model);
		}
		
		if (waitingGames.size() > 0) {
			UserGameGroupModel model = new UserGameGroupModel();
			model.status = GameStatus.WAITING;
			model.games = new ArrayList<>();
			for (Gamer gamer : waitingGames) {
				UserGameModel gameModel = UserGameModel.buildModel(authorizedUser, gamer);
				model.games.add(gameModel);
			}
			gamesModel.gameGroups.add(model);
		}
		
		if (completedGames.size() > 0) {
			UserGameGroupModel model = new UserGameGroupModel();
			model.status = GameStatus.FINISHED;
			model.games = new ArrayList<>();
			for (Gamer gamer : completedGames) {
				UserGameModel gameModel = UserGameModel.buildModel(authorizedUser, gamer);
				model.games.add(gameModel);
			}
			gamesModel.gameGroups.add(model);
		}
		
		return gamesModel;
	}
	
	/**
	 * Метод формирует модель игры, в которой
	 * 1. Информация об игроках
	 * 2. Информация о текущем состояниии игры
	 * 3. Информация о возможных действиях (играть, реванш и т.д.)
	 * 4. Информация можно ли добавить чувака в друзья
	 * @param user
	 * @param gameId
	 * @return
	 * @throws PlatformException 
	 */
	public static GameModel getGameInformation(User user, Long gameId) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.AUTH_ERROR, "user is null");
		if (user.getDeleted())
			throw new PlatformException(ErrorCode.AUTH_ERROR, "user was deleted");
		
		// Проверяем игру
		Game game = Game.findById(gameId);
		if (game == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "game not found");
		if (game.getDeleted())
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game was deleted");
		
		// Получаем список игроков
		Gamer gamer = null;
		Gamer oponent = null;
		for (Gamer gamerObject : game.getGamers()) {
			if (gamerObject.getUser().id == user.id) {
				gamer = gamerObject;
				oponent = gamer.getOponent();
			}
		}
		// TODO CHECKS
		
		// Если пользователю выбирать вопросы к раунду то, сгенерируем их сразу
		List<GameRoundCategoryModel> categories = null;
		if (gamer.getStatus() == GamerStatus.WAITING_ROUND) {
			categories = new ArrayList<GameRoundCategoryModel>();
			
			// Формируем список использованных категорий в игре
			List<Long> usedCategoryIds = new ArrayList<>();
			if (game.getRounds() != null)
				for (GameRound gameRound : game.getRounds()) {
					usedCategoryIds.add(gameRound.getCategory().id);
				}
			
			// Fox for first calls
			if (usedCategoryIds.size() == 0)
				usedCategoryIds.add(-1l);
			
			// Получаем список категорий, крое использованных
			List<Category> result = JPA.em().createQuery("from Category where deleted = false and id not in (:ids) order by RANDOM()")
					.setParameter("ids", usedCategoryIds)
					.setMaxResults(3)
					.getResultList();
			
			for (Category category : result) {
				GameRoundCategoryModel gameRoundCategoryModel = GameRoundCategoryModel.buildModel(category);
				categories.add(gameRoundCategoryModel);
			}
			
		}
		
		// Строим модель игры
		GameModel model = GameModel.buildModel(game, gamer, oponent, categories);  
		
		return model;
	}
	
	
	
	
	/**
	 * Метод создает новый раунд в игре но основе указанной категории.
	 * Генерирует 3 случайных вопроса для игры.
	 * 
	 * @param user
	 * @param gameId
	 * @param categoryId
	 * @throws PlatformException 
	 */
	public static GameRoundModel generateGameRound(User user, Long gameId, Long categoryId) throws PlatformException {
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
		
		if (game.getRounds() != null)
			for (GameRound gameRound : game.getRounds()) {
				if (gameRound.getCategory().id == category.id)
					throw new PlatformException(ErrorCode.VALIDATION_ERROR, "category already used in this game, in previous round");
			}
		
		
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
		gameRound.setOwner(gamer); // Кто создает раунд тот и главный
		gameRound.setNumber(game.getRounds().size()+1); // текущее кол-во плюс один
		gameRound.setStatus(GameRoundStatus.WAITING_ANSWER);
		gameRound.setQuestions(new ArrayList<GameRoundQuestion>());
		gameRound.save();
		
		// Если это первый раунд то сохраняем когда игра началась
		game.setGameStartedDate(Calendar.getInstance());
		game.save();
		
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
		GameRoundModel model = GameRoundModel.buildModel(gameRound, gamer, gamer.getOponent());
		
		return model;
	}

	/**
	 * Метод возврщает список вопросов к раунду, 
	 * также умеет восстанавливать сессию и показывать какие вопросы пользователь уже ответил.
	 * Показывает также какие варианты ответов были у его опонента.
	 * @param user
	 * @param gameId
	 * @param roundId
	 * @return
	 * @throws PlatformException 
	 */
	public static GameRoundModel getRoundQuestions(User user, Long gameId, Long roundId) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user is null");
		// TOOD Валидация входных парамтеров, пока не понятно что именно нужно
		
		Game game = Game.findById(gameId);
		if (game == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND,"game not found");
		if (game.getStatus() == GameStatus.WAITING || game.getStatus() == GameStatus.FINISHED)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR,"game is not in STARTED state");
		
		if (game.getRounds().size() == 0)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND,"game rounds are not exists");
		
		// Получаем последий раунд
		GameRound lastGameRound = game.getRounds().get(game.getRounds().size()-1);
		if (lastGameRound.getStatus() == GameRoundStatus.COMPLETED)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR,"game round already completed");
		
		// Получам игрока, жесткий способ но пока пойдет
		Gamer gamer = game.getGamers().get(0).getUser().id == user.id ? game.getGamers().get(0) : game.getGamers().get(1);
		Gamer oponent = gamer.getOponent();
		
		if (gamer.getUser().id != user.id && oponent.getUser().id != user.id)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR,"user are not allowed to check others games");
		
		// Проверяем нужно ли вообще показывать вопросы игроку
		if (gamer.getStatus() != GamerStatus.WAITING_ANSWERS)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR,"gamer should't answer on question");
		
		// Вернуть модель вопросов
		GameRoundModel model = GameRoundModel.buildModel(lastGameRound, gamer, oponent);
				
		return model;
	}

	/**
	 * Метод ведет учет ответов пользователей, если необходимо завершает раунд или игру.
	 * В рамках этого метода генерируется и считается быстрая стратистика + вытавляетяс рейтинг
	 * @param user
	 * @param gameId
	 * @param roundId
	 * @param questionId
	 * @param answerId
	 * @return
	 * @throws PlatformException 
	 */
	public static GamerQuestionAnswerResultModel answerQuestions(User user,
			Long gameId, Long roundId, Long questionId, Long answerId) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user is null");

		// Получаем игру и делаем стандартные проверки
		Game game = Game.findById(gameId);
		if (game == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "game not found");
		if (game.getDeleted())
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game was deleted");
		if (game.getStatus() == GameStatus.WAITING || game.getStatus() == GameStatus.FINISHED)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game is not STARTED state");
		
		// Проверяем игроков
		Gamer gamer = game.getGamers().get(0);
		if (gamer.getUser().id != user.id) {
			gamer = game.getGamers().get(1);
			if (gamer.getUser().id != user.id)
				throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user can't asnwer on foreign questions");
		}
		if (gamer.getStatus() != GamerStatus.WAITING_ANSWERS)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "user can't asnwer on question if your status is not WAITING_ANSWER");
		
		// Опонент
		Gamer oponent = gamer.getOponent();	
		
		// проверяем указанный раунд игры
		GameRound gameRound = GameRound.findById(roundId);
		if (gameRound == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "game round not found");
		if (gameRound.getDeleted())
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game round was deleted");
		if (gameRound.getStatus() == GameRoundStatus.COMPLETED)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game round already completed, you can't answer questions any more");
		if (gameRound.getGame().id != game.id)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game round doesn't belons to selected game");
		
		// Проверяем указанный вопрос раунда
		GameRoundQuestion gameRoundQuestion = GameRoundQuestion.findById(questionId);
		if (gameRoundQuestion == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "game round question was not found");
		if (gameRoundQuestion.getDeleted())
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game round question was deleted");
		if (gameRoundQuestion.getGameRound().id != gameRound.id)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game round question doesn't belons to selected game round");
			
		// Проверка отвечал пользователь или нет на этот вопрос
		if (gameRoundQuestion.getQuestionAnswers() != null)
			for (GameRoundQuestionAnswer questionAnswer : gameRoundQuestion.getQuestionAnswers()) {
				if (questionAnswer.getGamer().id == gamer.id) {
					throw new PlatformException(ErrorCode.VALIDATION_ERROR, "gamer already answered the question");
				}
			}
		
		// Фиксируем ответ игрока
		// Добавляем ответ
		GameRoundQuestionAnswer gamerAnswer = new GameRoundQuestionAnswer();
		gamerAnswer.setGamer(gamer);
		gamerAnswer.setGameRoundQuestion(gameRoundQuestion);
		
		// Проверка на то, что прислали ответ от пользователя который не успел ответить
		if (answerId == -1) {
			gamerAnswer.setAnswer(null);
			gamerAnswer.setIsCorrectAnswer(false);
			gamerAnswer.setIsMissingAnswer(true);
		} else {
			Answer answer = Answer.findById(answerId);
			if (answer == null)
				throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "asnwer not found");
			if (answer.getQuestion().id != gameRoundQuestion.getQuestion().id)
				throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "asnwer doesn't belong to the question");
			
			gamerAnswer.setAnswer(answer);
			gamerAnswer.setIsCorrectAnswer(answer.getCorrect());
			gamerAnswer.setIsMissingAnswer(false);
		}
		
		gamerAnswer.save();
		
		
		if (gameRoundQuestion.getQuestionAnswers() == null)
			gameRoundQuestion.setQuestionAnswers(new ArrayList<GameRoundQuestionAnswer>());
		gameRoundQuestion.getQuestionAnswers().add(gamerAnswer);
		
		// Добавляем очко если правильно ответил на вопрос
		if (gamerAnswer.getIsCorrectAnswer()) {
			gamer.setCorrectAnswerCount(gamer.getCorrectAnswerCount()+1);
			gamer.save();
		}
		
		// Проверяем не конец ли игры или раунда и делаем соотвествующие передвижки
		
		Integer gamerQuestionAnswers = 0;
		Integer oponentQuestionAnswers = 0;
		
		// Обновляем коллекцию
		gameRound.refresh();
		for (GameRoundQuestion gameRoundQuestionObject : gameRound.getQuestions()) {
			for (GameRoundQuestionAnswer gameRoundQuestionAnswer : gameRoundQuestionObject.getQuestionAnswers()) {
				if (gameRoundQuestionAnswer.getGamer().id == gamer.id) {
					gamerQuestionAnswers =gamerQuestionAnswers+1;
				} else {
					oponentQuestionAnswers =oponentQuestionAnswers+1;
				}
			}
		}
		
		Logger.info("Gamer question answers: " + gamerQuestionAnswers);
		Logger.info("Oponent question answers: " + oponentQuestionAnswers);
		
		// Если уже 3 ответа на вопросы
		if (gamerQuestionAnswers == 3) {
			// Если у опонента тоже 3 ответа на вопросы
			if (oponentQuestionAnswers == 3) {
				// Нужно завершать раунд
				gameRound.setStatus(GameRoundStatus.COMPLETED);
				gameRound.save();
				
				if (gameRound.getNumber() == 6) {
					// Последний раунд
					// Завершаем игру, считаем баллы и так далле
					game.setStatus(GameStatus.FINISHED);
					game.setGameFinishedDate(Calendar.getInstance());
					game.save();

					// Считаем очки
					calculateScore(gamer, oponent);
					
					if (gamer.getCorrectAnswerCount() == oponent.getCorrectAnswerCount()) {
						// Ничья
						gamer.setStatus(GamerStatus.DRAW);
						oponent.setStatus(GamerStatus.DRAW);
						
						Logger.info("PUSH " + oponent.getUser().getName() + " вы закончили игру в ничью!");
						NotificationService.sendPushNotificaiton(oponent.getUser(), "Кайдзен", oponent.getUser().getName() + " вы закончили игру в ничью!");
						
					} else {
						if (gamer.getCorrectAnswerCount() > oponent.getCorrectAnswerCount()) {
							// Выиграл текущий игрок
							gamer.setStatus(GamerStatus.WINNER);
							gamer.getUser().save();
							
							// Проиграл опонент
							oponent.setStatus(GamerStatus.LOOSER);
							oponent.getUser().save();

							Logger.info("PUSH " + oponent.getUser().getName() + " вы проиграли игру!");
							NotificationService.sendPushNotificaiton(oponent.getUser(), "Кайдзен", oponent.getUser().getName() + " вы проиграли игру!");
							
						} else {
							// Проиграл текущий игрок
							gamer.setStatus(GamerStatus.LOOSER);
							gamer.getUser().save();
							
							// Выиграл опонент
							oponent.setStatus(GamerStatus.WINNER);
							oponent.getUser().save();

							Logger.info("PUSH " + oponent.getUser().getName() + " вы выиграли игру!");
							NotificationService.sendPushNotificaiton(oponent.getUser(), "Кайдзен", oponent.getUser().getName() + " вы выиграли игру!");
							
						}
					}
					
				} else {
					// Еще есть раунды
					// Если игрок был инициатором раунда, тогда теперь выбирает противник
					if (gamer.id == gameRound.getOwner().id) {
						gamer.setStatus(GamerStatus.WAITING_OPONENT);
						oponent.setStatus(GamerStatus.WAITING_ROUND);
						
						Logger.info("PUSH " + oponent.getUser().getName() + " ваш ход!");
						NotificationService.sendPushNotificaiton(oponent.getUser(), "Кайдзен", oponent.getUser().getName() + " ваш ход!");
						
					} else {
						// Инициатором был опонент теперь наша очередь выбирать
						gamer.setStatus(GamerStatus.WAITING_ROUND);
						oponent.setStatus(GamerStatus.WAITING_OPONENT);
					}
				}
				
				// В любом случае изменются состояния двух игроков
				// Поэтому созранения из каждого условия вынес сюда
				gamer.save();
				oponent.save();
				
			} else {
				// Если противник еще не ответил на вопросы тогда нужно изменить статус и ждать его ответов
				// Пора менять статус на опонента
				gamer.setStatus(GamerStatus.WAITING_OPONENT);
				gamer.save();
				
				oponent.setStatus(GamerStatus.WAITING_ANSWERS);
				Logger.info("PUSH " + oponent.getUser().getName() + " ваш ход!");
				NotificationService.sendPushNotificaiton(oponent.getUser(), "Кайдзен", oponent.getUser().getName() + " ваш ход!");
				oponent.save();
			}
		} else {
			// Если меньше 3х ответов, то пока еще нужно отвечать
		}
		
		GamerQuestionAnswerResultModel model = new GamerQuestionAnswerResultModel();
		model.gameStatus = game.getStatus();
		model.gamerStatus = gamer.getStatus();
		model.gamerScore = gamer.getScore();
		model.gameRoundStatus = gameRound.getStatus();
		
		return model;
	}

	private static void calculateScore(Gamer gamer, Gamer oponent){
		Gamer hiGamer = gamer;
		Gamer lowGamer = oponent;
		if(hiGamer.getUser().getScore()<lowGamer.getUser().getScore()){
			hiGamer = oponent;
			lowGamer = gamer;
		}
		int hiGamerScores = hiGamer.getUser().getScore();
		int lowGamerScores = lowGamer.getUser().getScore();
		int diff = hiGamer.getCorrectAnswerCount()-lowGamer.getCorrectAnswerCount();
		float prop;
		if(hiGamerScores+lowGamerScores==0){
			prop = (float) ((1+hiGamerScores)*1.00/((hiGamerScores+1)+(lowGamerScores+1)));
		}else{
			prop = (float) (hiGamerScores*1.00/(hiGamerScores+lowGamerScores));
		}
		double hiScore =  (diff*(((1+Math.signum(diff))/2)-Math.signum(diff)*prop) + (0.5-prop)*(1-Math.abs(Math.signum(diff))));
		if(hiScore<0){
			hiScore=-Math.ceil(-hiScore);
		}else {
			hiScore =  Math.ceil(hiScore);
		}
		hiGamer.setScore((int) hiScore);
		lowGamer.setScore((int) (-hiScore));
		hiGamer.getUser().setScore(hiGamer.getUser().getScore()+hiGamer.getScore());
		lowGamer.getUser().setScore(lowGamer.getUser().getScore()+lowGamer.getScore());
	}
	
	/**
	 * Медот позволяет пользователям сдаться в игре
	 * @param user 
	 * @param gameId
	 * @return
	 * @throws PlatformException 
	 */
	public static GameModel surrenderGame(User user, Long gameId) throws PlatformException {
		if (user == null)
			throw new PlatformException(ErrorCode.AUTH_ERROR, "user is null");
		if (user.getDeleted())
			throw new PlatformException(ErrorCode.AUTH_ERROR, "user was deleted");
		
		// Проверяем игру
		Game game = Game.findById(gameId);
		if (game == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "game not found");
		if (game.getDeleted())
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "game was deleted");
		
		// Получаем список игроков
		Gamer gamer = null;
		Gamer oponent = null;
		for (Gamer gamerObject : game.getGamers()) {
			if (gamerObject.getUser().id == user.id) {
				gamer = gamerObject;
				oponent = gamer.getOponent();
			}
		}
		// TODO Завершить игру
		game.setStatus(GameStatus.FINISHED);
		game.setGameFinishedDate(Calendar.getInstance());
		
		for (GameRound gameRound : game.getRounds()) {
			if (gameRound.getStatus() == GameRoundStatus.WAITING_ANSWER) {
				gameRound.setStatus(GameRoundStatus.COMPLETED);
				gameRound.save();
			}
			
		}
		
		gamer.setStatus(GamerStatus.SURRENDED);
		// TODO Calculate score
		gamer.setScore(0);
		gamer.getUser().setScore(gamer.getScore());
		gamer.getUser().save();
		
		oponent.setStatus(GamerStatus.OPONENT_SURRENDED);
		// TODO Calculate score
		oponent.setScore(18);
		oponent.getUser().setScore(gamer.getScore());
		oponent.getUser().save();
		
		gamer.save();
		oponent.save();
		
		game.save();
		
		Logger.info("PUSH " + oponent.getUser().getName() + " ваш противник сдался!");
		NotificationService.sendPushNotificaiton(oponent.getUser(), "Кайдзен", oponent.getUser().getName() + " ваш противник сдался!");
		
		// Строим модель игры
		GameModel model = GameModel.buildModel(game, gamer, oponent, null);  
		return model;
	}

	/**
	 * Метод выполняет поиск просроченных игр и завершает их с отправкой соотвествующего уведомления
	 * @return
	 */
	public static int findAndFinishExpiredGames() {
		// Интересующие статусы
		List<GamerStatus> statuses = new ArrayList<GamerStatus>();
		statuses.add(GamerStatus.WAITING_ANSWERS);
		statuses.add(GamerStatus.WAITING_ROUND);
		
		// Интересующее время
		Calendar expirationDate = Calendar.getInstance();
		expirationDate.add(Calendar.HOUR, -48);

		// Получения списка просроченных игр
		List<Gamer> expiredGamers = JPA.em().createQuery("from Gamer where status in (:statuses) and lastUpdateStatusDate < :expiredDate and deleted = false")
				.setParameter("statuses", statuses)
				.setParameter("expiredDate", expirationDate)
				.getResultList();
		if (expiredGamers.size() > 0) {
			 for (Gamer gamer : expiredGamers) {
				 try {
					surrenderGame(gamer.getUser(),gamer.getGame().id);
				} catch (PlatformException e) {
					Logger.error(e, "Can't complete expired game");
				}
			}
		}
		
		return expiredGamers.size();
	}

	/**
	 * Метод проверяет и удаляет просроченные приглашения
	 * 
	 * @return
	 */
	public static int findAndRemoveExpiredInvitations() {
		List<GamerStatus> statuses = new ArrayList<GamerStatus>();
		statuses.add(GamerStatus.WAITING_OWN_DECISION);
		
		// Интересующее время
		Calendar expirationDate = Calendar.getInstance();
		expirationDate.add(Calendar.HOUR, -24);

		// Получения списка просроченных игр
		List<Gamer> expiredInvitations = JPA.em().createQuery("from Gamer where status in (:statuses) and lastUpdateStatusDate < :expiredDate and deleted = false")
				.setParameter("statuses", statuses)
				.setParameter("expiredDate", expirationDate)
				.getResultList();
		if (expiredInvitations.size() > 0) {
			 for (Gamer gamer : expiredInvitations) {
				 try {
					removeExpiredInvitation(gamer);
				} catch (Throwable e) {
					Logger.error(e, "Can't delete expired invitation");
				}
			}
		}
		
		return expiredInvitations.size();
	}
	
	/**
	 * Удалает приглашение играть
	 * @param gamer
	 */
	public static void removeExpiredInvitation(Gamer gamer) {
		Game game = gamer.getGame();
		Gamer oponent = gamer.getOponent();
		
		gamer.setDeleted(true);
		gamer.save();
		oponent.setDeleted(true);
		oponent.save();
		game.setDeleted(true);
		game.save();
		
		Logger.info("PUSH " + gamer.getUser().getName() + " так и не принял ваше приглашение!");
		NotificationService.sendPushNotificaiton(oponent.getUser(), "Кайдзен", gamer.getUser().getName() + " так и не принял ваше приглашение!");
	}


}
