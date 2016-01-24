package kz.aphion.groupbridge.brainfights.controllers;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;

import kz.aphion.groupbridge.brainfights.MainActivity;
import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;

/**
 * Created by alimjan on 06.11.2015.
 */
public class SplashActivity extends AppCompatActivity implements RestTask.RestTaskCallback {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        CurrentUser.init(this);
        CurrentUser currentUser = CurrentUser.getInstance();

        if(currentUser==null){
            StartLoginActivity();
        }else if(currentUser.getAuthToken()==null){
            StartLoginActivity();
        }else{
            login();
        }
    }
    private void StartLoginActivity(){
        Intent intent = new Intent(this, LoginActivity.class);
        intent.setFlags(intent.getFlags()|Intent.FLAG_ACTIVITY_NO_HISTORY);
        startActivity(intent);
        finish();
    }
    private void login(){
        CurrentUser currentUser = CurrentUser.getInstance();
        if(currentUser!=null) {
            RestTask restTask = new RestTask(getApplicationContext(), this);
            RestTaskParams params = new RestTaskParams(RestTask.TaskType.GET_CURRENT_USER_PROFILE);
            params.authToken = currentUser.getAuthToken();
            restTask.execute(params);
        }else {
            StartLoginActivity();
        }
    }

    @Override
    public void onBackPressed() {
        // Disable going back to the MainActivity
        moveTaskToBack(true);
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if (taskResult!=null&&taskResult.getTaskType() == RestTask.TaskType.GET_CURRENT_USER_PROFILE) {
            if (taskResult.getTaskStatus() == RestTask.TaskStatus.SUCCESS) {
                StatusSingle<UserProfile> response = (StatusSingle<UserProfile>) taskResult.getResponseData();
                if (response.getStatus() == ResponseStatus.SUCCESS) {
//                    try {
//                        Thread.sleep(30000);
//                    } catch (InterruptedException e) {
//                        e.printStackTrace();
//                    }
                    MainActivity.StartMainActivity(this);
                } else {
                    StartLoginActivity();
                }
            } else {
                StartLoginActivity();
            }
        }
    }
}
