package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 04.11.2015.
 */
public class AuthorizationResponseModel {
    /**
     * Токен авторизации для обращения к резурсам
     */
    public String authToken;

    /**
     * Профиль пользователя
     */
    public UserProfile userProfile;
}
