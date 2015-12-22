package kz.aphion.groupbridge.brainfights.services;

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
import kz.aphion.groupbridge.brainfights.models.Status;
import kz.aphion.groupbridge.brainfights.models.StatusSingle;
import kz.aphion.groupbridge.brainfights.models.UserGameModel;
import kz.aphion.groupbridge.brainfights.models.UserList;
import kz.aphion.groupbridge.brainfights.models.UserProfile;
import kz.aphion.groupbridge.brainfights.models.Users;
import retrofit.http.Body;
import retrofit.http.GET;
import retrofit.http.POST;
import retrofit.http.Path;
import retrofit.http.Query;

/**
 * Created by alimjan on 04.11.2015.
 */
public interface BrainFightsApi {
    @POST("/user/auth")
    public StatusSingle<AuthorizationResponseModel> authenticate(@Body AuthorizationRequestModel authorizationRequest);
    @GET("/game/{gameId}")
    public StatusSingle<GameModel> getGameInformation(@Path("gameId") Long gameId, @Query("authToken") String authToken);
    @GET("/user/profile")
    public StatusSingle<UserProfile> getUserProfile(@Query("authToken") String authToken);
    @GET("/game/list")
    public StatusSingle<Games> getGamesList(@Query("authToken") String authToken);
    @GET("/game/invitation/create")
    public StatusSingle<GameModel> createRandomGame(@Query("authToken") String authToken);
    @GET("/user/friends")
    public StatusSingle<Friends> getFriendsList(@Query("authToken") String authToken);
    @GET("/search/department/")
    public StatusSingle<Departments> getRootDepartments(@Query("authToken") String authToken);
    @GET("/search/department/{parentId}")
    public StatusSingle<Departments> getDepartmentsByParent(@Path("parentId") Long parentId,@Query("authToken") String authToken );
    @GET("/search/user")
    public StatusSingle<UserList> searchUserByText(@Query("authToken") String authToken, @Query("searchText") String searchText);
    @GET("/game/invitation/create/{userId}")
    public StatusSingle<UserGameModel> createInvitation(@Query("authToken") String authToken, @Path("userId") Long userId);
    @GET("/game/{gameId}/accept/invitation")
    public StatusSingle<UserGameModel> acceptInvitation(@Query("authToken") String authToken, @Path("gameId") Long gameId);
    @GET("/game/{gameId}/round/generate/{categoryId}")
    public StatusSingle<GameRoundModel> generateNewRound(@Path("gameId") Long gameId , @Path("categoryId") Long categoryId, @Query("authToken") String authToken);
    @GET("/game/{gameId}/round/{roundId}/questions/{questionId}/answer/{answerId}")
    public StatusSingle<GamerQuestionAnswerResultModel> setAnswer(@Path("gameId") Long gameId ,@Path("roundId") Long roundId, @Path("questionId") Long questionId, @Path("answerId") Long answerId, @Query("authToken") String authToken);
    @GET("/game/{gameId}/surrender")
    public StatusSingle<GameModel> surrenderGame(@Path("gameId") Long gameId, @Query("authToken") String authToken);
    @GET("/user/friends/add/{id}")
    public StatusSingle addFriend(@Path("id") Long userId, @Query("authToken") String authToken);
    @GET("/user/friends/remove/{id}")
    public StatusSingle removeFriend(@Path("id") Long userId, @Query("authToken") String authToken);
    @GET("/game/{gameId}/gamer/{gamerId}/mark/as/viewed")
    public StatusSingle<GameModel> setAsViewedGameResult(@Path("gameId") Long gameId, @Path("gamerId") Long gamerId, @Query("authToken") String authToken);
    @GET("/stat/users/page/{page}/limit/{limit}")
    public Status<UserProfile> getUsersRating(@Path("page") Integer page,@Path("limit") Integer limit,@Query("authToken") String authToken );
    @GET("/stat/departments/types")
    public Status<DepartmentTypeModel> getDepartmentsTypes(@Query("authToken") String authToken);
    @GET("/stat/departments/type/{departmentTypeId}/page/{page}/limit/{limit}")
    public Status<Department> getDepartmentsStatistic(@Path("departmentTypeId") Long departmentTypeId,@Path("page") Integer page, @Path("limit") Integer limit, @Query("authToken") String authToken );
 }
