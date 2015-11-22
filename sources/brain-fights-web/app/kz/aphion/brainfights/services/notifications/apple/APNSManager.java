package kz.aphion.brainfights.services.notifications.apple;

import java.io.IOException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.CertificateException;

import play.Logger;

import com.relayrides.pushy.apns.ApnsEnvironment;
import com.relayrides.pushy.apns.PushManager;
import com.relayrides.pushy.apns.PushManagerConfiguration;
import com.relayrides.pushy.apns.util.ApnsPayloadBuilder;
import com.relayrides.pushy.apns.util.MalformedTokenStringException;
import com.relayrides.pushy.apns.util.SSLContextUtil;
import com.relayrides.pushy.apns.util.SimpleApnsPushNotification;
import com.relayrides.pushy.apns.util.TokenUtil;


/**
 * Класс менеджер для работы с PUSH уведомлений на iOS
 * 
 * @author artem.demidovich
 *
 */
public class APNSManager {

	private static APNSManager _instance;
	private APNSManager() {}
	
	private static PushManager<SimpleApnsPushNotification> pushManager;
	
	public static APNSManager getInstance() {
		if (_instance == null)
			_instance = new APNSManager();
		return _instance;
	}
	
	public void startService() {
		if (pushManager == null) {
			try {
				pushManager =
						new PushManager<SimpleApnsPushNotification>(
						        ApnsEnvironment.getSandboxEnvironment(),
						        SSLContextUtil.createDefaultSSLContext("BrainFightsPushDev.p12", "lepon&7&"),
						        null, // Optional: custom event loop group
						        null, // Optional: custom ExecutorService for calling listeners
						        null, // Optional: custom BlockingQueue implementation
						        new PushManagerConfiguration(),
						        "BrainFightsPushManager");
				
				pushManager.registerRejectedNotificationListener(new MyRejectedNotificationListener());
				pushManager.registerFailedConnectionListener(new MyFailedConnectionListener());
				pushManager.start();
				
			} catch (UnrecoverableKeyException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (KeyManagementException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (KeyStoreException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (NoSuchAlgorithmException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (CertificateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
	}
	
	public void stopService() {
		if (pushManager != null)
			try {
				if (!pushManager.isShutDown()) {
					pushManager.shutdown();
				}
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}
	
	/**
	 * Отправляет пуш уведомление указанному адресату
	 * 
	 * @param deviceToken
	 * @param title
	 * @param message
	 */
	public void sendNotification(String deviceToken, String title, String message){
		try {
			byte[] token = TokenUtil.tokenStringToByteArray(deviceToken);
			ApnsPayloadBuilder payloadBuilder = new ApnsPayloadBuilder();
			payloadBuilder.setAlertTitle(title);
			payloadBuilder.setAlertBody(message); 
			payloadBuilder.setSoundFileName("ring-ring.aiff");
			// payloadBuilder.addCustomProperty("g", ); GamerId
			String payload = payloadBuilder.buildWithDefaultMaximumLength();
			Logger.info(payload);
			SimpleApnsPushNotification notif = new SimpleApnsPushNotification(token, payload);
			pushManager.getQueue().put(notif);
			
			Logger.info("Apple notification sent");
		} catch (MalformedTokenStringException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
}
