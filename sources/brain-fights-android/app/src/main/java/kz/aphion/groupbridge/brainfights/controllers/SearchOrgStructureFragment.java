package kz.aphion.groupbridge.brainfights.controllers;


import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.adapters.SearchOrgStructureAdapter;
import kz.aphion.groupbridge.brainfights.models.Department;
import kz.aphion.groupbridge.brainfights.models.Departments;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.SearchOrgStructModel;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserGameModel;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.models.UserType;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskUtil;


/**
 * Created by alimjan on 12.11.2015.
 */
public class SearchOrgStructureFragment extends Fragment implements RestTask.RestTaskCallback, SearchOrgStructureAdapter.SearchOrgStructureAdapterOnClickCallback {
    View v;
    RecyclerView rv;
    RecyclerView rvUsers;
    RelativeLayout loadingPanel;
    public Department parent = null;
    TextView departmentListLabel;
    TextView userListLabel;
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_orgstruct_search, container, false);
        rv = (RecyclerView) v.findViewById(R.id.orgstruct_search_list);
        rv.setLayoutManager(new LinearLayoutManager(getActivity()));
        rvUsers = (RecyclerView) v.findViewById(R.id.orgstruct_search_list_user);
        rvUsers.setLayoutManager(new LinearLayoutManager(getActivity()));
        loadingPanel = (RelativeLayout) v.findViewById(R.id.loadingPanel);
        loadingPanel.setVisibility(View.VISIBLE);
        TextView parentName = (TextView) v.findViewById(R.id.parent_department_name);
        departmentListLabel = (TextView) v.findViewById(R.id.department_list_label);
        userListLabel = (TextView) v.findViewById(R.id.user_list_label);
        if(parent!=null) {
            parentName.setText(parent.name);
        }else{
            parentName.setText("Транстелеком");
        }
        LoadDepartmentList();
        return v;
    }

    private void LoadDepartmentList() {
        RestTask task = new RestTask(getActivity().getApplicationContext(),this);
        RestTaskParams params;
        if(parent==null){
            params = new RestTaskParams(RestTask.TaskType.LOAD_ROOT_DEPARTMENTS);
            params.authToken = CurrentUser.getInstance().getAuthToken();
        }else {
            params = new RestTaskParams(RestTask.TaskType.LOAD_DEPARTMETS_BY_PARENT);
            params.parentId = parent.id;
        }
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType().equals(RestTask.TaskType.LOAD_ROOT_DEPARTMENTS)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                StatusSingle<Departments> response = (StatusSingle<Departments>) taskResult.getResponseData();
                if(response.getStatus().equals(ResponseStatus.SUCCESS))
                    setRootDepartment(response.getData().getDepartments());
            }
        }
        else if(taskResult.getTaskType().equals(RestTask.TaskType.LOAD_DEPARTMETS_BY_PARENT)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                StatusSingle<Departments> response = (StatusSingle<Departments>) taskResult.getResponseData();
                if(response.getStatus().equals(ResponseStatus.SUCCESS))
                    setChildDepartment(response.getData().getDepartments());
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
            }else{

            }
        }
    }

    private void setChildDepartment(Department[] departments) {
        List<SearchOrgStructModel> list = new ArrayList<>();
        if(parent.users!=null&&parent.users.size()>0){
            SearchOrgStructModel.addUserArrayToList(list,parent.users);
        }
        SearchOrgStructModel.addDepartmentsArrayToList(list, departments);
        setDataToRecyclerView(list);
    }

    private void setRootDepartment(Department[] departments) {
        List<SearchOrgStructModel> list = new ArrayList<>();
        SearchOrgStructModel.addDepartmentsArrayToList(list, departments);
        setDataToRecyclerView( list);
    }

    private void setDataToRecyclerView(final List<SearchOrgStructModel> list) {
        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    List<SearchOrgStructModel> departmentList = SearchOrgStructModel.getFromListByType(list,SearchOrgStructModel.SearchOrgStructModelType.DEPARTMENT);
                    final SearchOrgStructureAdapter rvAdapter = new SearchOrgStructureAdapter(R.layout.card_search_orgstruct, departmentList ,SearchOrgStructureFragment.this, getContext());
                    List<SearchOrgStructModel> userList = SearchOrgStructModel.getFromListByType(list,SearchOrgStructModel.SearchOrgStructModelType.USER);
                    final SearchOrgStructureAdapter rvAdapterUser = new SearchOrgStructureAdapter(R.layout.card_search_orgstruct, userList ,SearchOrgStructureFragment.this, getContext());
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            rv.setAdapter(rvAdapter);
                            if(rvAdapter.getItemCount()==0){
                                departmentListLabel.setVisibility(View.GONE);
                                rv.setVisibility(View.GONE);
                            }else{
                                departmentListLabel.setVisibility(View.VISIBLE);
                                rv.setVisibility(View.VISIBLE);
                            }
                            rvUsers.setAdapter(rvAdapterUser);
                            if(rvAdapterUser.getItemCount()==0){
                                userListLabel.setVisibility(View.GONE);
                                rvUsers.setVisibility(View.GONE);
                            }else{
                                userListLabel.setVisibility(View.VISIBLE);
                                rvUsers.setVisibility(View.VISIBLE);
                            }
                            loadingPanel.setVisibility(View.GONE);
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
        switch (item.getType()){
            case USER:
                UserProfile user = item.getUserProfile();
                if(user.getType().equals(UserType.ME)){
                    Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                            "Вы не можете играть сами с собой", Toast.LENGTH_LONG);
                    toast.show();
                }else {
                    RestTaskUtil.createInvitation(getContext(), this, user.getId());

                }
                break;
            case DEPARTMENT:
                Department department = item.getDepartmentModel();
                if(department.haveChildren||(department.users!=null&&department.users.size()>0)){
                    SearchOrgStructureFragment searchOrgStructureFragment = new SearchOrgStructureFragment();
                    searchOrgStructureFragment.parent = department;
                    FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                    fragmentManager.beginTransaction()
                            .add(R.id.flContent, searchOrgStructureFragment)
                            .setTransition(FragmentTransaction.TRANSIT_FRAGMENT_OPEN)
                            .addToBackStack(null)
                            .commit();
                }
                break;
        }
    }

    @Override
    public void onProfileClick(UserProfile user) {
        UserProfileFragment2.startUserProfileFragment(getActivity(),user);
    }

    @Override
    public void onGameClick(UserProfile user) {
        RestTaskUtil.createInvitation(getContext(), this, user.getId());
    }
}
