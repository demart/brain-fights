package kz.aphion.brainfights.jobs;

import kz.aphion.brainfights.services.DepartmentService;
import play.Logger;
import play.jobs.Job;
import play.jobs.On;

/**
 *  Таймер для запуска обновления статистики по департаментам. Каждый час.
 * @author artem.demidovich
 *
 */
@On("0 0 0,1,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 * * ? *") // Каждый час кроме ночи, там у нас обновление LDAP
public class UpdateDepartmentStatisticsJob extends Job {

	/**
	 * Запускает пересчет статистики
	 */
	public void doJob() {
		Logger.info("Update Department statistics syncrhonization started");
		
		// Процесс пересчета рейтинга 
		try {
			Logger.info("AUpdate Department Statistics started");
			DepartmentService.updateDepartmentStatistics();
			Logger.info("Update Department Statistics completed successfully");
		} catch (Throwable e) {
			Logger.error(e, "Update Department Statistics failed");
		}
		
		Logger.info("Update Department statistics syncrhonization finished");
	}
	
}
