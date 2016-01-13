package kz.aphion.groupbridge.brainfights.controllers.rating;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.sothree.slidinguppanel.SlidingUpPanelLayout;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.adapters.RatingDTypesReyclerAdapter;
import kz.aphion.groupbridge.brainfights.adapters.RatingDepartmentRecyclerAdapter;
import kz.aphion.groupbridge.brainfights.adapters.RatingUsersRecyclerAdapter;
import kz.aphion.groupbridge.brainfights.controllers.SearchOrgStructureFragment;
import kz.aphion.groupbridge.brainfights.models.Department;
import kz.aphion.groupbridge.brainfights.models.DepartmentTypeModel;
import kz.aphion.groupbridge.brainfights.models.DepartmentTypes;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.Status;
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
public class RatingDepartmentChoiceFragment extends Fragment implements RestTask.RestTaskCallback, RatingDTypesReyclerAdapter.RatingDTypesReyclerAdapterCallback, RatingDepartmentRecyclerAdapter.RatingDepartmentRecyclerAdapterCallback {
    final int LOAD_DEPARTMENTS_LIMIT=20;
    View v;
    RecyclerView rvDepartments;
    RecyclerView rvTypes;
    RelativeLayout loadingPanel;
    LinearLayoutManager mLayoutManager;
    SlidingUpPanelLayout slidingUpPanel;
    Button closeChoiceLayoutButton;
    ImageView openChoiceLayoutButton;
    DepartmentTypeModel currentType;
    TextView tvTypeName;
    private boolean loading = true;
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_rating_department_choice, container, false);
        rvDepartments = (RecyclerView) v.findViewById(R.id.rating_departments_list);
        rvTypes = (RecyclerView) v.findViewById(R.id.rating_departments_type_list);
        rvTypes.setLayoutManager(new LinearLayoutManager(getContext()));
        mLayoutManager = new LinearLayoutManager(getContext());
        slidingUpPanel = (SlidingUpPanelLayout) v.findViewById(R.id.sliding_layout);
        closeChoiceLayoutButton = (Button) v.findViewById(R.id.types_layout_close);
        openChoiceLayoutButton = (ImageView) v.findViewById(R.id.rating_departments_open_choice);
        rvDepartments.setLayoutManager(mLayoutManager);
        loadingPanel = (RelativeLayout) v.findViewById(R.id.loadingPanel);
        tvTypeName = (TextView) v.findViewById(R.id.rating_departments_type_name_choiced);
        setListeners();
        loadingPanel.setVisibility(View.VISIBLE);

        LoadTypes();
        return v;
    }

    private void LoadTypes(){
        RestTask task = new RestTask(getContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.GET_RATING_DEPARTMENT_TYPES);
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }
    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setHasOptionsMenu(true);
    }
    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
//        inflater.inflate(R.menu.rating_department_menu, menu);
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
//        int id = item.getItemId();
//        if(id == R.id.action_filter){
//            //Do whatever you want to do
//            return true;
//        }
        return super.onOptionsItemSelected(item);
    }
    private void addTypesToList(final DepartmentTypeModel[] list){
        if(list!=null&&list.length>0){
            try {
                new Thread(new Runnable() {

                    @Override
                    public void run() {
                        final RatingDTypesReyclerAdapter adapter = new RatingDTypesReyclerAdapter(R.layout.card_rating_department_type,list,RatingDepartmentChoiceFragment.this, getContext());
                        getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                rvTypes.setNestedScrollingEnabled(false);
                                rvTypes.setAdapter(adapter);
                                setSlidingHeight();
                                setRecycleViewHeight(rvTypes);
                                if(currentType==null)
                                slidingUpPanel.setPanelState(SlidingUpPanelLayout.PanelState.EXPANDED);
                            }
                        });
                    }
                }).start();
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }

    private void setRecycleViewHeight(RecyclerView rv){
        int itemCount = rv.getAdapter().getItemCount();
        float dimen = getResources().getDimension(R.dimen.game_card_height);
        float eva = getResources().getDimension(R.dimen.game_card_evaluation);
        int height = (int)Math.ceil(itemCount * (dimen+/*4**/eva));
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) rv.getLayoutParams();
        layoutParams.height = height;
        rv.setLayoutParams(layoutParams);
    }
    private void setSlidingHeight() {
//        int rvHeight = rvTypes.getMeasuredHeight();
//        slidingUpPanel.setPanelHeight(rvHeight);
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType().equals(RestTask.TaskType.GET_RATING_DEPARTMENT_TYPES)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                loadingPanel.setVisibility(View.GONE);
                Status<DepartmentTypeModel> status = (Status) taskResult.getResponseData();
                if(status.getStatus().equals(ResponseStatus.SUCCESS))
                    addTypesToList(status.getData());
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
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.GET_RATING_DEPARTMENTS)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                loadingPanel.setVisibility(View.GONE);
                Status<Department> status = (Status) taskResult.getResponseData();
                if(status.getStatus().equals(ResponseStatus.SUCCESS)) {
                    List<Department> list = new ArrayList<Department>(Arrays.asList(status.getData()));
                            addDepartmentToList(list);
                }
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
    private void loadDeps(int page){
        if(currentType!=null){
            RestTask task = new RestTask(getContext(),this);
            RestTaskParams params = new RestTaskParams(RestTask.TaskType.GET_RATING_DEPARTMENTS);
            params.departmentTypeId = currentType.id;
            params.page = page;
            params.limit = LOAD_DEPARTMENTS_LIMIT;
            params.authToken = CurrentUser.getInstance().getAuthToken();
            task.execute(params);
        }
    }
    @Override
    public void onRatingDTypesItemClick(DepartmentTypeModel type) {
        if(!type.equals(currentType)) {
            currentType = type;
            tvTypeName.setText(type.name);
            if(rvDepartments.getAdapter()!=null)
            ((RatingDepartmentRecyclerAdapter)rvDepartments.getAdapter()).clear();
            loadDeps(0);
        }
        slidingUpPanel.setPanelState(SlidingUpPanelLayout.PanelState.COLLAPSED);
    }
    private void setListeners(){
        closeChoiceLayoutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                slidingUpPanel.setPanelState(SlidingUpPanelLayout.PanelState.COLLAPSED);
            }
        });
        openChoiceLayoutButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                slidingUpPanel.setPanelState(SlidingUpPanelLayout.PanelState.EXPANDED);
            }
        });
        setScrollEvent(rvDepartments);
    }
    public void setScrollEvent(RecyclerView recyclerView) {
        recyclerView.addOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                if (dy > 0) {
                    int pastVisiblesItems, visibleItemCount, totalItemCount;
                    visibleItemCount = mLayoutManager.getChildCount();
                    totalItemCount = mLayoutManager.getItemCount();
                    pastVisiblesItems = mLayoutManager.findFirstVisibleItemPosition();
                    if (loading) {
                        if ((visibleItemCount + pastVisiblesItems) >= totalItemCount) {
                            loading = false;
                            if (totalItemCount % LOAD_DEPARTMENTS_LIMIT == 0) { //TODO: Проверить
                                loadDeps((totalItemCount / LOAD_DEPARTMENTS_LIMIT) + 1);
                            } else {
//                                LoadRating(0);
                            }
                        }
                    }
                }
            }
        });
    }

    private void addDepartmentToList(final List<Department> users) {
        if(users!=null){
            try {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        //final FriendsRecyclerAdapter rvAdapter = new FriendsRecyclerAdapter(R.layout.card_friend,friendsStore.getFriends(),NewGameChoiceFragment.this);
                        final RatingDepartmentRecyclerAdapter rvAdapter;
                        if(rvDepartments.getAdapter()==null) {
                            rvAdapter = new RatingDepartmentRecyclerAdapter(R.layout.card_rating_department, users, RatingDepartmentChoiceFragment.this, getContext());
                            getActivity().runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    rvDepartments.setAdapter(rvAdapter);
                                    loadingPanel.setVisibility(View.GONE);
                                }
                            });
                        }
                        else {
                            rvAdapter = (RatingDepartmentRecyclerAdapter) rvDepartments.getAdapter();
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
    public void onItemClick(Department department) {
        SearchOrgStructureFragment searchOrgStructureFragment = new SearchOrgStructureFragment();
        searchOrgStructureFragment.parent = department;
        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .add(R.id.flContent, searchOrgStructureFragment)
                .setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
                .addToBackStack(null)
                .commit();
    }
}
