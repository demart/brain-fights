package kz.aphion.groupbridge.brainfights.controllers;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v7.widget.CardView;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.Toast;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.adapters.FriendsRecyclerAdapter;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserGameModel;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.stores.FriendsStore;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskUtil;

/**
 * Created by alimjan on 11.11.2015.
 */
public class NewGameChoiceFragment extends Fragment implements RestTask.RestTaskCallback, FriendsRecyclerAdapter.FriendRecyclerOnClickCallback {
    View v;
    RecyclerView rv;
    RelativeLayout loadingPanel;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.new_game_type_choice, container, false);
        rv = (RecyclerView) v.findViewById(R.id.new_game_friend_list);
        rv.setLayoutManager(new LinearLayoutManager(getActivity()));
        loadingPanel = (RelativeLayout) v.findViewById(R.id.loadingPanel);
        loadingPanel.setVisibility(View.VISIBLE);
        LoadFriendList();
        CardView btnRandomGame = (CardView) v.findViewById(R.id.new_random_game);
        btnRandomGame.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startNewRandomGame();
            }
        });
        CardView btnOrgStructSearch = (CardView)v.findViewById(R.id.new_orgstruct_game);
        btnOrgStructSearch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startOrgstructSearch();
            }
        });
        CardView btnTextSearch = (CardView) v.findViewById(R.id.new_search_game);
        btnTextSearch.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startUserByTextSearch();
            }
        });
        return v;
    }

    private void startUserByTextSearch() {
        SearchUserByTextFragment searchUserByTextFragment = new SearchUserByTextFragment();
        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .add(R.id.container, searchUserByTextFragment)
                .addToBackStack(null)
                .commit();
    }

    private void startOrgstructSearch() {
        SearchOrgStructureFragment searchOrgStructureFragment = new SearchOrgStructureFragment();
        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .add(R.id.container, searchOrgStructureFragment)
                .addToBackStack(null)
                .commit();
    }

    private void LoadFriendList(){
        RestTask restTask = new RestTask(getContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.LOAD_FRIEND_LIST);
        params.authToken = CurrentUser.getInstance().getAuthToken();
        restTask.execute(params);
    }
    private void startNewRandomGame(){
        loadingPanel.setVisibility(View.VISIBLE);
        RestTask task = new RestTask(getContext(), this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.START_NEW_RANDOM_GAME);
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }
    private void startedNewRandomGame(){
        getActivity().getSupportFragmentManager().popBackStack();
    }
    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType().equals(RestTask.TaskType.LOAD_FRIEND_LIST)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                LoadDataToFriendList();
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.START_NEW_RANDOM_GAME)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                loadingPanel.setVisibility(View.GONE);
                StatusSingle status = (StatusSingle) taskResult.getResponseData();
                if(status.getStatus().equals(ResponseStatus.SUCCESS))
                    startedNewRandomGame();
                else{
                    Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                            status.getErrorMessage(), Toast.LENGTH_LONG);
                    toast.show();
                }
            }else{
                Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                        "Ошибка отправки данных на сервер", Toast.LENGTH_LONG);
                toast.show();
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
    private void LoadDataToFriendList(){
        final FriendsStore friendsStore = FriendsStore.getInstance();
        if(friendsStore!=null){
            try {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        //final FriendsRecyclerAdapter rvAdapter = new FriendsRecyclerAdapter(R.layout.card_friend,friendsStore.getFriends(),NewGameChoiceFragment.this);
                        final FriendsRecyclerAdapter rvAdapter = new FriendsRecyclerAdapter(R.layout.card_user,friendsStore.getFriends(),NewGameChoiceFragment.this, getContext());
                        getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                rv.setAdapter(rvAdapter);
                                loadingPanel.setVisibility(View.GONE);
                            }
                        });
                    }
                }).start();


            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onFriendClick(int friendPosition) {

    }

    @Override
    public void onProfileClick(UserProfile user) {
        UserProfileFragment.startUserProfileFragment(getActivity(),user);
    }

    @Override
    public void onGameClick(UserProfile user) {
        RestTaskUtil.createInvitation(getContext(), this, user.getId());
    }
}
