package kz.aphion.brainfights.services.notifications.apple;

import com.relayrides.pushy.apns.PushManager;
import com.relayrides.pushy.apns.RejectedNotificationListener;
import com.relayrides.pushy.apns.RejectedNotificationReason;
import com.relayrides.pushy.apns.util.SimpleApnsPushNotification;

public class MyRejectedNotificationListener implements RejectedNotificationListener<SimpleApnsPushNotification> {

	@Override
    public void handleRejectedNotification(
            final PushManager<? extends SimpleApnsPushNotification> pushManager,
            final SimpleApnsPushNotification notification,
            final RejectedNotificationReason reason) {

        System.out.format("%s was rejected with rejection reason %s\n", notification, reason);
    }
}
