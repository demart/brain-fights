package kz.aphion.groupbridge.brainfights.tasks;

/**
 * Created by alimjan on 04.11.2015.
 */
public class RestTaskResult {
    RestTask.TaskType taskType;
    RestTask.TaskStatus taskStatus;
    Object responseData;
    String errorMessage;
    Exception exception;

    public RestTask.TaskType getTaskType() {
        return taskType;
    }

    public void setTaskType(RestTask.TaskType taskType) {
        this.taskType = taskType;
    }

    public RestTask.TaskStatus getTaskStatus() {
        return taskStatus;
    }

    public void setTaskStatus(RestTask.TaskStatus taskStatus) {
        this.taskStatus = taskStatus;
    }

    public Object getResponseData() {
        return responseData;
    }

    public void setResponseData(Object responseData) {
        this.responseData = responseData;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public Exception getException() {
        return exception;
    }

    public void setException(Exception exception) {
        this.exception = exception;
    }
}
