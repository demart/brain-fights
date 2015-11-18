package controllers;

import play.Logger;
import kz.aphion.brainfights.persistents.user.AdminUser;

public class Security extends Secure.Security  {

	 static boolean authenticate(String username, String password) {
		 //Logger.info("authenticate Login: " + username + " password: " + password);
		 AdminUser user =  AdminUser.find("login = ?1 and password = ?2", username, password).first();
		 if (user != null && user.getEnabled() == true)
			 return true;
		 else
			 return false;
	 }
	 
}