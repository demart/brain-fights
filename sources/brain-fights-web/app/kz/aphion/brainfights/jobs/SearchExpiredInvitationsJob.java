package kz.aphion.brainfights.jobs;

import kz.aphion.brainfights.services.GameService;
import play.Logger;
import play.jobs.Every;
import play.jobs.Job;

/**
 * Таймер запускает проверку на наличие просроченных приглашений сыграть, и если таковые имеются то закрывает их
 * 
 * @author artem.demidovich
 */
@Every("15s")
public class SearchExpiredInvitationsJob extends Job {

	/**
	 * Запуск процесса поиска игр
	 */
	public void doJob() {
		Logger.info("Search expired game invitatioins started");
		
		int expiredInvitationsCount = GameService.findAndRemoveExpiredInvitations();
		
		Logger.info("Search expired game invitatioins finished. Finished: " + expiredInvitationsCount);
	}
	
}
