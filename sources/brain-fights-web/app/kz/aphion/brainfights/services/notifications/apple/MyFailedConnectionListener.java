package kz.aphion.brainfights.services.notifications.apple;

import javax.net.ssl.SSLHandshakeException;

import com.relayrides.pushy.apns.FailedConnectionListener;
import com.relayrides.pushy.apns.PushManager;
import com.relayrides.pushy.apns.util.SimpleApnsPushNotification;

public class MyFailedConnectionListener implements FailedConnectionListener<SimpleApnsPushNotification>{

    @Override
    public void handleFailedConnection(
            final PushManager<? extends SimpleApnsPushNotification> pushManager,
            final Throwable cause) {

        if (cause instanceof SSLHandshakeException) {
            // This is probably a permanent failure, and we should shut down
            // the PushManager.
        }
    }
}
