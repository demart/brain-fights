package kz.aphion.groupbridge.brainfights.controllers;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import java.io.UnsupportedEncodingException;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundCategoryModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundStatus;
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
public class CategoryFragment extends Fragment implements RestTask.RestTaskCallback {
    GameModel game=null;
    GameRoundModel round=null;
    boolean fromGame=false;
    View v;
    RelativeLayout loadingPanel;
    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v = inflater.inflate(R.layout.fragment_category, container, false);
        loadingPanel = (RelativeLayout) v.findViewById(R.id.loadingPanel);
        if(round!=null)
        setCategoryView();
        else loadFromGame();
        return v;
    }

    public GameRoundModel findActualRound(GameModel game){
        if(game!=null&&game.gameRounds!=null)
            for(GameRoundModel roundModel:game.gameRounds){
                if(roundModel.status.equals(GameRoundStatus.WAITING_ANSWER)){
                    return roundModel;
                }
            }
        return null;
    }
    private void loadFromGame() {
        loadingPanel.setVisibility(View.VISIBLE);
        RestTask task = new RestTask(getContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.GET_GAME_INFORMATION);
        params.gameId = game.id;
        params.authToken= CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }

    private void setCategoryView(){
        if(round!=null){
            GameRoundCategoryModel category = round.category;
            if(category!=null){
                TextView name = (TextView) v.findViewById(R.id.category_quiz_text);
                name.setText(category.name);
                RelativeLayout layout = (RelativeLayout) v.findViewById(R.id.category_quiz_layout);
                ImageView categoryImage = (ImageView)v.findViewById(R.id.category_quiz_image);
                if(category.imageUrl!=null){
                    Picasso.with(getContext()).load(Const.BASE_URL+category.imageUrl).into(categoryImage);
                }else if(category.imageUrlBase64!=null){
                    try {
                        Picasso.with(getContext()).load(new String(Base64.decode(category.imageUrlBase64, Base64.DEFAULT), "UTF-8")).into(categoryImage);
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                }else{
                    //TODO: загрузка цвета
                }
                layout.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        beginAnswer();
                    }
                });
            }
        }
    }

    private void beginAnswer(){
        QuizFragment quizFragment = new QuizFragment();
        quizFragment.round=round;
        quizFragment.game = game;
        quizFragment.fromGame=true;
        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .add(R.id.flContent, quizFragment)
                .commit();
    }

    public GameRoundModel getRound() {
        return round;
    }

    public void setRound(GameRoundModel round) {
        this.round = round;
    }

    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        loadingPanel.setVisibility(View.GONE);
        if(taskResult.getTaskType()== RestTask.TaskType.GET_GAME_INFORMATION){
            if(taskResult.getTaskStatus()== RestTask.TaskStatus.SUCCESS){
                StatusSingle<GameModel> status = (StatusSingle) taskResult.getResponseData();
                if(status.getStatus()== ResponseStatus.SUCCESS){
                    round = findActualRound(status.getData());
                    setCategoryView();
                }
            }
        }
    }
}
