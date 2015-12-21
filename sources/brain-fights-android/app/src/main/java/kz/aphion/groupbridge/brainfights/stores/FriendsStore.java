package kz.aphion.groupbridge.brainfights.stores;

import kz.aphion.groupbridge.brainfights.models.UserProfile;

/**
 * Created by alimjan on 11.11.2015.
 */
public class FriendsStore {
    UserProfile[] friends = new UserProfile[0];
    private FriendsStore(){};
    private FriendsStore(UserProfile[] friends){this.friends = friends;}
    private static FriendsStore instance = new FriendsStore(new UserProfile[0]);
    public static void init(UserProfile[] friends){
        instance = new FriendsStore(friends);
    }
    public static FriendsStore getInstance(){
        return instance;
    }

    public UserProfile[] getFriends() {
        return friends;
    }
}
