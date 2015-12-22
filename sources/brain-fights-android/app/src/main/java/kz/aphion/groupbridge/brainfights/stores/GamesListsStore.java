package kz.aphion.groupbridge.brainfights.stores;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameStatus;
import kz.aphion.groupbridge.brainfights.models.GamerStatus;

/**
 * Created by alimjan on 09.11.2015.
 */
public class GamesListsStore {
    private List<GameModel> activeGames;
    private List<GameModel> waitingGames;
    private List<GameModel> finishedGames;

    private GamesListsStore(){
        activeGames = new ArrayList<GameModel>();
        waitingGames = new ArrayList<GameModel>();
        finishedGames = new ArrayList<GameModel>();
    };
    private static GamesListsStore instance = new GamesListsStore();
    public static void updateGamesList(GameModel[] games){
        synchronized (instance) {
            instance = new GamesListsStore(games);
        }
    }
    public static GamesListsStore getInstance(){
        return instance;
    }
    private GamesListsStore(GameModel[] listGames){
        activeGames = new ArrayList<GameModel>();
        waitingGames = new ArrayList<GameModel>();
        finishedGames = new ArrayList<GameModel>();
        for(GameModel game:listGames){
            switch (game.status){
                case WAITING:
                    switch (game.me.status){
                        case WAITING_OPONENT_DECISION:
                            waitingGames.add(game);
                            break;
                        case WAITING_OWN_DECISION:
                            activeGames.add(game);
                            break;
                        case WAITING_OPONENT:
                            waitingGames.add(game);
                            break;
                        case WAITING_ROUND:
                            activeGames.add(game);
                            break;
                        case WAITING_ANSWERS:
                            activeGames.add(game);
                    }
                    break;
                case STARTED:
                    switch (game.me.status){
                        case WAITING_OPONENT_DECISION:
                            waitingGames.add(game);
                            break;
                        case WAITING_OWN_DECISION:
                            activeGames.add(game);
                            break;
                        case WAITING_OPONENT:
                            waitingGames.add(game);
                            break;
                        case WAITING_ROUND:
                            activeGames.add(game);
                            break;
                        case WAITING_ANSWERS:
                            activeGames.add(game);
                    }
                    break;
                case FINISHED:
                    finishedGames.add(game);
            }
        }
    }
    public List<GameModel> getUnviewedResultGame(){
        List<GameModel> games = new ArrayList<>();
        games.addAll(findUnviewedResultGame(activeGames));
        games.addAll(findUnviewedResultGame(waitingGames));
        games.addAll(findUnviewedResultGame(finishedGames));
        return games;
    }
    private List<GameModel> findUnviewedResultGame(List<GameModel> list){
        List<GameModel> r = new ArrayList<>();
        for(GameModel game:list){
            if(!game.me.resultWasViewed){
               r.add(game);
            }
        }
        return r;
    }
    public List<GameModel> getActiveGames() {
        return activeGames;
    }

    public List<GameModel> getWaitingGames() {
        return waitingGames;
    }

    public List<GameModel> getFinishedGames() {
        return finishedGames;
    }
}
