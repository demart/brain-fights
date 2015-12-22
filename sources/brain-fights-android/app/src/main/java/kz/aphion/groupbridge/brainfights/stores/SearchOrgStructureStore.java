package kz.aphion.groupbridge.brainfights.stores;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.groupbridge.brainfights.models.Department;

/**
 * Created by alimjan on 11.11.2015.
 */
public class SearchOrgStructureStore {
    private static SearchOrgStructureStore instance;
    private SearchOrgStructureStore(){};
    public static SearchOrgStructureStore getInstance(){
        if(instance==null){
            instance = new SearchOrgStructureStore();
        }
        return instance;
    }
    List<Department> departments = new ArrayList<>();
    public Department getDepartmentById(Long id){
        for (Department department:departments){
            if(department.id.equals(id)){
                return department;
            }
        }
        return null;
    }
//    public List<Department> getChildDepartment(Long parentId){
//        List<Department> list = new ArrayList<>();
//        for(Department department:departments){
//            if(department.ge)
//        }
//    }
}
