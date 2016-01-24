package kz.aphion.groupbridge.brainfights.controllers;


import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserGameModel;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.models.UserType;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.stores.CurrentUserProfile;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskUtil;

/**
 * Created by alimjan on 04.12.2015.
 */
public class UserProfileFragment extends Fragment implements RestTask.RestTaskCallback {
    View v;
    UserProfile profile;
    Button btnFriend;
    Button btnGame;
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_user_profile, container, false);
        setMenuProfileInfo();
        setButtons();
        return v;
    }

    private void setButtons() {
        btnFriend = (Button) v.findViewById(R.id.user_profile_friend_button);
        if (!profile.getType().equals(UserType.FRIEND)) {
            btnFriend.setText("Добавить в друзья");
        } else {
            btnFriend.setText("Удалить из друзей");
        }
        btnFriend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setFriendlyStatus();
            }
        });
        btnGame = (Button) v.findViewById(R.id.user_profile_game_button);
        btnGame.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                RestTaskUtil.createInvitation(getContext(), UserProfileFragment.this, profile.getId());
            }
        });
        if(profile.getType().equals(UserType.ME)){
            btnGame.setVisibility(View.GONE);
            btnFriend.setVisibility(View.GONE);
        }
    }
    private void setFriendlyStatus() {
        if(profile!=null&&profile.getType()!=null){
            RestTask task = new RestTask(getContext(),this);
            RestTaskParams params;
            if(profile.getType().equals(UserType.FRIEND)){
                params = new RestTaskParams(RestTask.TaskType.REMOVE_FRIEND);
            }else{
                params = new RestTaskParams(RestTask.TaskType.ADD_FRIEND);
            }
            params.userId = profile.id;
            params.authToken = CurrentUser.getInstance().getAuthToken();
            task.execute(params);
        }
    }

    private void setMenuProfileInfo(){
        if(profile==null)
            profile = CurrentUserProfile.getInstance();
        if(profile!=null){
            try {
                ((TextView) this.v.findViewById(R.id.menu_profile_rating)).setText("Рейтинг: "+Integer.toString(profile.getScore()));
                ((TextView) v.findViewById(R.id.menu_profile_game_position)).setText("Место: "+Integer.toString(profile.getGamePosition()));
                ((TextView) v.findViewById(R.id.menu_profile_position)).setText(profile.getPosition());
                ((TextView) v.findViewById(R.id.menu_profile_department)).setText(profile.getDepartment().name);
                ((TextView) v.findViewById(R.id.menu_profile_name)).setText(profile.getName());
                ((TextView) v.findViewById(R.id.menu_profile_won)).setText(Integer.toString(profile.getWonGames()));
                ((TextView) v.findViewById(R.id.menu_profile_draw)).setText(Integer.toString(profile.getDrawnGames()));
                ((TextView) v.findViewById(R.id.menu_profile_lose)).setText(Integer.toString(profile.getLoosingGames()));
            }catch (Exception e){
                System.out.println(e.getMessage());
                e.printStackTrace();
            }
        }
    }
    public static void startUserProfileFragment(FragmentActivity activity, UserProfile user){
        UserProfileFragment2 fragment = new UserProfileFragment2();
        fragment.profile = user;
        FragmentManager fragmentManager = activity.getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .add(R.id.flContent, fragment)
                .addToBackStack(null)
                .commit();

    }
    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType().equals(RestTask.TaskType.ADD_FRIEND)) {
            if (taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)) {
                StatusSingle<GameModel> response = (StatusSingle<GameModel>) taskResult.getResponseData();
                if (response.getStatus().equals(ResponseStatus.SUCCESS)) {
                    Toast.makeText(getActivity().getApplicationContext(),
                            "Пользователь " + profile.getName() + " добавлен в друзья", Toast.LENGTH_LONG).show();
                    btnFriend.setText("Удалить из друзей");
                }
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.REMOVE_FRIEND)){
            if (taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)) {
                StatusSingle<GameModel> response = (StatusSingle<GameModel>) taskResult.getResponseData();
                if (response.getStatus().equals(ResponseStatus.SUCCESS)) {

                    Toast.makeText(getActivity().getApplicationContext(),
                            "Пользователь "+profile.getName()+" удален из друзей", Toast.LENGTH_LONG).show();
                    btnFriend.setText("Добавить в друзья");
                }
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.CREATE_INVITATION)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                StatusSingle<UserGameModel> response = (StatusSingle<UserGameModel>) taskResult.getResponseData();
                if(response.getStatus().equals(ResponseStatus.SUCCESS)) {
                    getActivity().getSupportFragmentManager().popBackStack("GameList", FragmentManager.POP_BACK_STACK_INCLUSIVE);
                    GamesListsFragment.UpdateGameList(getActivity().getSupportFragmentManager());
                }
                else{
                    Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                            response.getErrorMessage(), Toast.LENGTH_LONG);
                    toast.show();
                }
            }
        }
    }
}
