package kz.aphion.groupbridge.brainfights.services;

import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;

import java.util.ArrayList;
import java.util.Date;

import kz.aphion.groupbridge.brainfights.models.AuthorizationRequestModel;
import kz.aphion.groupbridge.brainfights.models.AuthorizationResponseModel;
import kz.aphion.groupbridge.brainfights.models.Department;
import kz.aphion.groupbridge.brainfights.models.DepartmentTypeModel;
import kz.aphion.groupbridge.brainfights.models.DepartmentTypes;
import kz.aphion.groupbridge.brainfights.models.Departments;
import kz.aphion.groupbridge.brainfights.models.Friends;
import kz.aphion.groupbridge.brainfights.models.GameModel;
import kz.aphion.groupbridge.brainfights.models.GameRoundModel;
import kz.aphion.groupbridge.brainfights.models.GamerQuestionAnswerResultModel;
import kz.aphion.groupbridge.brainfights.models.Games;
import kz.aphion.groupbridge.brainfights.models.ResponseStatus;
import kz.aphion.groupbridge.brainfights.models.Status;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserGameModel;
import kz.aphion.groupbridge.brainfights.models.UserList;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.models.Users;
import kz.aphion.groupbridge.brainfights.stores.CurrentUser;
import kz.aphion.groupbridge.brainfights.stores.CurrentUserProfile;
import kz.aphion.groupbridge.brainfights.stores.FriendsStore;
import kz.aphion.groupbridge.brainfights.stores.GamesListsStore;
import kz.aphion.groupbridge.brainfights.utils.Const;

/**
 * Created by alimjan on 02.11.2015.
 */
public class RestServiceHelper{

    public StatusSingle<AuthorizationResponseModel> authenticate(Context context,AuthorizationRequestModel authorizationRequest){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
            StatusSingle<AuthorizationResponseModel> authorizationResponseStatus = brainFightsApi.authenticate(authorizationRequest);

            if(authorizationResponseStatus.getStatus()== ResponseStatus.SUCCESS){
                CurrentUser currentUser = CurrentUser.getInstance();
                if(currentUser!=null){
                    currentUser.setAuthToken(authorizationResponseStatus.getData().authToken);
                    currentUser.setLogin(authorizationRequest.login);
                    CurrentUserProfile.init(authorizationResponseStatus.getData().userProfile, context);
                }
                return authorizationResponseStatus;
            }
        return authorizationResponseStatus;
    }
    public StatusSingle<GameModel> getGameInformation(Context context, Long gameId, String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
        Date d1 = new Date();
        StatusSingle<GameModel> response = brainFightsApi.getGameInformation(gameId,authToken);
        checkAnswer(response, context);
        System.out.println("Execution time = "+((new Date()).getTime()-d1.getTime()));
        System.out.println(response.getStatus());
        return response;
    }
    public StatusSingle<UserProfile> getUserProfile(Context context,String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
        StatusSingle<UserProfile> response = brainFightsApi.getUserProfile(authToken);
        checkAnswer(response, context);
        if(response.getStatus()==ResponseStatus.SUCCESS){
            CurrentUserProfile.init(response.getData(), context);
        }else{
            CurrentUser currentUser = CurrentUser.getInstance();
            if(currentUser!=null){
                currentUser.removeAuthToken();
            }
        }

        return response;
    }
    public StatusSingle<Games> getGamesList(Context context,String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
        StatusSingle<Games> response = brainFightsApi.getGamesList(authToken);
        checkAnswer(response, context);
        if(response.getStatus()==ResponseStatus.SUCCESS){
            GameModel[] gameList = response.getData().getGames();
            GamesListsStore.updateGamesList(gameList);
        }
        return response;
    }
    public StatusSingle<GameModel> createRandomGame(Context context,String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
        StatusSingle<GameModel> response = brainFightsApi.createRandomGame(authToken);
        checkAnswer(response, context);
        if(response.getStatus().equals(ResponseStatus.SUCCESS)){
            GameModel game = response.getData();
            GamesListsStore.getInstance().getWaitingGames().add(game);
        }
        return response;
    }
    public StatusSingle<Friends> getFriendsList(Context context,String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
        StatusSingle<Friends> response = brainFightsApi.getFriendsList(authToken);
        checkAnswer(response, context);
        if(response!=null&&response.getStatus()!=null&&response.getStatus().equals(ResponseStatus.SUCCESS)){
            if(response.getData()!=null)
                FriendsStore.init(response.getData().getFriends());
        }
        return response;
    }
    public StatusSingle<Departments> getRootDepartments(Context context,String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
        StatusSingle<Departments> response =  brainFightsApi.getRootDepartments(authToken);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<Departments> getDepartmentsByParent(Context context, Long parentId, String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
        StatusSingle<Departments>  response = brainFightsApi.getDepartmentsByParent(parentId, authToken);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<UserList> searchUserByText(Context context,String authToken, String searchText){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi =restClient.getBrainFightsApi();
        StatusSingle<UserList>  response = brainFightsApi.searchUserByText(authToken, searchText);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<UserGameModel> createInvitation(Context context, String authToken, Long userId){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        StatusSingle<UserGameModel>  response = brainFightsApi.createInvitation(authToken, userId);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<UserGameModel> acceptInvitation(Context context, String authToken, Long gameId){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        StatusSingle<UserGameModel> response = brainFightsApi.acceptInvitation(authToken, gameId);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<GameRoundModel> generateNewRound(Context context, Long gameId , Long categoryId, String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        StatusSingle<GameRoundModel>  response = brainFightsApi.generateNewRound(gameId, categoryId, authToken);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<GamerQuestionAnswerResultModel> setAnswer(Context context, Long gameId ,Long roundId, Long questionId,Long answerId, String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        StatusSingle<GamerQuestionAnswerResultModel>  response = brainFightsApi.setAnswer(gameId, roundId, questionId, answerId, authToken);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<GameModel> surrenderGame(Context context, Long gameId, String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        StatusSingle<GameModel> response = brainFightsApi.surrenderGame(gameId, authToken);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle addFriend(Context context, Long userId,  String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        StatusSingle response =  brainFightsApi.addFriend(userId, authToken);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle removeFriend(Context context, Long userId, String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        StatusSingle response = brainFightsApi.removeFriend(userId, authToken);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<GameModel> setAsViewedGameResult(Context context, Long gameId, Long gamerId,  String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        StatusSingle<GameModel> response = brainFightsApi.setAsViewedGameResult(gameId, gamerId, authToken);
        checkAnswer(response, context);
        return response;
    }
    public Status<DepartmentTypeModel> getDepartmentsTypes(Context context, String authToken){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        Status<DepartmentTypeModel> response = brainFightsApi.getDepartmentsTypes(authToken);
        checkAnswer(response, context);
        return response;
    }
    public Status<Department> getDepartmentsStatistic(Context context, Long departmentTypeId, Integer page, Integer limit, String authToken ){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        Status<Department> response = brainFightsApi.getDepartmentsStatistic(departmentTypeId, page, limit, authToken);
        checkAnswer(response, context);
        return response;
    }
    public StatusSingle<Users> getUsersRating(Context context, Integer page, Integer limit,String authToken ){
        RestClient restClient = new RestClient();
        BrainFightsApi brainFightsApi = restClient.getBrainFightsApi();
        Status<UserProfile> res = brainFightsApi.getUsersRating(page, limit, authToken);
        StatusSingle<Users> response = new StatusSingle<>();
        if(res.getData()!=null) {
            Users users = new Users();
            users.users = new ArrayList<>();
            for (UserProfile user : res.getData()) users.users.add(user);
            response.setData(users);
        }
        response.setStatus(res.getStatus());
        response.setErrorCode(res.getErrorCode());
        response.setErrorMessage(res.getErrorMessage());
        checkAnswer(response, context);
        return response;
    }
    private void checkAnswer(StatusSingle responseStatus, Context context){
        if(responseStatus!=null){
            switch (responseStatus.getStatus()){
                case SUCCESS:
                    return;
                case AUTHORIZATION_ERROR:
                    broadcastUnauthorized(context);
                    return;
                case BAD_REQUEST:
                    //TODO: Сделать обработку
                    return;
                case NO_CONTENT:
                    //TODO: Сделать обработку
                    return;
                case SERVER_ERROR:
                    //TODO: Сделать обработку
                    return;
            }
        }
    }
    private void checkAnswer(Status responseStatus, Context context){
        if(responseStatus!=null){
            switch (responseStatus.getStatus()){
                case SUCCESS:
                    return;
                case AUTHORIZATION_ERROR:
                    broadcastUnauthorized(context);
                    return;
                case BAD_REQUEST:
                    //TODO: Сделать обработку
                    return;
                case NO_CONTENT:
                    //TODO: Сделать обработку
                    return;
                case SERVER_ERROR:
                    //TODO: Сделать обработку
                    return;
            }
        }
    }

    private void broadcastUnauthorized(Context context) {
        Intent intent = new Intent();
        intent.setAction(Const.BM_USER_UNAUTHTORIZED);
        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
    }
}
