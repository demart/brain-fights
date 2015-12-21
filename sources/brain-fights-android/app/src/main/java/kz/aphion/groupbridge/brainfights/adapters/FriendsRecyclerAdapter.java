package kz.aphion.groupbridge.brainfights.adapters;

import android.content.Context;
import android.support.v7.widget.CardView;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.UserProfile;

/**
 * Created by alimjan on 11.11.2015.
 */
public class FriendsRecyclerAdapter extends RecyclerView.Adapter<FriendsRecyclerAdapter.ViewHolder> {


    int layout;
    UserProfile[] friends;
    FriendRecyclerOnClickCallback callback;
    Context context;

    public FriendsRecyclerAdapter(int layout, UserProfile[] friendList, FriendRecyclerOnClickCallback callback, Context context){
        super();
        this.layout = layout;
        this.friends = friendList;
        this.callback = callback;
        this.context = context;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(layout, parent, false);
        return new ViewHolder(v, callback);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        UserProfile profile = friends[position];
        holder.name.setText(profile.getName());
        holder.position.setText(profile.getPosition());
        holder.friendPosition = position;
        holder.user = profile;
        switch (profile.playStatus){
            case WAITING:
                holder.game.setCardBackgroundColor(context.getResources().getColor(R.color.ttk_lightGray));
                holder.game.setClickable(false);
                break;
            case PLAYING:
                holder.game.setCardBackgroundColor(context.getResources().getColor(R.color.ttk_lightGray));
                holder.game.setClickable(false);
                break;
            case INVITED:
                holder.game.setCardBackgroundColor(context.getResources().getColor(R.color.ttk_lightGray));
                holder.game.setClickable(false);
                break;
            case READY:
                holder.game.setCardBackgroundColor(context.getResources().getColor(R.color.ttk_orange));
                holder.game.setClickable(true);
                break;

        }
    }

    @Override
    public int getItemCount() {
        return friends.length;
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public int friendPosition = -1;
        public TextView name;
        public TextView position;
        LinearLayout profile;
        CardView game;
        UserProfile user;
        ImageButton gameImage;
        public ViewHolder(View itemView, final FriendRecyclerOnClickCallback callback) {
            super(itemView);
//            name = (TextView) itemView.findViewById(R.id.friend_list_name);
            name = (TextView) itemView.findViewById(R.id.card_user_name);
            position = (TextView) itemView.findViewById(R.id.card_user_position);
            profile = (LinearLayout) itemView.findViewById(R.id.card_user_profile_layout);
            game = (CardView) itemView.findViewById(R.id.card_user_game_layout);
            gameImage = (ImageButton) game.findViewById(R.id.card_user_game_image);
            game.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callback.onGameClick(user);
                }
            });
            gameImage.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callback.onGameClick(user);
                }
            });
            profile.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callback.onProfileClick(user);
                }
            });
//            itemView.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View view) {
//                    callback.onFriendClick(friendPosition);
//                }
//            });
        }
    }
    public interface FriendRecyclerOnClickCallback{
        void onFriendClick(int friendPosition);
        void onProfileClick(UserProfile user);
        void onGameClick(UserProfile user);
    };
}
