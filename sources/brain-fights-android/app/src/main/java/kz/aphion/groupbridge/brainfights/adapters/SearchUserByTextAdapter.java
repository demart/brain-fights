package kz.aphion.groupbridge.brainfights.adapters;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.models.UserType;

/**
 * Created by alimjan on 13.11.2015.
 */
public class SearchUserByTextAdapter {
//    int layout;
//    UserProfile[] items;
//    SearchUserByTextAdapterrOnClickCallback callback;
//
//    public SearchUserByTextAdapter(int layout, UserProfile[] items, SearchUserByTextAdapterrOnClickCallback callback){
//        this.layout = layout;
//        this.items = items;
//        this.callback = callback;
//    }
//    @Override
//    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
//        View v = LayoutInflater.from(parent.getContext()).inflate(layout, parent, false);
//        return new ViewHolder(v, callback);
//    }
//
//    @Override
//    public void onBindViewHolder(ViewHolder holder, int position) {
//        UserProfile user = items[position];
//            holder.departmentLayout.setVisibility(View.GONE);
//            if(user.getType().equals(UserType.ME))
//                holder.userName.setText("ВЫ ("+user.getName()+")");
//            else
//                holder.userName.setText(user.getName());
//            holder.userPosition.setText(user.getPosition());
//
//
//        holder.item = user;
//    }
//
//    @Override
//    public int getItemCount() {
//        return items.length;
//    }
//
//    public static class ViewHolder extends RecyclerView.ViewHolder{
//        TextView userName;
//        TextView userPosition;
//        TextView departmentName;
//        LinearLayout userLayout;
//        LinearLayout departmentLayout;
//        UserProfile item;
//
//        public ViewHolder(View itemView, final SearchUserByTextAdapterrOnClickCallback callback) {
//            super(itemView);
//            userName = (TextView) itemView.findViewById(R.id.search_orgstruct_user_name);
//            userPosition = (TextView) itemView.findViewById(R.id.search_orgstruct_user_position);
//            departmentName = (TextView) itemView.findViewById(R.id.search_orgstruct_department_name);
//            userLayout = (LinearLayout) itemView.findViewById(R.id.search_orgstruct_user_layout);
//            departmentLayout = (LinearLayout) itemView.findViewById(R.id.search_orgstruct_department_layout);
//            itemView.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View view) {
//                    callback.searchUserByTextOnItemClick(item);
//                }
//            });
//        }
//    }
//    public interface SearchUserByTextAdapterrOnClickCallback{
//        public void searchUserByTextOnItemClick(UserProfile item);
//    }
}
