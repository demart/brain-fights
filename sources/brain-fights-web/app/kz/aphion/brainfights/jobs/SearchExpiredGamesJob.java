package kz.aphion.brainfights.jobs;

import kz.aphion.brainfights.services.GameService;
import play.Logger;
import play.jobs.Every;
import play.jobs.Job;


/**
 * Таймер для поиска просроченных игр, которые необходимо принудительно завершить
 * 
 * @author artem.demidovich
 *
 */
@Every("10min")
public class SearchExpiredGamesJob extends Job {

	/**
	 * Запуск процесса поиска игр
	 */
	public void doJob() {
		Logger.info("Search expired games started");
		
		int expiredGamesCount = GameService.findAndFinishExpiredGames();
		
		Logger.info("Search expired games finished. Finished: " + expiredGamesCount);
	}
}