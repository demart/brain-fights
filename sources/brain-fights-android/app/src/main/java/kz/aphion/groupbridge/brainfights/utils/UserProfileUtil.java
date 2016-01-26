package kz.aphion.groupbridge.brainfights.utils;

import android.content.Context;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.UserProfile;

/**
 * Created by alimjan on 18.12.2015.
 */
public class UserProfileUtil {
    public static void setUserProfileUpData(UserProfile user, View v, Context context) throws ParseException {
        View upPanel = v.findViewById(R.id.user_profile_up_layout);
        TextView place = (TextView) upPanel.findViewById(R.id.place);
        ImageView avatar = (ImageView) upPanel.findViewById(R.id.user_profile_avatar);
        TextView username = (TextView) upPanel.findViewById(R.id.user_profile_username);
        TextView position = (TextView) upPanel.findViewById(R.id.user_profile_position);
        TextView lastEntrance = (TextView) upPanel.findViewById(R.id.user_profile_last_entrance);
        place.setText(String.valueOf(user.gamePosition));
        username.setText(user.name);
        position.setText(user.position);
        if(user.imageUrl!=null&&user.imageUrl.length()>0){
            Picasso.with(context).load(Const.BASE_URL+user.imageUrl).into(avatar);
        }
// /        avatar.bringToFront();
        if (user.lastStatisticsUpdate!=null) {
            Date lastEntranceDate = Util.getDateFromString(user.lastActivityTime);
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMMM yyyy", new Locale("ru"));
            lastEntrance.setText("Заходил "+sdf.format(lastEntranceDate));
        }
        //Picasso.with(context).load(user.avatar).into(avatar);
    }
}
