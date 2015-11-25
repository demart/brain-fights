package kz.aphion.brainfights.jobs;

import kz.aphion.brainfights.services.notifications.apple.APNSManager;
import kz.aphion.brainfights.services.notifications.google.GcmManager;
import play.jobs.Job;
import play.jobs.OnApplicationStart;

/**
 * Служба запускает службы отправки PUSH уведомлений
 * 
 * @author artem.demidovich
 *
 */
@OnApplicationStart(async=true)
public class StartNotificationServicesJob extends Job {

	@Override
	public void doJob() throws Exception {
		// Run Apple notification manager
		APNSManager.getInstance().startService();
		
		// Run Google notification manager
		GcmManager.getInstance().startService();
	}
}