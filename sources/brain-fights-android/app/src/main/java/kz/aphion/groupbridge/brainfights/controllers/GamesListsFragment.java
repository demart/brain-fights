package kz.aphion.groupbridge.brainfights.controllers;

import android.content.Context;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import kz.aphion.groupbridge.brainfights.R;
import kz.aphion.groupbridge.brainfights.adapters.GamesRecycleAdapter;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundStatus;
import kz.aphion.groupbridge.brainfights.models.GamerStatus;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.Status;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserGameModel;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.stores.GamesListsStore;
import kz.aphion.groupbridge.brainfights.tasks.RestTask;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskParams;
import kz.aphion.groupbridge.brainfights.tasks.RestTaskResult;
import kz.aphion.groupbridge.brainfights.utils.Dialogs;

/**
 * Created by alimjan on 09.11.2015.
 */
public class GamesListsFragment extends Fragment implements RestTask.RestTaskCallback, GamesRecycleAdapter.GamesRecycleOnClickCallback, SwipeRefreshLayout.OnRefreshListener {

    RecyclerView rvActive;
    RecyclerView rvWaiting;
    RecyclerView rvFinished;
    TextView waitingLabel;
    TextView endedLabel;
    TextView activeLabel;
    View v;
    RelativeLayout loadingPanel;
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        v =inflater.inflate(R.layout.fragment_my_games, container, false);
        ((SwipeRefreshLayout)v).setOnRefreshListener(this);
        ((SwipeRefreshLayout)v).setColorScheme(R.color.ttk_darkGary, R.color.ttk_green, R.color.ttk_orange, R.color.ttk_red);
        waitingLabel = (TextView) v.findViewById(R.id.waiting_label);
        endedLabel = (TextView) v.findViewById(R.id.ended_label);
        activeLabel = (TextView)v.findViewById(R.id.active_label);
        rvActive = (RecyclerView)v.findViewById(R.id.game_list_active);
        rvWaiting = (RecyclerView)v.findViewById(R.id.games_list_waiting);
        rvFinished = (RecyclerView) v.findViewById(R.id.games_list_finished);
        rvActive.setLayoutManager(new LinearLayoutManager(getActivity()));
        rvActive.setNestedScrollingEnabled(false);
        rvWaiting.setLayoutManager(new LinearLayoutManager(getActivity()));
        rvWaiting.setNestedScrollingEnabled(false);
        rvWaiting.setHasFixedSize(true);
        rvFinished.setLayoutManager(new LinearLayoutManager(getActivity()));
        rvWaiting.setNestedScrollingEnabled(false);
        Button btnNewGame = (Button)v.findViewById(R.id.btn_new_game);
        btnNewGame.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                newGameStart();
            }
        });
        loadingPanel = (RelativeLayout) v.findViewById(R.id.loadingPanel);
        UpdateGamesLists();
        return v;
    }
    public void UpdateGamesLists(){
        loadingPanel.setVisibility(View.VISIBLE);
        RestTask restTask = new RestTask(getContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.UPDATE_GAMES_LIST);
        params.authToken = CurrentUser.getInstance().getAuthToken();
        restTask.execute(params);
    }

    private void LoadDataToList(){
        final GamesListsStore gamesStore = GamesListsStore.getInstance();
        showUnviewedGamesResult(gamesStore);
        if(gamesStore!=null){
            try {
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        final GamesRecycleAdapter rvActiveAdapter = new GamesRecycleAdapter(R.layout.card_game,gamesStore.getActiveGames(), GamesRecycleAdapter.GamesListType.ACTIVE, GamesListsFragment.this, getContext());
                        final GamesRecycleAdapter rvWaitingAdapter = new GamesRecycleAdapter(R.layout.card_game,gamesStore.getWaitingGames(), GamesRecycleAdapter.GamesListType.WAITING, GamesListsFragment.this, getContext());
                        final GamesRecycleAdapter rvFinishedAdapter = new GamesRecycleAdapter(R.layout.card_game,gamesStore.getFinishedGames(), GamesRecycleAdapter.GamesListType.FINISHED, GamesListsFragment.this, getContext());
                        getActivity().runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                if(rvActiveAdapter.getItemCount()>0){
                                    activeLabel.setVisibility(View.VISIBLE);
                                }else {
                                    activeLabel.setVisibility(View.GONE);
                                }
                                rvActive.setAdapter(rvActiveAdapter);
                                setRecycleViewHeight(rvActive);
                                if(rvWaitingAdapter.getItemCount()>0){
                                    waitingLabel.setVisibility(View.VISIBLE);
                                }else {
                                    waitingLabel.setVisibility(View.GONE);
                                }
                                rvWaiting.setAdapter(rvWaitingAdapter);
                                setRecycleViewHeight(rvWaiting);
                                if(rvFinishedAdapter.getItemCount()>0){
                                    endedLabel.setVisibility(View.VISIBLE);
                                }else {
                                    endedLabel.setVisibility(View.GONE);
                                }
                                rvFinished.setAdapter(rvFinishedAdapter);
                                setRecycleViewHeight(rvFinished);

                            }
                        });
                    }
                }).start();
                disableLoadingPanel();

            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }

    private void showUnviewedGamesResult(GamesListsStore gamesStore) {
        for(GameModel game:gamesStore.getUnviewedResultGame()){
            Dialogs.GameEndNotificationDialog(this.getActivity(),game, this);
        }
    }

    private void disableLoadingPanel(){
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                loadingPanel.setVisibility(View.GONE);
                ((SwipeRefreshLayout) v).setRefreshing(false);
            }
        });

    }
    @Override
    public void OnRestTaskComplete(RestTaskResult taskResult) {
        if(taskResult.getTaskType()== RestTask.TaskType.UPDATE_GAMES_LIST){
            if(taskResult.getTaskStatus()== RestTask.TaskStatus.SUCCESS){
                StatusSingle status = (StatusSingle) taskResult.getResponseData();
                if(status.getStatus()== ResponseStatus.SUCCESS){
                    LoadDataToList();
                }
            }else{
                Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                        taskResult.getErrorMessage(), Toast.LENGTH_LONG);
                toast.show();
                disableLoadingPanel();
            }
        }else if(taskResult.getTaskType().equals(RestTask.TaskType.ACCEPT_INVITATION)){
            if(taskResult.getTaskStatus().equals(RestTask.TaskStatus.SUCCESS)){
                StatusSingle<UserGameModel> response = (StatusSingle<UserGameModel>) taskResult.getResponseData();
                if(response.getStatus().equals(ResponseStatus.SUCCESS))
                    openGame(response.getData().id);
                else{
                    Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                            response.getErrorMessage(), Toast.LENGTH_LONG);
                    toast.show();
                    disableLoadingPanel();
                }
            }else{
                Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                        taskResult.getErrorMessage(), Toast.LENGTH_LONG);
                toast.show();
                disableLoadingPanel();
            }
        }
    }

    @Override
    public void setMenuVisibility(boolean menuVisible) {
        super.setMenuVisibility(menuVisible);
    }

    @Override
    public void onHiddenChanged(boolean hidden) {
        super.onHiddenChanged(hidden);
    }

    @Override
    public void setUserVisibleHint(boolean isVisibleToUser) {
        super.setUserVisibleHint(isVisibleToUser);
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void setTargetFragment(Fragment fragment, int requestCode) {
        super.setTargetFragment(fragment, requestCode);
    }

    @Override
    public boolean getUserVisibleHint() {
        return super.getUserVisibleHint();
    }

    @Override
    public void onInflate(Context context, AttributeSet attrs, Bundle savedInstanceState) {
        super.onInflate(context, attrs, savedInstanceState);
    }

    @Override
    public void onViewStateRestored(@Nullable Bundle savedInstanceState) {
        super.onViewStateRestored(savedInstanceState);
    }

    @Override
    public void onPause() {
        super.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();
    }

    private void setRecycleViewHeight(RecyclerView rv){
        int itemCount = rv.getAdapter().getItemCount();
        float dimen = getResources().getDimension(R.dimen.game_card_height);
        float eva = getResources().getDimension(R.dimen.game_card_evaluation);
        int height = (int)Math.ceil(itemCount * (dimen+4*eva));
        LinearLayout.LayoutParams layoutParams = (LinearLayout.LayoutParams) rv.getLayoutParams();
        layoutParams.height = height;
        rv.setLayoutParams(layoutParams);
    }

    private void newGameStart(){
        NewGameChoiceFragment newGameChoiceFragment = new NewGameChoiceFragment();
        FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
        fragmentManager.beginTransaction()
                .add(R.id.container, newGameChoiceFragment)
                .addToBackStack("GameList")
                .commit();
    }
    private void openGame(GameModel game){
        if(game!=null){
            GameFragment gameFragment = new GameFragment();
            gameFragment.gameId = game.id;
            FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
            fragmentManager.beginTransaction()
                    .add(R.id.container, gameFragment)
                    .addToBackStack("GameList")
                    .commit();
        }
    }
    private void openGame(Long gameId){
        if(gameId!=null){
            GameFragment gameFragment = new GameFragment();
            gameFragment.gameId = gameId;
            FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
            fragmentManager.beginTransaction()
                    .add(R.id.container, gameFragment)
                    .addToBackStack("GameList")
                    .commit();
        }
    }
    private void openAlertDialog(String message, String title){
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setMessage(message)
                .setTitle(title);
        builder.setPositiveButton(R.string.close, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {

            }
        });
        AlertDialog dialog = builder.create();
        dialog.show();
    }
    private void acceptInvitation(Long gameId){
        RestTask task = new RestTask(getContext(),this);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.ACCEPT_INVITATION);
        params.authToken = CurrentUser.getInstance().getAuthToken();
        params.gameId = gameId;
        task.execute(params);
    }
    private void openAcceptGameDialog(final GameModel game){
        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        builder.setMessage("Пользователь "+game.oponent.user.getName()+ " бросил вам вызов.")
                .setTitle("Принять вызов");
        builder.setPositiveButton("Принять", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                acceptInvitation(game.id);
            }
        });
        builder.setNegativeButton("Отказаться", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {

            }
        });
        AlertDialog dialog = builder.create();
        dialog.show();
    }
    private void beginAnswer(GameModel game){
        if(game!=null) {
            CategoryFragment categoryFragment = new CategoryFragment();
            categoryFragment.game = game;
            FragmentManager fragmentManager = getActivity().getSupportFragmentManager();
            fragmentManager.beginTransaction()
                    .add(R.id.container, categoryFragment)
                    .addToBackStack("GameList")
                    .commit();
        }
    }

    @Override
    public void onGameClickCallback(GamesRecycleAdapter.GamesListType gamesListType, int gamePosition) {
        GamesListsStore gamesStore = GamesListsStore.getInstance();
        GameModel game;
        if(gamesListType.equals(GamesRecycleAdapter.GamesListType.ACTIVE)){
            game = gamesStore.getActiveGames().get(gamePosition);
            switch (game.me.status){
                case WAITING_OWN_DECISION:
                    openAcceptGameDialog(game);
                    break;
                case WAITING_ROUND:
                    openGame(game);
                    break;
                case WAITING_ANSWERS:
                    openGame(game);
                    break;
                default:
                    Toast toast = Toast.makeText(getActivity().getApplicationContext(),
                            "Неизвестный статус "+game.me.status, Toast.LENGTH_LONG);
                    toast.show();
            }
//
        }else if(gamesListType.equals(GamesRecycleAdapter.GamesListType.WAITING)){
            game = gamesStore.getWaitingGames().get(gamePosition);
            switch (game.me.status){
                case WAITING_OPONENT_DECISION:
                    openAlertDialog("Ожидаем согласия игрока " + game.oponent.user.name, "Ожидание");
                    break;
                case WAITING_OPONENT:
                    openGame(game);
            }
        }else{
            game = gamesStore.getFinishedGames().get(gamePosition);
            openGame(game);
        }

    }

    @Override
    public void onRefresh() {
        UpdateGamesLists();
    }
    public static void UpdateGameList(FragmentManager fragmentManager){
        for(Fragment fragment:fragmentManager.getFragments()){
            if(fragment instanceof GamesListsFragment){
                ((GamesListsFragment) fragment).UpdateGamesLists();
            }
        }
    }
}
