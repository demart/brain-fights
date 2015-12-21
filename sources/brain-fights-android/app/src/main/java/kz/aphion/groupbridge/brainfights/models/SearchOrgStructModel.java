package kz.aphion.groupbridge.brainfights.models;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.groupbridge.brainfights.adapters.SearchOrgStructureAdapter;

/**
 * Created by alimjan on 11.11.2015.
 */
public class SearchOrgStructModel {
    UserProfile userProfile = null;
    Department departmentModel = null;
    SearchOrgStructModelType type;
    public SearchOrgStructModel(UserProfile userProfile){
        this.type = SearchOrgStructModelType.USER;
        this.userProfile = userProfile;
    }
    public SearchOrgStructModel(Department departmentModel){
        this.type = SearchOrgStructModelType.DEPARTMENT;
        this.departmentModel = departmentModel;
    }


    public UserProfile getUserProfile() {
        return userProfile;
    }

    public Department getDepartmentModel() {
        return departmentModel;
    }

    public SearchOrgStructModelType getType() {
        return type;
    }

    public enum SearchOrgStructModelType{
        USER,
        DEPARTMENT;
    }
    public static void addDepartmentsArrayToList(List<SearchOrgStructModel> list, Department[] departments){
        for (Department department:departments){
            if(department.haveChildren||(department.users!=null&&department.users.size()>0))
            list.add(new SearchOrgStructModel(department));
        }
    }
    public static void addUserArrayToList(List<SearchOrgStructModel> list, List<UserProfile>  users){
        for (UserProfile user:users){
            list.add(new SearchOrgStructModel(user));
        }
    }
    public static void addUserArrayToList(List<SearchOrgStructModel> list, UserProfile[]  users){
        for (UserProfile user:users){
            list.add(new SearchOrgStructModel(user));
        }
    }
    public static List<SearchOrgStructModel> getFromListByType(List<SearchOrgStructModel> list, SearchOrgStructModelType type){
        List<SearchOrgStructModel> newList = new ArrayList<>();
        for(SearchOrgStructModel item:list){
            if(item.getType().equals(type)){
                newList.add(item);
            }
        }
        return newList;
    }
}
