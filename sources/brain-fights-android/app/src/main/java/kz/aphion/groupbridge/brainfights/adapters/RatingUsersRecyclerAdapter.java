package kz.aphion.groupbridge.brainfights.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.models.UserType;

/**
 * Created by alimjan on 09.12.2015.
 */
public class RatingUsersRecyclerAdapter extends RecyclerView.Adapter<RatingUsersRecyclerAdapter.ViewHolder> {

    private final Context context;
    List<UserProfile> ratingList;
    int layout;
    OnUserRatingListCallback callback;


    public RatingUsersRecyclerAdapter(int layout, List<UserProfile> ratingList, OnUserRatingListCallback callback, Context context){
        this.ratingList = ratingList;
        this.layout = layout;
        this.callback = callback;
        this.context = context;
    }
    public void addRows(List<UserProfile> rows){
        ratingList.addAll(rows);
    }
    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(layout, parent, false);
        return new ViewHolder(v, callback);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        UserProfile user = ratingList.get(position);
        holder.name.setText(user.getName());
        holder.user = user;
        holder.position.setText(user.position);
        holder.ratingPosition.setText(String.valueOf(user.gamePosition));
        holder.rating.setText(String.valueOf(user.getScore()));
        if(position%2>0)holder.layout.setBackgroundColor(context.getResources().getColor(R.color.ttk_row_bg));
        if(user.score-user.lastScore>=0){
            holder.scoreChange.setText("(+"+(user.score-user.lastScore)+")");
            holder.scoreChange.setTextColor(context.getResources().getColor(R.color.ttk_green));
        }else{
            holder.scoreChange.setText("("+(user.score-user.lastScore)+")");
            holder.scoreChange.setTextColor(context.getResources().getColor(R.color.ttk_red));
        }
        if(user.gamePosition-user.lastGamePosition>=0){
            holder.positionChange.setText("(+"+(user.gamePosition-user.lastGamePosition)+")");
            holder.positionChange.setTextColor(context.getResources().getColor(R.color.ttk_green));
        }else{
            holder.positionChange.setText("("+(user.gamePosition-user.lastGamePosition)+")");
            holder.positionChange.setTextColor(context.getResources().getColor(R.color.ttk_red));
        }
        if(user.getType().equals(UserType.ME)){
            holder.itsMe.setVisibility(View.VISIBLE);
        }else{
            holder.itsMe.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return ratingList.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {

        TextView ratingPosition;
        TextView name;
        TextView position;
        TextView rating;
        ImageView toProfile;
        UserProfile user;
        LinearLayout layout;
        TextView positionChange;
        TextView scoreChange;
        TextView itsMe;
        public ViewHolder(View itemView, final OnUserRatingListCallback callback) {
            super(itemView);
            rating = (TextView) itemView.findViewById(R.id.rating_user_rating);
            ratingPosition = (TextView) itemView.findViewById(R.id.rating_user_position);
            name = (TextView) itemView.findViewById(R.id.rating_user_username);
            position = (TextView) itemView.findViewById(R.id.rating_user_userposition);
            layout = (LinearLayout) itemView.findViewById(R.id.card_layout);
            positionChange = (TextView) itemView.findViewById(R.id.position_change);
            scoreChange = (TextView) itemView.findViewById(R.id.score_change);
            itsMe = (TextView) itemView.findViewById(R.id.its_me);
            toProfile = (ImageView) itemView.findViewById(R.id.rating_user_toprofile);
            toProfile.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callback.onUserRatingToProfileClick(user);
                }
            });
        }
    }
    public interface OnUserRatingListCallback{
        void onUserRatingToProfileClick(UserProfile user);
    }
}
