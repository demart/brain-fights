package kz.aphion.groupbridge.brainfights.controllers;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.SearchView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.adapters.SearchOrgStructureAdapter;
import kz.aphion.groupbridge.brainfights.adapters.SearchUserByTextAdapter;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.SearchOrgStructModel;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserGameModel;
import kz.aphion.groupbridge.brainfights.models.UserList;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskUtil;

/**
 * Created by alimjan on 13.11.2015.
 */
public class SearchUserByTextFragment extends Fragment implements RestTask.RestTaskCallback, SearchOrgStructureAdapter.SearchOrgStructureAdapterOnClickCallback {
    View v;
    SearchView searchView;
    RecyclerView rv;
    RestTask task;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_text_user_search, container, false);
        rv = (RecyclerView) v.findViewById(R.id.user_search_by_text_list);
        rv.setLayoutManager(new LinearLayoutManager(getActivity()));
        searchView = (SearchView) v.findViewById(R.id.user_search_by_text_search);
        searchView.setQueryHint("Введите имя");
        searchView.setIconifiedByDefault(false);
        searchView.requestFocus();
        InputMethodManager imm = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.toggleSoftInput(InputMethodManager.SHOW_FORCED, 0);
        searchView.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
            @Override
            public boolean onQueryTextSubmit(String s) {
                startSearchUser("");
                return false;
            }

            @Override
            public boolean onQueryTextChange(String s) {
                if (s.length() > 2) {
                    startSearchUser(s);
                } else {
                    setEmptyUserList();
                }
                return false;
            }
        });
        return v;
    }

    private void setEmptyUserList() {
        setFoundedUser(new UserProfile[0]);
    }

    private void startSearchUser(String s) {
        stopPreviousTask();
        task = new RestTask(getActivity().getApplicationContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.SEARCH_USER_BY_TEXT);
        params.searchText = s;
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }

    private void stopPreviousTask() {
        if(task!=null){
            if(task.getStatus().equals(AsyncTask.Status.RUNNING)){
                task.cancel(false);
            }
        }
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType().equals(RestTask.TaskType.SEARCH_USER_BY_TEXT)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                StatusSingle<UserList> response = (StatusSingle<UserList>) taskResult.getResponseData();
                if(response.getStatus().equals(ResponseStatus.SUCCESS))
                    setFoundedUser(response.getData().getUsers());
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

    private void setFoundedUser(final UserProfile[] users) {
        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    List<SearchOrgStructModel> list = new ArrayList<>();
                    SearchOrgStructModel.addUserArrayToList(list, users);
                    final SearchOrgStructureAdapter rvAdapter = new SearchOrgStructureAdapter(R.layout.card_search_orgstruct,list,SearchUserByTextFragment.this);
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            rv.setAdapter(rvAdapter);
                        }
                    });
                }
            }).start();


        }catch (Exception e){
            e.printStackTrace();
        }
    }

    @Override
    public void searchOrgStructureOnItemClick(SearchOrgStructModel item) {
        if (item.getUserProfile() != null) {
            RestTaskUtil.createInvitation(getContext(),this, item.getUserProfile().getId());
        }
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
