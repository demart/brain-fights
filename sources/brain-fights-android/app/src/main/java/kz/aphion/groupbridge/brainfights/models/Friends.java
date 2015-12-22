package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 11.11.2015.
 */
public class Friends {
    UserProfile[] friends;
    int count;

    public UserProfile[] getFriends() {
        return friends;
    }

    public void setFriends(UserProfile[] friends) {
        this.friends = friends;
    }

    public int getCount() {
        return count;
    }

    public void setCount(int count) {
        this.count = count;
    }
}
