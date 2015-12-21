package kz.aphion.groupbridge.brainfights.stores;


import android.content.Context;
import android.content.SharedPreferences;

import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.iid.InstanceID;

import java.io.IOException;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.utils.Const;

/**
 * Created by alimjan on 06.11.2015.
 */
public class CurrentUser {
    private static final String USER_AUTH_TOKEN_PREFERENCE = "AUTH_TOKEN_PREFERENCE";
    private static final String USER_LOGIN_PREFERENCE = "USER_LOGIN_PREFERENCE";

    private CurrentUser(){

    }
    private CurrentUser(Context context){
        this.context = context;
    }
    static CurrentUser instance;
    public static void init(Context context){
//        SharedPreferences sharedpreferences = context.getSharedPreferences(Const.APP_SHAREDPREFERENS,Context.MODE_PRIVATE);
        instance = new CurrentUser(context);

    }
    public static CurrentUser getInstance(){
        return instance;
    }
    private String authToken = null;
    private String login = null;
    private String pushToken = null;

    private SharedPreferences sharedPreferences;
    private Context context;

    private SharedPreferences getSharedPreferences(){
        if(sharedPreferences==null){
            sharedPreferences = context.getSharedPreferences(Const.APP_SHAREDPREFERENS, Context.MODE_PRIVATE);
        }
        return sharedPreferences;
    }

    public String getAuthToken() {
        if(authToken==null&&getSharedPreferences().contains(USER_AUTH_TOKEN_PREFERENCE)){
            authToken = getSharedPreferences().getString(USER_AUTH_TOKEN_PREFERENCE, null);
        }
        return authToken;
    }

    public String getPushToken() {
        if(pushToken==null){
            InstanceID instanceID = InstanceID.getInstance(context);
            try {
                pushToken = instanceID.getToken(context.getString(R.string.gcm_defaultSenderId), GoogleCloudMessaging.INSTANCE_ID_SCOPE, null);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return pushToken;
    }

    public void setAuthToken(String authToken) {
        editPreference(USER_AUTH_TOKEN_PREFERENCE, authToken);
        this.authToken = authToken;
    }

    public String getLogin() {
        if(login==null&&getSharedPreferences().contains(USER_LOGIN_PREFERENCE)){
            login = getSharedPreferences().getString(USER_LOGIN_PREFERENCE,"");
        }
        return login;
    }

    public void setLogin(String login) {
        editPreference(USER_LOGIN_PREFERENCE, login);
        this.login = login;
    }
    private void editPreference(String field,String value){
        SharedPreferences.Editor editor = getSharedPreferences().edit();
        editor.putString(field, value);
        editor.commit();
    }
    private void removePreference(String field){
        if(getSharedPreferences().contains(field)){
            SharedPreferences.Editor editor = getSharedPreferences().edit();
            editor.remove(field);
            editor.commit();
        }
    }
    public void removeAuthToken(){
        removePreference(USER_AUTH_TOKEN_PREFERENCE);
    }
}
