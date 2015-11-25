package kz.aphion.brainfights.jobs;

import javax.naming.NamingException;

import kz.aphion.brainfights.services.ADService;
import kz.aphion.brainfights.services.DepartmentService;
import play.Logger;
import play.db.jpa.JPA;
import play.jobs.Job;
import play.jobs.On;
import play.jobs.OnApplicationStart;

/**
 * 
 * Таймер для запуска синхронизации всей организационной структуры с обновлением рейтинга подразделений
 * @author artem.demidovich
 *
 */
//@On("0 0 4 1/1 * ? *") // Every day at 4am (morning)
@OnApplicationStart
public class OrganizationStructureSynchronizationJob extends Job {

	/**
	 * Запуск синхрнизации
	 */
	public void doJob() {
		Logger.info("Organization Structure syncrhonization started");
		
		
		// Процесс синхронизации с Active Directory
		try {
			Logger.info("Active Directory synchronization started");
			ADService.updateAllFromLdap();
			Logger.info("Active Directory synchronization completed successfully");
		} catch (NamingException e) {
			Logger.error(e, "Active Directory synchronization failed");
		}
		
		JPA.em().flush();
		
		// Процесс пересчета рейтинга 
		try {
			Logger.info("AUpdate Department Statistics started");
			DepartmentService.updateDepartmentStatistics();
			Logger.info("Update Department Statistics completed successfully");
		} catch (Throwable e) {
			Logger.error(e, "Update Department Statistics failed");
		}
		
		Logger.info("Organization Structure syncrhonization finished");
	}

	
}
