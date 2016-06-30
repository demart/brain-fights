package kz.aphion.groupbridge.brainfights.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.github.siyamed.shapeimageview.CircularImageView;
import com.squareup.picasso.Picasso;

import org.w3c.dom.Text;

import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.Department;
import kz.aphion.groupbridge.brainfights.models.SearchOrgStructModel;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.models.UserType;
import kz.aphion.groupbridge.brainfights.utils.Const;

/**
 * Created by alimjan on 11.11.2015.
 */
public class SearchOrgStructureAdapter extends RecyclerView.Adapter<SearchOrgStructureAdapter.ViewHolder> {

    int layout;
    List<SearchOrgStructModel> items;
    SearchOrgStructureAdapterOnClickCallback callback;
    Context context;

    public SearchOrgStructureAdapter(int layout, List<SearchOrgStructModel> items, SearchOrgStructureAdapterOnClickCallback callback, Context context){
        this.layout = layout;
        this.items = items;
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
        SearchOrgStructModel item = items.get(position);
        if(item.getType().equals(SearchOrgStructModel.SearchOrgStructModelType.USER)){
            UserProfile user = item.getUserProfile();
            holder.departmentLayout.setVisibility(View.GONE);
            if(user.getType().equals(UserType.ME))
                holder.userName.setText("ВЫ ("+user.getName()+")");
            else
            holder.userName.setText(user.getName());
            holder.userPosition.setText(user.getPosition());
            if(user.imageUrl!=null&&user.imageUrl.length()>0)
            Picasso.with(context).load(Const.BASE_URL+user.imageUrl).into(holder.avatar);

        }else {
            Department department = item.getDepartmentModel();
            holder.userLayout.setVisibility(View.GONE);
            holder.departmentName.setText(department.name);
            holder.departmentLayout.setVisibility(View.VISIBLE);
            holder.departmentRating.setText("Рейтинг: "+department.score);
            holder.departmentGemersAmount.setText("Игроков: "+department.userCount);
            if(department.isUserBelongs){
                holder.itsMyDepartment.setVisibility(View.VISIBLE);
            }else {
                holder.itsMyDepartment.setVisibility(View.GONE);
            }
        }
        holder.item = item;
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder{
        TextView userName;
        TextView userPosition;
        TextView departmentName;
        View userLayout;
        LinearLayout departmentLayout;
        SearchOrgStructModel item;
        TextView departmentRating;
        TextView departmentGemersAmount;
        TextView itsMyDepartment;
        CircularImageView avatar;

        public ViewHolder(final View itemView, final SearchOrgStructureAdapterOnClickCallback callback) {
            super(itemView);
            userName = (TextView) itemView.findViewById(R.id.card_user_name);
            userPosition = (TextView) itemView.findViewById(R.id.card_user_position);
            departmentName = (TextView) itemView.findViewById(R.id.search_orgstruct_department_name);
            userLayout = (View) itemView.findViewById(R.id.search_orgstruct_user_layout);
            departmentLayout = (LinearLayout) itemView.findViewById(R.id.search_orgstruct_department_layout);
            departmentRating = (TextView) itemView.findViewById(R.id.search_orgstruct_department_rating);
            departmentGemersAmount = (TextView) itemView.findViewById(R.id.search_orgstruct_department_gamers_amount);
            itsMyDepartment = (TextView) itemView.findViewById(R.id.search_orgstruct_department_my);
            departmentLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    callback.searchOrgStructureOnItemClick(item);
                }
            });
            LinearLayout profile = (LinearLayout) itemView.findViewById(R.id.card_user_profile_layout);
            ImageButton gameImage = (ImageButton) itemView.findViewById(R.id.card_user_game_image);
            gameImage.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callback.onGameClick(item.getUserProfile());
                }
            });
            profile.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callback.onProfileClick(item.getUserProfile());
                }
            });
            avatar = (CircularImageView) itemView.findViewById(R.id.user_profile_avatar);
        }
    }
    public interface SearchOrgStructureAdapterOnClickCallback{
        public void searchOrgStructureOnItemClick(SearchOrgStructModel item);
        void onProfileClick(UserProfile user);
        void onGameClick(UserProfile user);
    }
}
