package kz.aphion.groupbridge.brainfights.controllers;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import kz.aphion.groupbridge.brainfights.MainActivity;
import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.*;
import kz.aphion.groupbridge.brainfights.models.Status;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.utils.Util;

import static kz.aphion.groupbridge.brainfights.tasks.RestTask.*;
import static kz.aphion.groupbridge.brainfights.tasks.RestTask.TaskType.*;

/**
 * Created by alimjan on 03.11.2015.
 */
public class LoginActivity extends AppCompatActivity implements RestTaskCallback {

    Button mLoginButton;
    EditText mEmailText;
    EditText mPasswordText;
    ProgressDialog progressDialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);
        mLoginButton = (Button) findViewById(R.id.btn_login);
        mEmailText = (EditText) findViewById(R.id.input_email);
        CurrentUser currentUser = CurrentUser.getInstance();
        if(currentUser!=null&&currentUser.getLogin()!=null){
            mEmailText.setText(currentUser.getLogin());
        }
        mPasswordText = (EditText) findViewById(R.id.input_password);
        mLoginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                login();
            }
        });

    }
    public void login() {
        if (!validate()) {
            onLoginFailed();
            return;
        }

        mLoginButton.setEnabled(false);

        progressDialog = new ProgressDialog(LoginActivity.this,
                R.style.AppTheme_Dark_Dialog);
        progressDialog.setIndeterminate(true);
        progressDialog.setMessage("Авторизация...");
        progressDialog.show();

//        RestTask restTask2 = new RestTask(this);
//        RestTaskParams params = new RestTaskParams(GET_GAME_INFORMATION);
//        params.authToken = "e64b5858-b735-4df9-8719-08f8d5d031b3";
//        params.gameId= Long.valueOf(23);
//        restTask2.execute(params);

        new Thread(new Runnable() {
            @Override
            public void run() {
                String email = mEmailText.getText().toString();
                String password = mPasswordText.getText().toString();
                RestTask task = new RestTask(LoginActivity.this.getApplicationContext(), LoginActivity.this);
                RestTaskParams taskParams = new RestTaskParams(AUTHENTICATE);
                AuthorizationRequestModel authorizationRequest = new AuthorizationRequestModel();
                authorizationRequest.appVersion = Util.getAppVersion(getApplicationContext());
                authorizationRequest.deviceOsVersion = android.os.Build.VERSION.RELEASE;
                authorizationRequest.deviceType = DeviceType.ANDROID;
                authorizationRequest.devicePushToken = CurrentUser.getInstance().getPushToken();
                authorizationRequest.login = email;
                authorizationRequest.password = password;
                taskParams.authorizationRequest = authorizationRequest;
                task.execute(taskParams);
            }
        }).start();

        // TODO: Implement your own authentication logic here.


    }


    @Override
    public void onBackPressed() {
        // Disable going back to the MainActivity
        moveTaskToBack(true);
    }
    public void onLoginSuccess() {
        mLoginButton.setEnabled(true);
        MainActivity.StartMainActivity(this);
    }
    public void onLoginFailed() {
        Toast.makeText(getBaseContext(), "Не удалось войти", Toast.LENGTH_LONG).show();

        mLoginButton.setEnabled(true);
    }
    public boolean validate() {
        boolean valid = true;

        String email = mEmailText.getText().toString();
        String password = mPasswordText.getText().toString();

        if (email.isEmpty() /*|| !android.util.Patterns.EMAIL_ADDRESS.matcher(email).matches()*/) {
            mEmailText.setError("Введите правильный логин");
            valid = false;
        } else {
            mEmailText.setError(null);
        }

        if (password.isEmpty() /*|| password.length() < 4 || password.length() > 10*/) {
            mPasswordText.setError("Введите пароль");
            valid = false;
        } else {
            mPasswordText.setError(null);
        }
//        mEmailText.setError(null);
        return valid;
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType()==TaskType.AUTHENTICATE) {
        if(taskResult.getTaskStatus()==TaskStatus.SUCCESS){
            StatusSingle<AuthorizationResponseModel> response =
                    (StatusSingle<AuthorizationResponseModel>) taskResult.getResponseData();
            if(response.getStatus()==ResponseStatus.SUCCESS){
                new android.os.Handler().postDelayed(
                        new Runnable() {
                            public void run() {
                                // On complete call either onLoginSuccess or onLoginFailed
                                onLoginSuccess();
                                // onLoginFailed();
                                progressDialog.dismiss();
                            }
                        }, 0);
            } else{
                new android.os.Handler().postDelayed(
                        new Runnable() {
                            public void run() {
                                // On complete call either onLoginSuccess or onLoginFailed
                                onLoginFailed();
                                // onLoginFailed();
                                progressDialog.dismiss();
                            }
                        }, 0);
            }
        }else{
            new android.os.Handler().postDelayed(
                    new Runnable() {
                        public void run() {
                            // On complete call either onLoginSuccess or onLoginFailed
                            onLoginFailed();
                            // onLoginFailed();
                            progressDialog.dismiss();
                        }
                    }, 0);
        }

//            taskResult.getTaskStatus();
        }
    }
}
