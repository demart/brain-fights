package kz.aphion.groupbridge.brainfights.controllers;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.util.List;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.adapters.GameRoundRecyclerAdapter;
import kz.aphion.groupbridge.brainfights.components.GameUserProfileHelper;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundCategoryModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundQuestionModel;
import kz.aphion.groupbridge.brainfights.models.GameStatus;
import kz.aphion.groupbridge.brainfights.models.GamerStatus;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserType;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.utils.Dialogs;

/**
 * Created by alimjan on 14.11.2015.
 * епта че тут будет 14.11.2015
 */
public class GameFragment extends Fragment implements RestTask.RestTaskCallback, GameRoundRecyclerAdapter.GameRoundCallback, SwipeRefreshLayout.OnRefreshListener {
    public Long gameId= Long.valueOf(-1);
    View v;
    RecyclerView rv;
    GameModel game;
    TextView score;
    GameUserProfileHelper meProfile;
    GameUserProfileHelper opponentProfile;
    RelativeLayout loadingPanel;
    public boolean gameEndNotification;
    Button btnSurrender;
    Button btnFriend;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v =inflater.inflate(R.layout.fragment_game, container, false);
        ((SwipeRefreshLayout)v).setOnRefreshListener(this);
        ((SwipeRefreshLayout)v).setColorScheme(R.color.ttk_darkGary, R.color.ttk_green, R.color.ttk_orange, R.color.ttk_red);
        rv = (RecyclerView)v.findViewById(R.id.game_round_list);
        rv.setLayoutManager(new LinearLayoutManager(getActivity()));
        loadingPanel = (RelativeLayout) v.findViewById(R.id.loadingPanel);
        loadingPanel.setVisibility(View.VISIBLE);
        score = (TextView) v.findViewById(R.id.game_score_text);
        meProfile = new GameUserProfileHelper(v.findViewById(R.id.game_me_profile_layout));
        opponentProfile = new GameUserProfileHelper(v.findViewById(R.id.game_opponent_profile_layout));
        Button btnGame = (Button) v.findViewById(R.id.game_game_button);
        btnGame.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                gameClick();
            }
        });
        btnSurrender = (Button)v.findViewById(R.id.game_surrend_button);
        btnSurrender.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                surrenderGame();
            }
        });
        btnFriend = (Button)v.findViewById(R.id.game_friend_button);
        btnFriend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setFriendlyStatus();
            }
        });
        LoadGameInfo();

        return v;
    }

    private void setFriendlyStatus() {
        if(game!=null&&game.oponent!=null&&game.oponent.user.getType()!=null){
            RestTask task = new RestTask(getContext(),this);
            RestTaskParams params;
            if(game.oponent.user.getType().equals(UserType.FRIEND)){
                params = new RestTaskParams(RestTask.TaskType.REMOVE_FRIEND);
            }else{
                params = new RestTaskParams(RestTask.TaskType.ADD_FRIEND);
            }
            params.userId = game.oponent.user.id;
            params.authToken = CurrentUser.getInstance().getAuthToken();
            task.execute(params);
        }
    }

    private void surrenderGame() {
        RestTask task = new RestTask(getContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.SURRENDER_GAME);
        params.gameId = gameId;
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }

    private void LoadGameInfo(){
        RestTask task = new RestTask(getActivity().getApplicationContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.GET_GAME_INFORMATION);
        params.gameId = gameId;
        params.authToken = CurrentUser.getInstance().getAuthToken();
        task.execute(params);
    }
    private void setScore(){
        if(game!=null&&game.me!=null&&game.oponent!=null){
            score.setText(game.me.correctAnswerCount+" : "+game.oponent.correctAnswerCount);
        }else{
            score.setText("0 : 0");
        }
    }
    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType().equals(RestTask.TaskType.GET_GAME_INFORMATION)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                StatusSingle<GameModel> response = (StatusSingle<GameModel>) taskResult.getResponseData();
                if(response.getStatus().equals(ResponseStatus.SUCCESS)){
                    GameModel oldGame=game;
                    this.game = response.getData();
                    setScore();
                    meProfile.setData(game.me.user);
                    opponentProfile.setData(game.oponent.user);
                    updateRoundList();
//                    if(oldGame!=null){
//                        if(oldGame!=null&&game!=null&&
//                                (game.me.status.equals(GamerStatus.WINNER)||game.me.status.equals(GamerStatus.DRAW)||game.me.status.equals(GamerStatus.LOOSER)||game.me.status.equals(GamerStatus.SURRENDED)||game.me.status.equals(GamerStatus.OPONENT_SURRENDED))
//                                &&!(oldGame.me.status.equals(GamerStatus.WINNER)||oldGame.me.status.equals(GamerStatus.DRAW)||oldGame.me.status.equals(GamerStatus.LOOSER)||oldGame.me.status.equals(GamerStatus.SURRENDED)||oldGame.me.status.equals(GamerStatus.OPONENT_SURRENDED))){
                        if(!game.me.resultWasViewed)
                        getActivity().runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    Dialogs.GameEndNotificationDialog(getActivity(), game, GameFragment.this);
                                }
                            });
//                        }
//                    }
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            ((SwipeRefreshLayout) v).setRefreshing(false);
                            if (game.me.status.equals(GamerStatus.WINNER) || game.me.status.equals(GamerStatus.DRAW) || game.me.status.equals(GamerStatus.LOOSER) || game.me.status.equals(GamerStatus.SURRENDED) || game.me.status.equals(GamerStatus.OPONENT_SURRENDED)) {
                                btnSurrender.setAlpha(0);
                                btnSurrender.setEnabled(false);
                            } else {
                                btnSurrender.setAlpha(1);
                                btnSurrender.setEnabled(true);
                            }
                            if (!game.oponent.user.getType().equals(UserType.FRIEND)) {
                                btnFriend.setText("Добавить в друзья");
                            } else {
                                btnFriend.setText("Удалить из друзей");
                            }
                        }
                    });
//                    if(gameEndNotification){
//                        //TODO: Уведомление о конце игры
//                        getActivity().runOnUiThread(new Runnable() {
//                            @Override
//                            public void run() {
//                                Dialogs.GameEndNotificationDialog(getActivity(), game);
//                            }
//                        });
//                    }
                }
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.ADD_FRIEND)) {
            if (taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)) {
                StatusSingle<GameModel> response = (StatusSingle<GameModel>) taskResult.getResponseData();
                if (response.getStatus().equals(ResponseStatus.SUCCESS)) {
                    LoadGameInfo();
                    Toast.makeText(getActivity().getApplicationContext(),
                            "Пользователь "+game.oponent.user.getName()+" добавлен в друзья", Toast.LENGTH_LONG).show();
                }
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.REMOVE_FRIEND)){
            if (taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)) {
                StatusSingle<GameModel> response = (StatusSingle<GameModel>) taskResult.getResponseData();
                if (response.getStatus().equals(ResponseStatus.SUCCESS)) {
                    LoadGameInfo();
                    Toast.makeText(getActivity().getApplicationContext(),
                            "Пользователь "+game.oponent.user.getName()+" удален из друзей", Toast.LENGTH_LONG).show();
                }
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.SURRENDER_GAME)){
            if (taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)) {
                StatusSingle<GameModel> response = (StatusSingle<GameModel>) taskResult.getResponseData();
                if (response.getStatus().equals(ResponseStatus.SUCCESS)) {
                    LoadGameInfo();
                }
            }
        }
    }

    private void updateRoundList() {
        try {
            new Thread(new Runnable() {
                @Override
                public void run() {
                    final GameRoundRecyclerAdapter rvAdapter = new GameRoundRecyclerAdapter(R.layout.card_game_round,game,GameFragment.this, rv.getMeasuredHeight());
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            rv.setAdapter(rvAdapter);
                            loadingPanel.setVisibility(View.GONE);
                        }
                    });
                }
            }).start();


        }catch (Exception e){
            e.printStackTrace();
        }
    }
    private void openChooseCategoryFragment(List<GameRoundCategoryModel> categories){

    }
    private void gameClick(){
        FragmentManager fragmentManager;
        switch (game.me.status){
            case WAITING_ROUND:
                CategoryChoiceQuizFragment cqf = new CategoryChoiceQuizFragment();
                cqf.categories = game.categories;
                cqf.gameId = gameId;
                cqf.game = game;
                fragmentManager = getActivity().getSupportFragmentManager();
                fragmentManager.beginTransaction()
                        .add(R.id.container, cqf)
                        //.addToBackStack(null)
                        .commit();
                break;
            case WAITING_ANSWERS:
                CategoryFragment categoryFragment = new CategoryFragment();
                categoryFragment.game = game;
                categoryFragment.round = categoryFragment.findActualRound(game);
                categoryFragment.fromGame=true;
                fragmentManager = getActivity().getSupportFragmentManager();
                fragmentManager.beginTransaction()
                        .replace(R.id.container, categoryFragment)
                        //.addToBackStack(null)
                        .commit();
                break;
        }
    }


    @Override
    public void onQuizClick(GameRoundQuestionModel quiz) {
        Dialogs.ViewQuizNotificationDialog(getActivity(), quiz);
    }

    @Override
    public void onGameButtonClick() {
        gameClick();
    }

    @Override
    public void onRefresh() {
        LoadGameInfo();

    }
}
