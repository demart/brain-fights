package kz.aphion.groupbridge.brainfights.tasks;

import android.content.Context;
import android.os.AsyncTask;

import java.io.IOException;
import java.net.UnknownHostException;

import kz.aphion.groupbridge.brainfights.models.AuthorizationRequestModel;
import kz.aphion.groupbridge.brainfights.models.AuthorizationResponseModel;
import kz.aphion.groupbridge.brainfights.models.Status;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.services.RestServiceHelper;
import retrofit.RetrofitError;


/**
 * Created by alimjan on 02.11.2015.
 */
public class RestTask extends AsyncTask<RestTaskParams,Void,RestTaskResult> {

    Exception e;
    RestTaskCallback callback;
    Context context;



    public RestTask(Context context, RestTaskCallback callback){
        this.callback=callback;
        this.context = context;
    }

    @Override
    protected RestTaskResult doInBackground(RestTaskParams... taskParamses) {
        RestTaskResult taskResult = new RestTaskResult();
        if(taskParamses!=null&&taskParamses.length>0){
            RestTaskParams params = taskParamses[0];
            if(params!=null) {
                taskResult.setTaskType(params.taskType);
                RestServiceHelper serviceHelper = new RestServiceHelper();
                switch (params.taskType){
                    case AUTHENTICATE:
                        try {
                            StatusSingle<AuthorizationResponseModel> authorizationResponse = serviceHelper.authenticate(context, params.authorizationRequest);
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                            taskResult.setResponseData(authorizationResponse);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }

                        break;
                    case  GET_GAME_INFORMATION:

                        try {
                            taskResult.setResponseData(serviceHelper.getGameInformation(context, params.gameId, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case GET_CURRENT_USER_PROFILE:
                        try {
                            StatusSingle<UserProfile> userProfileStatusSingle = serviceHelper.getUserProfile(context, params.authToken);
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                            taskResult.setResponseData(userProfileStatusSingle);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case UPDATE_GAMES_LIST:
                        try {
                            taskResult.setResponseData(serviceHelper.getGamesList(context, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case LOAD_FRIEND_LIST:
                        try {
                            taskResult.setResponseData(serviceHelper.getFriendsList(context, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case START_NEW_RANDOM_GAME:
                        try{
                            taskResult.setResponseData(serviceHelper.createRandomGame(context, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case LOAD_ROOT_DEPARTMENTS:
                        try{
                            taskResult.setResponseData(serviceHelper.getRootDepartments(context, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case LOAD_DEPARTMETS_BY_PARENT:
                        try{
                            taskResult.setResponseData(serviceHelper.getDepartmentsByParent(context, params.parentId, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case SEARCH_USER_BY_TEXT:
                        try{
                            taskResult.setResponseData(serviceHelper.searchUserByText(context, params.authToken, params.searchText));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case CREATE_INVITATION:
                        try{
                            taskResult.setResponseData(serviceHelper.createInvitation(context, params.authToken, params.userId));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case ACCEPT_INVITATION:
                        try{
                            taskResult.setResponseData(serviceHelper.acceptInvitation(context, params.authToken, params.gameId));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case GENERATE_ROUND:
                        try{
                            taskResult.setResponseData(serviceHelper.generateNewRound(context, params.gameId, params.categoryId, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case SET_ANSWER:
                        try{
                            taskResult.setResponseData(serviceHelper.setAnswer(context, params.gameId, params.roundId, params.questionId, params.answerId, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case SURRENDER_GAME:
                        try{
                            taskResult.setResponseData(serviceHelper.surrenderGame(context, params.gameId, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case ADD_FRIEND:
                        try{
                            taskResult.setResponseData(serviceHelper.addFriend(context, params.userId, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case REMOVE_FRIEND:
                        try{
                            taskResult.setResponseData(serviceHelper.removeFriend(context, params.userId, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case SET_AS_VIEWED_GAME_RESULT:
                        try{
                            taskResult.setResponseData(serviceHelper.setAsViewedGameResult(context, params.gameId, params.gamerId, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case GET_USERS_RATING:
                        try{
                            taskResult.setResponseData(serviceHelper.getUsersRating(context, params.page, params.limit, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case GET_RATING_DEPARTMENT_TYPES:
                        try{
                            taskResult.setResponseData(serviceHelper.getDepartmentsTypes(context, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    case GET_RATING_DEPARTMENTS:
                        try{
                            taskResult.setResponseData(serviceHelper.getDepartmentsStatistic(context,params.departmentTypeId, params.page, params.limit, params.authToken));
                            taskResult.setTaskStatus(TaskStatus.SUCCESS);
                        }catch (Exception e){
                            taskResult.setTaskStatus(TaskStatus.FAIL);
                            taskResult.setErrorMessage(getErrorMessage(e));
                        }
                        break;
                    default:
                        taskResult.setTaskStatus(TaskStatus.FAIL);
                        taskResult.setErrorMessage("Task "+params.taskType +" not found in task list");
                }
            }else{
                taskResult.setTaskStatus(TaskStatus.FAIL);
                taskResult.setErrorMessage("Task params is null");
            }
        }else{
            taskResult.setTaskStatus(TaskStatus.FAIL);
            taskResult.setErrorMessage("Not found TaskParams");
        }
        return taskResult;
    }
    private String getErrorMessage(Exception e){
        if(e instanceof UnknownHostException){
            return "Ошибка подключения к серверу(хост не найде)";
        }else if(e instanceof IOException){
            return "Ошибка подключения к серверу(ошибка ввода/вывода)";
        }else if(e instanceof RetrofitError){
            switch (((RetrofitError)e).getKind()){
                case CONVERSION:
                    return "Ошибка подключения к серверу(не известный ответ)";
                case HTTP:
                    return "Ошибка подключения к серверу(не правильный HTTP статус)";
                case NETWORK:
                    return "Ошибка подключения к серверу(ошибка сети)";
                case UNEXPECTED:
                    return "Ошибка подключения к серверу(не известная ошибка)";
                default:
                    return "Ошибка подключения к серверу";
            }
        }
        else return e.getLocalizedMessage();
    }
    @Override
    protected void onPreExecute() {
        super.onPreExecute();
    }

    @Override
    protected void onPostExecute(RestTaskResult taskResult) {
        callback.OnRestTaskComplete(taskResult);
    }



    public enum TaskStatus{
        SUCCESS,
        FAIL;
    }

    public enum TaskType {

        AUTHENTICATE,
        /**
         *
         */
        UPDATE_USER_PROFILE,
        GET_GAME_INFORMATION,
        GET_CURRENT_USER_PROFILE,
        UPDATE_GAMES_LIST,
        LOAD_FRIEND_LIST,
        START_NEW_RANDOM_GAME,
        LOAD_ROOT_DEPARTMENTS,
        LOAD_DEPARTMETS_BY_PARENT,
        SEARCH_USER_BY_TEXT,
        CREATE_INVITATION,
        ACCEPT_INVITATION,
        DECLINE_INVITATION,
        GENERATE_ROUND,
        SURRENDER_GAME, SET_ANSWER,
        ADD_FRIEND,
        REMOVE_FRIEND,
        SET_AS_VIEWED_GAME_RESULT,
        GET_USERS_RATING,
        GET_RATING_DEPARTMENT_TYPES,
        GET_RATING_DEPARTMENTS
    }
    public interface RestTaskCallback{
        public void OnRestTaskComplete(RestTaskResult taskResult);
    }
}
