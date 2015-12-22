package kz.aphion.groupbridge.brainfights.push;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;

import com.google.android.gms.gcm.GcmReceiver;

/**
 * Created by alimjan on 04.12.2015.
 */
public class BFGcmReceiver extends GcmReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        //super.onReceive(context, intent);
        ComponentName comp = new ComponentName(context.getPackageName(),
                BFGcmIntentService.class.getName());
        startWakefulService(context, (intent.setComponent(comp)));
        setResultCode(Activity.RESULT_OK);
    }
}
