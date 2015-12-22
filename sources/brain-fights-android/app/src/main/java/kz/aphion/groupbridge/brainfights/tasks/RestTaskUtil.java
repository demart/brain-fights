package kz.aphion.groupbridge.brainfights.tasks;

import android.content.Context;

import kz.aphion.groupbridge.brainfights.stores.CurrentUser;

/**
 * Created by alimjan on 28.11.2015.
 */
public class RestTaskUtil {
    public static void createInvitation(Context context, RestTask.RestTaskCallback callback, Long userId){
        RestTask task = new RestTask(context,callback);
        RestTaskParams params = new RestTaskParams(RestTask.TaskType.CREATE_INVITATION);
        params.authToken = CurrentUser.getInstance().getAuthToken();
        params.userId = userId;
        task.execute(params);
    }
}
