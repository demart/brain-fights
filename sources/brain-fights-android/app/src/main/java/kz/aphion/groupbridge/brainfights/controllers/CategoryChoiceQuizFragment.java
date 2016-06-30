package kz.aphion.groupbridge.brainfights.controllers;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;

import java.io.UnsupportedEncodingException;
import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundCategoryModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundModel;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.utils.Const;
import kz.aphion.groupbridge.brainfights.utils.Util;

/**
 * Created by alimjan on 29.11.2015.
 */
public class CategoryChoiceQuizFragment extends Fragment implements RestTask.RestTaskCallback {
    List<GameRoundCategoryModel> categories;
    Long gameId;
    GameModel game;
    View v;
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_choice_category_quiz, container, false);
        LinearLayout c1Layout = (LinearLayout) v.findViewById(R.id.category_quiz_c1_layout);
        LinearLayout c2Layout = (LinearLayout) v.findViewById(R.id.category_quiz_c2_layout);
        LinearLayout c3Layout = (LinearLayout) v.findViewById(R.id.category_quiz_c3_layout);
        TextView c1Text = (TextView) v.findViewById(R.id.category_quiz_c1_text);
        TextView c2Text = (TextView) v.findViewById(R.id.category_quiz_c2_text);
        TextView c3Text = (TextView) v.findViewById(R.id.category_quiz_c3_text);
        if(categories!=null&&categories.size()==3){
            setCategoryToView(categories.get(0),c1Text,c1Layout, 0);
            setCategoryToView(categories.get(1),c2Text,c2Layout, 1);
            setCategoryToView(categories.get(2), c3Text, c3Layout, 2);
        }
        return v;
    }

    private void setCategoryToView(GameRoundCategoryModel category, TextView textView, LinearLayout layout, final int position){
        textView.setText(category.name);
        if(category.imageUrl!=null){
            Picasso.with(getContext()).load(Const.BASE_URL+category.imageUrl).into(Util.getTargetLayoutBg(layout));
        }else if(category.imageUrlBase64!=null){
            try {
                Picasso.with(getContext()).load(Const.BASE_URL+new String(Base64.decode(category.imageUrl, Base64.DEFAULT), "UTF-8")).into(Util.getTargetLayoutBg(layout));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }else{
            //TODO: загрузка цвета
        }
        layout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                chooseCategory(position);
            }
        });
    }

    private void chooseCategory(int position){
        GameRoundCategoryModel category = categories.get(position);
        RestTask task = new RestTask(getContext(), this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.GENERATE_ROUND);
        params.gameId = gameId;
        params.categoryId = category.id;
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }
    public List<GameRoundCategoryModel> getCategories() {
        return categories;
    }

    public void setCategories(List<GameRoundCategoryModel> categories) {
        this.categories = categories;
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
          if(taskResult.getTaskType().equals(RestTask.TaskType.GENERATE_ROUND)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                StatusSingle<GameRoundModel> response = (StatusSingle<GameRoundModel>) taskResult.getResponseData();
                if(response.getStatus().equals(ResponseStatus.SUCCESS)) {

                    CategoryFragment categoryFragment = new CategoryFragment();
                    categoryFragment.setRound(response.getData());
                    categoryFragment.game=game;
                    FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
                    fragmentManager.beginTransaction()
                            .add(R.id.flContent, categoryFragment)
                            .commit();
                }
                else{
                    Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                            response.getErrorMessage(), Toast.LENGTH_LONG);
                    toast.show();
                }
            }
        }
    }
}
