package kz.aphion.groupbridge.brainfights.controllers;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentManager;
import android.support.v7.widget.CardView;
import android.util.TypedValue;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.text.ParseException;
import java.util.ArrayList;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.Department;
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
import kz.aphion.groupbridge.brainfights.utils.UserProfileUtil;

/**
 * Created by alimjan on 18.12.2015.
 */
public class UserProfileFragment2 extends Fragment implements RestTask.RestTaskCallback {
    View v;
    UserProfile profile;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_user_profile2,container,false);
        if(profile==null)
            profile = CurrentUserProfile.getInstance();
        try {
            UserProfileUtil.setUserProfileUpData(profile, v, getContext());
        } catch (ParseException e) {
            Toast.makeText(getContext(), "Ошибка отображения данных пользователя: "+e.getMessage(), Toast.LENGTH_LONG);
        }

        setScores();
        setButtons();
        setOrgStructure();
        return v;
    }
    private void setOrgStructure(){
        Department root = profile.getDepartment();
        ArrayList<Department> deps = new ArrayList<>();
        deps.add(root);
        while(root.parent!=null){
            root = root.parent;
            deps.add(root);
        }
        LinearLayout layout = (LinearLayout) v.findViewById(R.id.orgstruct_layout);
        LayoutInflater inflater =
                (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        RelativeLayout root_layer = (RelativeLayout) inflater.inflate(R.layout.layout_orgstuct_userprofile,null);
        layout.addView(setDataToOrgStructLayer("Транстелеком", root_layer, false, false, 0));
        setOrgStructureRowHeight(root_layer);
//        root_layer = (RelativeLayout) inflater.inflate(R.layout.layout_orgstuct_userprofile,null);
        int margin=0;
//        layout.addView(setDataToOrgStructLayer(root.name, root_layer, true, root==profile.department, margin));
        for(int i=deps.size();i>0;i--){
            margin=margin+25;
            root_layer = (RelativeLayout) inflater.inflate(R.layout.layout_orgstuct_userprofile,null);
            layout.addView(setDataToOrgStructLayer(deps.get(i-1).name, root_layer, true, deps.get(i-1)==profile.department, margin));
            setOrgStructureRowHeight(root_layer);
        }
//        while (root.children!=null&&root.children.size()!=0){
//            root = root.children.get(0);
//            margin=margin+10;
//            root_layer = (RelativeLayout) inflater.inflate(R.layout.layout_orgstuct_userprofile,null);
//            layout.addView(setDataToOrgStructLayer(root.name, root_layer, true, root==profile.department, margin));
//        }
    }
    private void setOrgStructureRowHeight(RelativeLayout layout){
        int height = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, 30, getResources().getDisplayMetrics());
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) layout.getLayoutParams();
        layoutParams.height = height;
        layout.setLayoutParams(layoutParams);
    }
    private View setDataToOrgStructLayer(String name, View v, boolean isDownRightArrowVisible, boolean isLeftArrowVisible, int marginLeft){
        TextView nameView = (TextView) v.findViewById(R.id.name);
        nameView.setText(name);
        ImageView downRightArrowView = (ImageView) v.findViewById(R.id.down_right);
        ImageView leftArrowView = (ImageView) v.findViewById(R.id.left_arrow);
        if(isDownRightArrowVisible)downRightArrowView.setAlpha(Float.valueOf(1));
        else downRightArrowView.setAlpha(Float.valueOf(0));
        if(isLeftArrowVisible) leftArrowView.setAlpha(Float.valueOf(1));
        else leftArrowView.setAlpha(Float.valueOf(0));
        RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) downRightArrowView.getLayoutParams();
        int margin = (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, marginLeft, getResources().getDisplayMetrics());
        layoutParams.setMarginStart(margin);
        downRightArrowView.setLayoutParams(layoutParams);
        return v;
    }

    private void setScores(){
        TextView totalGames = (TextView) v.findViewById(R.id.user_profile_total_games);
        TextView wonGames = (TextView) v.findViewById(R.id.user_profile_won_games);
        TextView loseGames = (TextView) v.findViewById(R.id.user_profile_lose_games);
        totalGames.setText(String.valueOf(profile.totalGames));
        wonGames.setText(String.valueOf(profile.wonGames));
        loseGames.setText(String.valueOf(profile.loosingGames));
    }
    private void setButtons(){
        CardView btnFriend = (CardView) v.findViewById(R.id.user_profile_btn_friend);
        TextView btnFriendLabel = (TextView) v.findViewById(R.id.user_profile_btn_friend_label);
        ImageView btnFriendIcon = (ImageView) v.findViewById(R.id.user_profile_btn_friend_icon);
        CardView btnGame = (CardView) v.findViewById(R.id.user_profile_btn_game);
        TextView btnGameLabel = (TextView) v.findViewById(R.id.user_profile_btn_game_label);
        ImageView btnGameIcon = (ImageView) v.findViewById(R.id.user_profile_btn_game_icon);
        btnFriend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                btnFriendClick();
            }
        });

        switch (profile.type){
            case FRIEND:
                btnFriendLabel.setText("Удалить из друзей");
                btnFriendLabel.setTextColor(getResources().getColor(R.color.ttk_red));
                btnFriendIcon.setImageDrawable(getResources().getDrawable(R.drawable.remove_user));
                btnFriend.setVisibility(View.VISIBLE);
                break;
            case OPONENT:
                btnFriendLabel.setText("В друзья");
                btnFriendLabel.setTextColor(getResources().getColor(R.color.ttk_green));
                btnFriendIcon.setImageDrawable(getResources().getDrawable(R.drawable.add_user));
                btnFriend.setVisibility(View.VISIBLE);
                break;
            case ME:
                btnFriend.setVisibility(View.GONE);
                btnGame.setVisibility(View.GONE);
                return;
        }
        switch (profile.playStatus){
            case INVITED:
                btnGameLabel.setText("Приглашение отправлено");
                btnGameLabel.setTextColor(getResources().getColor(R.color.ttk_white));
                btnGameIcon.setImageDrawable(getResources().getDrawable(R.drawable.dice_filled));
                btnGame.setCardBackgroundColor(getResources().getColor(R.color.ttk_lightGray));
                break;
            case PLAYING:
                btnGameLabel.setText("Вы уже играете");
                btnGameLabel.setTextColor(getResources().getColor(R.color.ttk_white));
                btnGameIcon.setImageDrawable(getResources().getDrawable(R.drawable.dice_filled));
                btnGame.setCardBackgroundColor(getResources().getColor(R.color.ttk_lightGray));
                break;
            case READY:
                btnGameLabel.setText("Пригласить сыграть?");
                btnGameLabel.setTextColor(getResources().getColor(R.color.ttk_white));
                btnGameIcon.setImageDrawable(getResources().getDrawable(R.drawable.dice_filled));
                btnGame.setCardBackgroundColor(getResources().getColor(R.color.ttk_green));
                btnGame.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        btnGameClick();
                    }
                });
                break;
            case WAITING:
                btnGameLabel.setText("Вы уже играете");
                btnGameLabel.setTextColor(getResources().getColor(R.color.ttk_white));
                btnGameIcon.setImageDrawable(getResources().getDrawable(R.drawable.dice_filled));
                btnGame.setCardBackgroundColor(getResources().getColor(R.color.ttk_lightGray));
                break;
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
    private void btnFriendClick(){
        switch (profile.type){
            case OPONENT:
                setFriendlyStatus();
                break;
            case FRIEND:
                setFriendlyStatus();
                break;
        }
    }
    private void btnGameClick(){
        RestTaskUtil.createInvitation(getContext(), UserProfileFragment2.this, profile.getId());
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType().equals(RestTask.TaskType.ADD_FRIEND)) {
            if (taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)) {
                StatusSingle<GameModel> response = (StatusSingle<GameModel>) taskResult.getResponseData();
                if (response.getStatus().equals(ResponseStatus.SUCCESS)) {
                    Toast.makeText(getActivity().getApplicationContext(),
                            "Пользователь " + profile.getName() + " добавлен в друзья", Toast.LENGTH_LONG).show();
                    profile.type = UserType.FRIEND;
                    setButtons();
                }
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.REMOVE_FRIEND)){
            if (taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)) {
                StatusSingle<GameModel> response = (StatusSingle<GameModel>) taskResult.getResponseData();
                if (response.getStatus().equals(ResponseStatus.SUCCESS)) {

                    Toast.makeText(getActivity().getApplicationContext(),
                            "Пользователь "+profile.getName()+" удален из друзей", Toast.LENGTH_LONG).show();
                    profile.type = UserType.OPONENT;
                    setButtons();
                }
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.CREATE_INVITATION)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                StatusSingle<UserGameModel> response = (StatusSingle<UserGameModel>) taskResult.getResponseData();
                if(response.getStatus().equals(ResponseStatus.SUCCESS)) {
//                    getActivity().getSupportFragmentManager().popBackStack("GameList", FragmentManager.POP_BACK_STACK_INCLUSIVE);
//                    GamesListsFragment.UpdateGameList(getActivity().getSupportFragmentManager());
                    Toast.makeText(getActivity().getApplicationContext(),
                            "Приглашение пользователю "+profile.getName()+" отправлено", Toast.LENGTH_LONG).show();
                    profile = response.getData().oponent.user; //TODO: Проверить
                    setButtons();
                }
                else{
                    Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                            response.getErrorMessage(), Toast.LENGTH_LONG);
                    toast.show();
                }
            }
        }
    }

    public static void startUserProfileFragment(FragmentActivity activity, UserProfile user) {
        UserProfileFragment2 fragment = new UserProfileFragment2();
        fragment.profile = user;
        FragmentManager fragmentManager = activity.getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.flContent, fragment)
                .addToBackStack(null)
                .commit();
    }
}
