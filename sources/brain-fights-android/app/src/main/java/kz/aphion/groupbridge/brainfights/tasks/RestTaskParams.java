package kz.aphion.groupbridge.brainfights.tasks;

import kz.aphion.groupbridge.brainfights.models.AuthorizationRequestModel;

/**
 * Created by alimjan on 04.11.2015.
 */
public class RestTaskParams {
    public RestTask.TaskType taskType;
    public AuthorizationRequestModel authorizationRequest;
    public Long gameId;
    public Long parentId;
    public String authToken;
    public String searchText;
    public Long userId;
    public Long categoryId;
    public Long questionId;
    public Long answerId;
    public Long roundId;
    public Long gamerId;
    public Integer page;
    public Integer limit;
    public Long departmentTypeId;

    public RestTaskParams(RestTask.TaskType taskType){
        this.taskType = taskType;
    }
}
