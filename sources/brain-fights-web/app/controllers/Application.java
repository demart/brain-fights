package controllers;

import play.mvc.Controller;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.UserService;
import kz.aphion.brainfights.services.notifications.NotificationService;

//import models.*;

public class Application extends SecuredController {

    public static void index() {
        render();
    }

}