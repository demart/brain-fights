package kz.aphion.groupbridge.brainfights.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.Department;

/**
 * Created by alimjan on 13.12.2015.
 */
public class RatingDepartmentRecyclerAdapter extends RecyclerView.Adapter<RatingDepartmentRecyclerAdapter.ViewHolder> {


    private final int layout;
    private List<Department> departments;
    private final RatingDepartmentRecyclerAdapterCallback callback;
    Context context;

    public RatingDepartmentRecyclerAdapter(int layout, List<Department> departments, RatingDepartmentRecyclerAdapterCallback callback, Context context){
        this.layout = layout;
        this.departments = departments;
        this.callback = callback;
        this.context = context;
    }
    public void addRows(List<Department> rows){
        departments.addAll(rows);
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(layout, parent, false);
        return new ViewHolder(v, callback);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        Department department = departments.get(position);
        holder.dName.setText(department.name);
        String gamersAmontText = "Количество игроков: <font color=#E46C0A>"+department.userCount+"</font>";
        holder.gamersAmount.setText(Html.fromHtml(gamersAmontText));
        if(department.isUserBelongs){
            holder.itsMy.setAlpha(1);
        }else holder.itsMy.setAlpha(0);
        holder.place.setText(String.valueOf(department.position));
//        holder.placeChange.setText();
        if(department.position-department.lastPosition>=0){
            holder.placeChange.setText("(+"+(department.position-department.lastPosition)+")");
            holder.placeChange.setTextColor(context.getResources().getColor(R.color.ttk_green));
        }else {
            holder.placeChange.setText("("+department.lastPosition+")");
            holder.placeChange.setTextColor(context.getResources().getColor(R.color.ttk_red));
        }
        holder.score.setText(String.valueOf(department.score));
        if(department.score-department.lastScore>=0){
            holder.scoreChange.setText("(+"+(department.score-department.lastScore)+")");
            holder.scoreChange.setTextColor(context.getResources().getColor(R.color.ttk_green));
        }else{
            holder.scoreChange.setText("("+(department.score-department.lastScore)+")");
            holder.scoreChange.setTextColor(context.getResources().getColor(R.color.ttk_red));
        }
        holder.department = department;
        if(position%2>0)holder.layout.setBackgroundColor(context.getResources().getColor(R.color.ttk_row_bg));
    }

    @Override
    public int getItemCount() {
        return departments.size();
    }

    public void clear() {
        departments = new ArrayList<Department>();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {

        TextView itsMy;
        TextView place;
        TextView placeChange;
        TextView dName;
        TextView gamersAmount;
        TextView score;
        TextView scoreChange;
        ImageView toDepart;
        Department department;
        LinearLayout layout;
        public ViewHolder(View itemView, final RatingDepartmentRecyclerAdapterCallback callback) {
            super(itemView);
            itsMy = (TextView) itemView.findViewById(R.id.rating_department_it_my_label);
            place = (TextView) itemView.findViewById(R.id.rating_department_place);
            placeChange = (TextView) itemView.findViewById(R.id.rating_department_place_change);
            dName = (TextView) itemView.findViewById(R.id.rating_department_name);
            gamersAmount = (TextView) itemView.findViewById(R.id.rating_department_games_amount);
            score = (TextView)itemView.findViewById(R.id.rating_department_score);
            scoreChange = (TextView) itemView.findViewById(R.id.rating_department_score_change);
            toDepart = (ImageView) itemView.findViewById(R.id.rating_department_to_depart);
            layout = (LinearLayout) itemView.findViewById(R.id.card_layout);
            toDepart.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    callback.onItemClick(department);
                }
            });
        }
    }

    public interface RatingDepartmentRecyclerAdapterCallback{
        void onItemClick(Department department);
    }
}
