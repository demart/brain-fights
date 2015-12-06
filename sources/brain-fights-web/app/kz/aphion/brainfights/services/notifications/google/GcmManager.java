package kz.aphion.brainfights.services.notifications.google;

import java.io.IOException;
import java.util.concurrent.LinkedBlockingQueue;

import play.Logger;

public class GcmManager {

	private GcmManager() {}
	private static GcmManager _instance;
	
	private Sender sender;
	private LinkedBlockingQueue<GcmMessage> queue;
	
	private Thread dispatchThread;
	private boolean dispatchThreadShouldContinue;
	
	private final static String GCM_API_KEY = "AIzaSyC3smEC8Kw2iURZnk5y2Zk01EDC2XORwJM";
	private final static String GCM_SENDER_ID = "15700834773";
	private final static int RETRY_COUNT = 3; 
	
	public static GcmManager getInstance() {
		if (_instance == null) {
			_instance = new GcmManager();
			
		}
		return _instance;
	}
	
	public void startService(){
		if (queue == null)
			_instance.queue = new LinkedBlockingQueue();
		
		this.sender = new Sender(GCM_API_KEY);
		
		this.dispatchThreadShouldContinue = true;
		this.dispatchThread = createDispatchThread();
		this.dispatchThread.start();
	}
	
	public void stopService() {
		this.dispatchThreadShouldContinue = false;
	}
	
	public void sendNotification(String deviceToken, String title, String message){
		Notification notification = new Notification.Builder("@drawable/ttk_logo").title(title).body(message).build();
		Message pushMessage = new Message.Builder().notification(notification).build();
		GcmMessage gcmMessage = new GcmMessage(deviceToken, pushMessage);
		try {
			queue.put(gcmMessage);
			Logger.info("Google notification sent");
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
	}
	
	
	protected Thread createDispatchThread() {
		return new Thread(new Runnable() {
			@Override
			public void run() {
				while (dispatchThreadShouldContinue) {
					try {
						GcmMessage message = queue.take();
						
						Result result = sender.send(message.getMessage(), message.getDeviceToken(), RETRY_COUNT);
						if (result.getErrorCodeName() == null || "".equals(result.getErrorCodeName())) {
		                    System.out.println(message.toString() + "GCM Notification is sent successfully" + result.toString());
		                } else {
		                	System.out.println("Error occurred while sending push notification :" + result.getErrorCodeName());
		                }
					} catch (InterruptedException | IOException e) {
						Logger.error("Error sending push to google, ex: " + e.getMessage());
						continue;
					}
				}
			}

		});
	}
	
	
}
