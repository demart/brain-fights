package controllers;

import play.*;
import play.mvc.*;

import java.util.*;

//import models.*;

public class Application extends SecuredController {

    public static void index() {
        render();
    }

}