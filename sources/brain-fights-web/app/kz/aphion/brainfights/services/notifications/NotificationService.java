package kz.aphion.brainfights.services.notifications;

import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

import kz.aphion.brainfights.persistents.DeviceType;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.notifications.apple.APNSManager;
import kz.aphion.brainfights.services.notifications.google.GcmManager;

/**
 * Сервис класс для отправки PUSH уведомлений (возможно еще и email)
 * @author artem.demidovich
 *
 */
public class NotificationService {
	
	/**
	 * Метод отправялет в очередь отправки уведомлений
	 * @param user 
	 * @param title
	 * @param message
	 */
	public static void sendPushNotificaiton(User user, String title, String message) {
		if (user.getDevicePushToken() == null || "".equals(user.getDevicePushToken()))
			return;
		if (user.getDeviceType() == DeviceType.ANDROID) {
			sendGoogleNotification(user, title, message);
		}
		
		if (user.getDeviceType() == DeviceType.IOS) {
			sendAppleNotification(user, title, message);
		}
	}
	
	private static void sendAppleNotification(User user, String title, String message) {
		APNSManager.getInstance().sendNotification(user.getDevicePushToken(), title, message);
	}
	
	private static void sendGoogleNotification(User user, String title, String message) {
		GcmManager.getInstance().sendNotification(user.getDevicePushToken(), title, message);
	}
	
}
