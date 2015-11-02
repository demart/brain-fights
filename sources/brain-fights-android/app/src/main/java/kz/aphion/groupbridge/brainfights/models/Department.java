package kz.aphion.groupbridge.brainfights.models;

import java.util.List;

/**
 * Created by alimjan on 02.11.2015.
 */
public class Department {

    public static Department getTestDepartment(){
        Department department = new Department();
        department.setId(Long.valueOf(1));
        department.setName("HR department");
        department.setHaveChildren(false);
        return department;
    }
    /**
     * Идентификатор записи
     */
    public Long id;

    /**
     * Наименование подразделения
     */
    public String name;

    /**
     * Кол-во пользователь в подразделении
     */
    public Integer userCount;

    /**
     * Рейтинг подразделения
     */
    public Integer score;

    /**
     * Есть ли подразделения на уровне ниже
     */
    public Boolean haveChildren;

    /**
     * Подразделения
     */
    public List<Department> children;

    /**
     * Родительское подразделение
     */
    public Department parent;

    /**
     * Список игроков в подразделении
     */
    public List<UserProfile> users;

    /**
     * Принадлежит ли пользователь к этому подразделению
     */
    public Boolean isUserBelongs;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getUserCount() {
        return userCount;
    }

    public void setUserCount(Integer userCount) {
        this.userCount = userCount;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Boolean getHaveChildren() {
        return haveChildren;
    }

    public void setHaveChildren(Boolean haveChildren) {
        this.haveChildren = haveChildren;
    }

    public List<Department> getChildren() {
        return children;
    }

    public void setChildren(List<Department> children) {
        this.children = children;
    }

    public Department getParent() {
        return parent;
    }

    public void setParent(Department parent) {
        this.parent = parent;
    }

    public List<UserProfile> getUsers() {
        return users;
    }

    public void setUsers(List<UserProfile> users) {
        this.users = users;
    }

    public Boolean getIsUserBelongs() {
        return isUserBelongs;
    }

    public void setIsUserBelongs(Boolean isUserBelongs) {
        this.isUserBelongs = isUserBelongs;
    }
}
