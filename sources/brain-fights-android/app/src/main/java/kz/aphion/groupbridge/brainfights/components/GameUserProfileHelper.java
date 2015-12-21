package kz.aphion.groupbridge.brainfights.components;

import android.view.View;
import android.widget.TextView;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.UserProfile;

/**
 * Created by alimjan on 18.11.2015.
 */
public class GameUserProfileHelper {
    View userCard;
    UserProfile user;
    TextView name;
    TextView position;
    public GameUserProfileHelper(View userCard){
        this.userCard = userCard;
        this.name = (TextView) userCard.findViewById(R.id.game_user_profile_name);
        this.position = (TextView) userCard.findViewById(R.id.game_user_profile_position);
    }
    public void setData(UserProfile user){
        this.user = user;
        updateView();

    }
    public void updateView(){
        name.setText(user.getName());
        position.setText(user.getPosition());
    }
}
