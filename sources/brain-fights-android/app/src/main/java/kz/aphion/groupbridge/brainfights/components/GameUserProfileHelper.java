package kz.aphion.groupbridge.brainfights.components;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.github.siyamed.shapeimageview.CircularImageView;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.utils.Const;

/**
 * Created by alimjan on 18.11.2015.
 */
public class GameUserProfileHelper {
    View userCard;
    UserProfile user;
    AutoResizeTextView name;
    AutoResizeTextView position;
    CircularImageView avatar;
    Context context;
    public GameUserProfileHelper(View userCard, Context context){
        this.userCard = userCard;
        this.name = (AutoResizeTextView) userCard.findViewById(R.id.game_user_profile_name);
        this.position = (AutoResizeTextView) userCard.findViewById(R.id.game_user_profile_position);
        this.avatar = (CircularImageView)userCard.findViewById(R.id.user_profile_avatar);
        this.context = context;
    }
    public void setData(UserProfile user){
        this.user = user;
        updateView();

    }
    public void updateView(){
        final int height = userCard.getMeasuredHeight();
        int imageHeight = height*50/100;




        LinearLayout.LayoutParams paramsName = (LinearLayout.LayoutParams)name.getLayoutParams();
        paramsName.height = height*30/100;
        name.setLayoutParams(paramsName);
        name.setText(user.getName());

//        name.refreshDrawableState();
        LinearLayout.LayoutParams paramsPosition = (LinearLayout.LayoutParams)position.getLayoutParams();
        paramsPosition.height = height*20/100;
        position.setLayoutParams(paramsPosition);
        position.setText(user.getPosition());

        if(user.imageUrl!=null&&user.imageUrl.length()>0) {
            avatar.setVisibility(View.GONE);
            final int imageHeight2 = height*50/100;
            Picasso.with(context).load(Const.BASE_URL + user.imageUrl).into(avatar, new Callback() {
                @Override
                public void onSuccess() {
                    LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) avatar.getLayoutParams();
                    params.height = imageHeight2;
                    params.width = imageHeight2;
                    avatar.setLayoutParams(params);
                    avatar.setScaleType(ImageView.ScaleType.FIT_CENTER);

                    avatar.setVisibility(View.VISIBLE);

                }

                @Override
                public void onError() {

                }
            });
        }else {
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) avatar.getLayoutParams();
            params.height = imageHeight;
            params.width = imageHeight;
            avatar.setLayoutParams(params);
        }

        avatar.setScaleType(ImageView.ScaleType.FIT_CENTER);
        avatar.refreshDrawableState();

    }
}
