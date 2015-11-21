package kz.aphion.brainfights.jobs;

import kz.aphion.brainfights.services.notifications.apple.APNSManager;
import kz.aphion.brainfights.services.notifications.google.GcmManager;
import play.jobs.Job;
import play.jobs.OnApplicationStop;

@OnApplicationStop
public class StopNotificationServicesJob extends Job {

	@Override
	public void doJob() throws Exception {
		// Stop Apple notification manager
		APNSManager.getInstance().stopService();
				
		// Stop Google notification manager
		GcmManager.getInstance().stopService();
	}
	
}
