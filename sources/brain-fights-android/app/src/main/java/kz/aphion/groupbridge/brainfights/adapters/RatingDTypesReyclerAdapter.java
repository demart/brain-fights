package kz.aphion.groupbridge.brainfights.adapters;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.w3c.dom.Text;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.DepartmentTypeModel;

/**
 * Created by alimjan on 13.12.2015.
 */
public class RatingDTypesReyclerAdapter extends RecyclerView.Adapter<RatingDTypesReyclerAdapter.ViewHolder>  {


    private final RatingDTypesReyclerAdapterCallback callback;
    private final int layout;
    private final DepartmentTypeModel[] types;
    private final Context context;

    public RatingDTypesReyclerAdapter(int layout, DepartmentTypeModel[] types, RatingDTypesReyclerAdapterCallback callback, Context context){
        this.layout = layout;
        this.types = types;
        this.callback = callback;
        this.context = context;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(layout, parent, false);
        return new ViewHolder(v, callback, context);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        DepartmentTypeModel type = types[position];
        holder.type = type;
        holder.name.setText(type.name);
    }

    @Override
    public int getItemCount() {
        return types.length;
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        public TextView name;
        public DepartmentTypeModel type;
        public ViewHolder(View itemView, final RatingDTypesReyclerAdapterCallback callback, final Context context) {
            super(itemView);
            name = (TextView) itemView.findViewById(R.id.rating_departments_type_name);
            LinearLayout layout = (LinearLayout) itemView.findViewById(R.id.rating_departments_type_card_layout);
            layout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Animation anim = AnimationUtils.loadAnimation(
                            context, android.R.anim.fade_in
                    );
                    anim.setDuration(500);
                    v.startAnimation(anim);
                    callback.onRatingDTypesItemClick(type);
                }
            });
        }
    }

    public interface RatingDTypesReyclerAdapterCallback{
        void onRatingDTypesItemClick(DepartmentTypeModel type);
    }
}
