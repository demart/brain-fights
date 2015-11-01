package kz.aphion.brainfights.models;

import kz.aphion.brainfights.persistents.DeviceType;

/**
 * 
 * Модель запроса авторизации пользователя
 * 
 * @author artem.demidovich
 *
 */
public class AuthorizationRequestModel {

	public String login;
	
	public String password;
	
	public DeviceType deviceType;
	
	public String devicePushToken;
	
	public String deviceOsVersion;
	
	public String appVersion;
	
}