package kz.aphion.groupbridge.brainfights.tasks;

import android.os.AsyncTask;



/**
 * Created by alimjan on 02.11.2015.
 */
public class RestTask extends AsyncTask<RestTask.TaskParams,Void,RestTask.TaskResult> {

    Exception e;
    RestTaskCallback callback;

    public RestTask(RestTaskCallback callback){
        this.callback=callback;
    }

    @Override
    protected TaskResult doInBackground(TaskParams... taskParamses) {
        TaskResult taskResult = new TaskResult();
        if(taskParamses!=null&&taskParamses.length>0){
            TaskParams params = taskParamses[0];
            if(params!=null) {
                taskResult.setTaskType(params.taskType);
                switch (params.taskType){
                    case AUTHENTICATE:
                        //TODO: Excecute
                        taskResult.setTaskStatus(TaskStatus.SUCCESS);
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

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
    }

    @Override
    protected void onPostExecute(TaskResult taskResult) {
        super.onPostExecute(taskResult);
    }

    class TaskParams{
        public TaskType taskType;
        public TaskParams(TaskType taskType){
            this.taskType = taskType;
        }
    }
    class TaskResult{
        TaskType taskType;
        TaskStatus taskStatus;
        Object responseData;
        String errorMessage;
        Exception exception;

        public TaskType getTaskType() {
            return taskType;
        }

        public void setTaskType(TaskType taskType) {
            this.taskType = taskType;
        }

        public TaskStatus getTaskStatus() {
            return taskStatus;
        }

        public void setTaskStatus(TaskStatus taskStatus) {
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

    enum TaskStatus{
        SUCCESS,
        FAIL;
    }

    enum TaskType {

        AUTHENTICATE,
        /**
         *
         */
        UPDATE_USER_PROFILE;
    }
    interface RestTaskCallback{
        public void OnRestTaskComplete();
    }
}
