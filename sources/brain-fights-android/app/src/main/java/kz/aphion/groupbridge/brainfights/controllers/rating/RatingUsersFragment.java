package kz.aphion.groupbridge.brainfights.controllers.rating;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.Toast;

import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.adapters.RatingUsersRecyclerAdapter;
import kz.aphion.groupbridge.brainfights.controllers.UserProfileFragment;
import kz.aphion.groupbridge.brainfights.controllers.UserProfileFragment2;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.models.Users;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;

/**
 * Created by alimjan on 08.12.2015.
 */
public class RatingUsersFragment extends Fragment implements RestTask.RestTaskCallback, RatingUsersRecyclerAdapter.OnUserRatingListCallback {
    private static int ROW_LOAD_LIMIT = 10;

    View v;
    RecyclerView rv;
    RelativeLayout loadingPanel;
    LinearLayoutManager mLayoutManager;
    private boolean loading = true;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_rating_users,container,false);
        rv = (RecyclerView) v.findViewById(R.id.rating_users_list);
        setScrollEvent(rv);
        mLayoutManager = new LinearLayoutManager(getContext());

        rv.setLayoutManager(mLayoutManager);
        loadingPanel = (RelativeLayout) v.findViewById(R.id.loadingPanel);
        loadingPanel.setVisibility(View.VISIBLE);
        LoadRating(0);
        return v;
    }
    public void LoadRating(int page){
        RestTask task = new RestTask(getContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.GET_USERS_RATING);
        params.page = page;
        params.limit = ROW_LOAD_LIMIT;
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType().equals(RestTask.TaskType.GET_USERS_RATING)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                loadingPanel.setVisibility(View.GONE);
                StatusSingle<Users> status = (StatusSingle) taskResult.getResponseData();
                if(status.getStatus().equals(ResponseStatus.SUCCESS))
                    addDataToList(status.getData().users);
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
        }
    }
    private void addDataToList(final List<UserProfile> users) {
        if(users!=null&& users.size()>0){
            try {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        //final FriendsRecyclerAdapter rvAdapter = new FriendsRecyclerAdapter(R.layout.card_friend,friendsStore.getFriends(),NewGameChoiceFragment.this);
                        final RatingUsersRecyclerAdapter rvAdapter;
                        if(rv.getAdapter()==null) {
                            rvAdapter = new RatingUsersRecyclerAdapter(R.layout.card_rating_user, users, RatingUsersFragment.this, getContext());
                            getActivity().runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    rv.setAdapter(rvAdapter);
                                    loadingPanel.setVisibility(View.GONE);
                                }
                            });
                        }
                        else {
                            rvAdapter = (RatingUsersRecyclerAdapter) rv.getAdapter();
                            getActivity().runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    rvAdapter.addRows(users);
                                    rvAdapter.notifyDataSetChanged();
                                    loadingPanel.setVisibility(View.GONE);
                                    loading=true;
                                }
                            });
                        }

                    }
                }).start();


            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onUserRatingToProfileClick(UserProfile user) {
        UserProfileFragment2.startUserProfileFragment(getActivity(), user);
    }

    public void setScrollEvent(RecyclerView recyclerView) {
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                if(dy > 0){
                    int pastVisiblesItems, visibleItemCount, totalItemCount;
                    visibleItemCount = mLayoutManager.getChildCount();
                    totalItemCount = mLayoutManager.getItemCount();
                    pastVisiblesItems = mLayoutManager.findFirstVisibleItemPosition();
                    if (loading)
                    {
                        if ( (visibleItemCount + pastVisiblesItems) >= totalItemCount)
                        {
                            loading = false;
                            if(totalItemCount%ROW_LOAD_LIMIT==0){ //TODO: Проверить
                                LoadRating((totalItemCount/ROW_LOAD_LIMIT) + 1);
                            }else{
//                                LoadRating(0);
                            }
                        }
                    }
                }
            }
        });
    }
}
