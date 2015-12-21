package kz.aphion.groupbridge.brainfights.stores;

import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;

import kz.aphion.groupbridge.brainfights.models.Department;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.utils.Const;

/**
 * Created by alimjan on 06.11.2015.
 */
public class CurrentUserProfile {
    private CurrentUserProfile(){

    }
    private static UserProfile currentUserProfile;
    public static void init(UserProfile userProfile, Context context){
        currentUserProfile = userProfile;
        SendUserUpdatedBroadcastMessage(context);
    }
    public static UserProfile getInstance(){
        return currentUserProfile;
    }
    private static void SendUserUpdatedBroadcastMessage(Context context){
        Intent intent = new Intent();
        intent.setAction(Const.BM_USER_PROFILE_UPDATE);
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
    }
}
