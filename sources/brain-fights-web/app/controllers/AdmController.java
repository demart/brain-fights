package controllers;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import controllers.Secure.Security;
import play.mvc.Controller;
import kz.aphion.brainfights.admin.models.AdminResponseWrapperModel;
import kz.aphion.brainfights.admin.models.AdminUsersModel;
import kz.aphion.brainfights.admin.models.CategoryModel;
import kz.aphion.brainfights.admin.models.QuestionModel;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.UserProfileModel;
import kz.aphion.brainfights.persistents.game.question.Category;
import kz.aphion.brainfights.persistents.game.question.Question;
import kz.aphion.brainfights.persistents.user.AdminUser;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.AdmService;
import kz.aphion.brainfights.models.ResponseStatus;
import kz.aphion.brainfights.models.ResponseWrapperModel;
import play.Logger;
import play.Play;
import play.db.jpa.JPA;

/**
 * Контроллер для админской панели
 * 
 * 
 */
public class AdmController extends Controller {
	
	public static void checkNameAdminInBase (String name) throws PlatformException {
		Logger.info("Check Name Users. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUser(Security.connected());
		System.out.println ("Is user's role administrator? Answer: " + status);
		if (status == true) {
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			Boolean statusName = AdmService.checkNameAdminUser(name);
			
			if (statusName == true)
				wrapper.setStatus(ResponseStatus.SUCCESS);

			renderJSON(wrapper);
		}
	}
	

	/**
	 * Список администраторов и менеджер
	 * @param page
	 * @param start
	 * @param limit
	 * @throws PlatformException
	 */
	public static void readAdminUsers (int page, int start, int limit) throws PlatformException {
		Logger.info("Read Admin Users. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUser(Security.connected());
		System.out.println ("Is user's role administrator? Answer: " + status);
		if (status == true) {
			List<AdminUser> list = AdmService.getAdminUsersList(start, limit);

			ArrayList<AdminUsersModel> models = AdmService.createAdminUsersList(list);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setData(models.toArray());
			wrapper.setStatus(ResponseStatus.SUCCESS);
			wrapper.setTotalCount(AdmService.getCountAdminUsersNotDeleted().intValue());
			renderJSON(wrapper);
		}
	}
	
	/**
	 * Функция для добавления нового администратора/менеджера
	 * @throws PlatformException
	 */
	public static void createAdminUser () throws PlatformException {
		Logger.info("Create New Admin User. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUser(Security.connected());
		System.out.println ("Is user's role administrator? Answer: " + status);
		
		if (status == true) {
			String requestBody = params.current().get("body");
			Logger.info (" Create User: \n" + requestBody);
			
			if (!requestBody.startsWith("["))
				requestBody = "[" + requestBody + "]";
			
				Gson gson = new Gson();
			AdminUsersModel[] models = gson.fromJson(requestBody, AdminUsersModel[].class);
			Logger.info("\n Model.lenght: " + models.length);
			
			AdmService.createAdminUser(models);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setStatus(ResponseStatus.SUCCESS);
			renderJSON(wrapper);
		}
	}

	
	/**
	 * Функция для редактирования администратора/менеджера.
	 * @throws PlatformException
	 */
	public static void updateAdminUser () throws PlatformException {
		Logger.info("Update Admin User. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUser(Security.connected());
		System.out.println ("Is user's role administrator? Answer: " + status);
		
		if (status == true) {
			String requestBody = params.current().get("body");
			Logger.info (" Update User: \n" + requestBody);
			
			if (!requestBody.startsWith("["))
				requestBody = "[" + requestBody + "]";
			
				Gson gson = new Gson();
			AdminUsersModel[] models = gson.fromJson(requestBody, AdminUsersModel[].class);
			Logger.info("\n Model.lenght: " + models.length);
			
			AdmService.updateAdminUser(models);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setStatus(ResponseStatus.SUCCESS);
			renderJSON(wrapper);
		}
	}
	
	/**
	 * Удаление администратора/менеджера
	 * @param id
	 * @return
	 * @throws PlatformException
	 */
	public static Long destroyAdminUser(Long id) throws PlatformException {
		Logger.info("Delete Admin User. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUser(Security.connected());
		System.out.println ("Is user's role administrator? Answer: " + status);
		if (status == true) {
			if (id == null || id <= 0)
				throw new PlatformException ("0","User id is 0 or empty");
			AdminUser user = AdminUser.findById(id);
			user.setDeleted(true);
			user.save();
			return user.getId();
		}
		else
			return 0l;
	}
	
/**
 * Читаем список категорий
 * @param page
 * @param start
 * @param limit
 * @throws PlatformException
 */
	public static void readCategoryList (int page, int start, int limit) throws PlatformException {
		Logger.info("Read Category List. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator or manager? Answer: " + status);
		if (status == true) {
			List<Category> list = AdmService.getCategoryList(start,limit);
			ArrayList<CategoryModel> models = AdmService.createCategoryList(list);
		
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setData(models.toArray());
			wrapper.setStatus(ResponseStatus.SUCCESS);
			wrapper.setTotalCount(AdmService.getCountCategoryNotDeleted().intValue());
			renderJSON(wrapper);
		}
	}
	
	/**
	 * Создание новой категории
	 * @throws PlatformException
	 */
	public static void createNewCategory () throws PlatformException, IOException {
		Logger.info("Create New Category. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator/manager? Answer: " + status);
		
		if (status == true) {
			String requestBody = params.current().get("body");
			//Logger.info (" Create Category: \n" + requestBody);
			
			if (!requestBody.startsWith("["))
				requestBody = "[" + requestBody + "]";
			
				Gson gson = new Gson();
			CategoryModel[] models = gson.fromJson(requestBody, CategoryModel[].class);
			Logger.info("\n Model.lenght: " + models.length);
			
			AdmService.createNewCategory(models);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setStatus(ResponseStatus.SUCCESS);
			renderJSON(wrapper);
		}
	}
	
	/**
	 * Редактирование категории
	 * @throws PlatformException
	 */
	public static void updateCategory () throws PlatformException, IOException {
		Logger.info("Update Category. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator/manager? Answer: " + status);
		
		if (status == true) {
			String requestBody = params.current().get("body");
			Logger.info (" Update Category: \n" + requestBody);
			
			if (!requestBody.startsWith("["))
				requestBody = "[" + requestBody + "]";
			
				Gson gson = new Gson();
			CategoryModel[] models = gson.fromJson(requestBody, CategoryModel[].class);
			Logger.info("\n Model.lenght: " + models.length);
			
			AdmService.updateCategory(models);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setStatus(ResponseStatus.SUCCESS);
			renderJSON(wrapper);
		}
	}
	
	/**
	 * Удаление категории, вместе с вопросами и их ответами.
	 * @param id
	 * @return
	 * @throws PlatformException
	 */
	public static Long destroyCategory(Long id) throws PlatformException {
		Logger.info("Delete Category. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator/manager? Answer: " + status);
		if (status == true) {
			if (id == null || id <= 0)
				throw new PlatformException ("0","Category id is 0 or empty");

			List<Question> list = JPA.em().createQuery("from Question where category.id = :catId and deleted = 'FALSE'").setParameter("catId", id).getResultList();
			
			Category category = Category.findById(id);
			category.setDeleted(true);
			category.save();
			
			if (list.size() != 0) {
				ArrayList ids = new ArrayList();
				for (Question model: list) {
					ids.add(model.getId());
					System.out.println(model.getId());
				}
				
				
				JPA.em().createQuery("update Question set deleted = 'TRUE' where category.id = :catId").setParameter("catId", id).executeUpdate();
				JPA.em().createQuery("update Answer set deleted = 'TRUE' where question.id in (:ids)").setParameter("ids", ids).executeUpdate();
				}
			return category.getId();
		}
		else
			return 0l;
	}
	
	/**
	 * Создание нового вопроса и ответов к нему
	 * @throws PlatformException
	 */
	public static void createNewQuestion () throws PlatformException, IOException {
		Logger.info("Create New Question. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator/manager? Answer: " + status);
		
		if (status == true) {
			String requestBody = params.current().get("body");
			Logger.info (" Create Question: \n" + requestBody);
			
			if (!requestBody.startsWith("["))
				requestBody = "[" + requestBody + "]";
			
				Gson gson = new Gson();
			QuestionModel[] models = gson.fromJson(requestBody, QuestionModel[].class);
			Logger.info("\n Model.lenght: " + models.length);
			
			AdmService.createQuestion(models);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setStatus(ResponseStatus.SUCCESS);
			renderJSON(wrapper);
		}
	}
	
	
	/**
	 * Редактирование вопроса и его ответов
	 * @throws PlatformException
	 */
	public static void updateQuestion () throws PlatformException, IOException {
		Logger.info("Update Question. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator/manager? Answer: " + status);
		
		if (status == true) {
			String requestBody = params.current().get("body");
			Logger.info (" Update Question: \n" + requestBody);
			
			if (!requestBody.startsWith("["))
				requestBody = "[" + requestBody + "]";
			
				Gson gson = new Gson();
			QuestionModel[] models = gson.fromJson(requestBody, QuestionModel[].class);
			Logger.info("\n Model.lenght: " + models.length);
			
			AdmService.updateQuestion(models);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setStatus(ResponseStatus.SUCCESS);
			renderJSON(wrapper);
		}
	}
	
	/**
	 * Читаем список всех вопросов (или вопросы отдельной категорий)
	 * @param categoryId
	 * @param page
	 * @param start
	 * @param limit
	 * @throws PlatformException
	 */
	public static void readQuestions (Long categoryId, int page, int start, int limit) throws PlatformException {
		Logger.info("Read Questions. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator? Answer: " + status);
		if (status == true) {
			List<Question> list = AdmService.getQuestionsList(categoryId, start, limit);
			ArrayList<QuestionModel> models = AdmService.createQuestionsList(list);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setData(models.toArray());
			wrapper.setStatus(ResponseStatus.SUCCESS);
			wrapper.setTotalCount(AdmService.getCountQuestionsNotDeleted(categoryId).intValue());
			renderJSON(wrapper);
		}
	}
	
	/**
	 * Удаление вопроса и его ответов
	 * @param id
	 * @return
	 * @throws PlatformException
	 */
	public static Long destroyQuestion(Long id) throws PlatformException {
		Logger.info("Delete Question. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator/manager? Answer: " + status);
		if (status == true) {
			if (id == null || id <= 0)
				throw new PlatformException ("0","Questions id is 0 or empty");
			
			
			Question question = Question.findById(id);
			question.setDeleted(true);
			question.save();
			
			JPA.em().createQuery("update Answer set deleted = 'TRUE' where question.id = :questId").setParameter("questId", id).executeUpdate();
			
			return question.getId();
		}
		else
			return 0l;
	}
	
	/**
	 * Поиск вопроса по заданному тексту
	 * @param name
	 * @throws PlatformException
	 */
	public static void searchQuestion (String name) throws PlatformException {
		Logger.info("Search Question. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator/manager? Answer: " + status);
		if (status == true) {
			
			List<Question> list = AdmService.searchQuestions(name);
			ArrayList<QuestionModel> models = AdmService.createQuestionsList(list);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setData(models.toArray());
			wrapper.setStatus(ResponseStatus.SUCCESS);
			wrapper.setTotalCount(AdmService.getCountQuestionsNotDeleted(null).intValue());
			renderJSON(wrapper);

		}
	}
	
	/**
	 * Выбор категории при просмотре вопросов
	 * @param start
	 * @param limit
	 * @throws PlatformException
	 */
	public static void createCategoryComboList (int start, int limit) throws PlatformException {
		Logger.info("Create Category Combo List. User is " +  Security.connected());
		
		Boolean status = AdmService.checkUsers(Security.connected());
		System.out.println ("Is user's role administrator/manager? Answer: " + status);
		if (status == true) {
			
			List<Category> listBase = AdmService.getCategoryList(start, limit);
			
			ArrayList<CategoryModel> models = AdmService.createCategoryComboList(listBase);
			
			AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
			wrapper.setData(models.toArray());
			wrapper.setStatus(ResponseStatus.SUCCESS);
			wrapper.setTotalCount(AdmService.getCountCategoryNotDeleted().intValue());
			renderJSON(wrapper);

		}
	}

	/**
	 * функция выхода пользователя
	 */
	public static void loginOut() {
		Logger.info("Log Out. User is " + Security.connected());
    /*
		session.clear();
        response.removeCookie("rememberme");
        */
		Security.onDisconnect();
        session.clear();
        response.removeCookie("rememberme");
        Security.onDisconnected();
        flash.success("secure.logout");
 
		AdminResponseWrapperModel wrapper = new AdminResponseWrapperModel();
		wrapper.setStatus(ResponseStatus.SUCCESS);
		renderJSON(wrapper);
		
	}
	
	

		
		
	

}



