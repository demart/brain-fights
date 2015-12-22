package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 13.11.2015.
 */
public class UserList {
    UserProfile[] users;
    int count;
    int totalCount;

    public UserProfile[] getUsers() {
        return users;
    }

    public void setUsers(UserProfile[] users) {
        this.users = users;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }
}
