package kz.aphion.brainfights.services;

import play.Logger;
import play.db.jpa.JPA;
import java.util.List;
import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang.StringUtils;

import kz.aphion.brainfights.persistents.user.DepartmentType;

import javax.imageio.ImageIO;
import javax.persistence.Query;

import kz.aphion.brainfights.persistents.game.question.Answer;
import kz.aphion.brainfights.persistents.game.question.Category;
import kz.aphion.brainfights.persistents.game.question.Question;
import kz.aphion.brainfights.persistents.game.question.QuestionType;
import kz.aphion.brainfights.persistents.user.*;
import kz.aphion.brainfights.admin.models.AdminUsersModel;
import kz.aphion.brainfights.admin.models.CategoryModel;
import kz.aphion.brainfights.admin.models.DepartmentForAdminModel;
import kz.aphion.brainfights.admin.models.DepartmentTreeModel;
import kz.aphion.brainfights.admin.models.DepartmentTreeRootModel;
import kz.aphion.brainfights.admin.models.QuestionModel;
import kz.aphion.brainfights.admin.models.UserModel;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.*;

/**
 * Сервич для работы с админской панелью
 * @author denis.krylov
 *
 */
public class AdmService {
	
	/**
	 * Проверяем существует ли пользователь
	 * @param name
	 * @return
	 */
	public static boolean checkNameAdminUser (String name) {
		List<AdminUser> user = JPA.em().createQuery("from AdminUser where login = :name").setParameter("name", name).getResultList();
		if (user.size() == 0)
			return true;
		else
			return false;
	}
	
	/**
	 * Проверяем пользователя, который делает запрос, на его роль (управление пользователями)
	 * @param connected
	 * @return
	 */
	public static boolean checkUser (String connected) {
		List<AdminUser> user = JPA.em().createQuery("from AdminUser where login = :connected").setParameter("connected", connected).getResultList();
		for (AdminUser model: user) {
			if (model.getRole() == AdminUserRole.ADMINISTRATOR) {
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * Проверяем пользователя, который делает запрос, на его роль (остальные разделы)
	 * @param connected
	 * @return
	 */
	public static boolean checkUsers (String connected) {
		List<AdminUser> user = JPA.em().createQuery("from AdminUser where login = :connected").setParameter("connected", connected).getResultList();
		for (AdminUser model: user) {
			if (model.getRole() == AdminUserRole.ADMINISTRATOR || model.getRole() == AdminUserRole.CONTENT_MANAGER) {
				return true;
			}
		}
		
		return false;
	}
	
	/**
	 * Количество вопросов в категории
	 * @param id
	 * @return
	 * @throws PlatformException
	 */
	public static Long getCountQuestionsInCategory (Long id) throws PlatformException {
		Query query = JPA.em().createQuery("select count(*) from Question where category.id = :catId and deleted = 'FALSE'").setParameter("catId", id);
		return (Long)query.getSingleResult();
	}
	
	
	/**
	 * Получаем список администраторов, менеджеров
	 * @param start
	 * @param limit
	 * @return
	 */
	public static List<AdminUser> getAdminUsersList (int start, int limit) {
		return JPA.em().createQuery("from AdminUser where deleted = 'FALSE'").getResultList();
	}
	
	/**
	 * Получаем количество активных администраторов, менеджеров
	 * @return
	 */
	public static Long getCountAdminUsersNotDeleted() {
		return (Long)JPA.em().createQuery("select count(*) from AdminUser where deleted = 'FALSE'").getSingleResult();
	}
	


	/**
	 * Создаем список моделей администраторов и менеджеров
	 * @param list
	 * @return
	 */
	public static ArrayList<AdminUsersModel> createAdminUsersList(List<AdminUser> list) {
		ArrayList<AdminUsersModel> models = new ArrayList<AdminUsersModel> ();
		for (AdminUser model: list) {
			AdminUsersModel admin = new AdminUsersModel();
			admin.setId(model.getId());
			admin.setName(model.getName());
			admin.setLogin(model.getLogin());
			admin.setPassword(model.getPassword());
			admin.setRole(model.getRole());
			admin.setIsEnabled(model.getEnabled());
			admin.setCreadtedDate(model.getCreatedDate().getTime());
			models.add(admin);
		}
		return models;
	}

	/**
	 * Добавление нового администратора/менеджера
	 * @param models
	 * @throws PlatformException
	 */
	public static void createAdminUser(AdminUsersModel[] models) throws PlatformException {
		for (AdminUsersModel model: models) {
			if (model == null)
				throw new PlatformException("0", "User model is null");
			
			Boolean status = AdmService.checkNameAdminUser(model.getLogin());
			if (status == false)
				throw new PlatformException("0", "User with this Login finds");
			
			else {	
			AdminUser user = new AdminUser();
			
			
	
			user.setDeleted(false);
			user.setEnabled(model.getIsEnabled());
			user.setRole(model.getRole());
			
			if (StringUtils.isNotEmpty(model.getName()))
				user.setName(model.getName());
			
			if (StringUtils.isNotEmpty(model.getLogin()))
				user.setLogin(model.getLogin());
			
			if (StringUtils.isNotEmpty(model.getPassword()))
				user.setPassword(model.getPassword());
		
			user.save();
			
			Logger.info("User created successfully");
			}
		}
	}

	/**
	 * Редактирование админа/менеджера
	 * @param models
	 * @throws PlatformException
	 */
	public static void updateAdminUser(AdminUsersModel[] models) throws PlatformException {
		
		for (AdminUsersModel model: models) {
			if (model == null)
				throw new PlatformException("0", "User model is null");
			
			AdminUser user = AdminUser.findById(model.getId());
			if (user == null)
				throw new PlatformException ("0", "User not found");
			
			Boolean status = AdmService.checkNameAdminUser(model.getLogin());
			if (status == false)
				throw new PlatformException("0", "User with this Login finds");
			
			else {	
			
			if (StringUtils.isNotEmpty(model.getName()))
				user.setName(model.getName());
			
			if (StringUtils.isNotEmpty(model.getLogin()))
				user.setLogin(model.getLogin());
			
			if (StringUtils.isNotEmpty(model.getPassword()))
				user.setPassword(model.getPassword());
			
			if (model.getIsEnabled() != null)
				user.setEnabled(model.getIsEnabled());
			
			if (model.getRole() != null) 
				user.setRole(model.getRole());
		
			user.save();
			
			Logger.info("User updated successfully");
			}
		}
		
	}

	/**
	 * Список категорий из базы данных
	 * @param start
	 * @param limit
	 * @return
	 * @throws PlatformException
	 */
	public static List<Category> getCategoryList(int start, int limit) throws PlatformException {
		return JPA.em().createQuery("from Category where deleted = 'FALSE' order by id asc").setFirstResult(start).setMaxResults(limit).getResultList();
	}
	
	/**
	 * Список пользователей из базы данных
	 * @param start
	 * @param limit
	 * @return
	 * @throws PlatformException
	 */
	public static List<User> getUsersList (int start, int limit) throws PlatformException {
		return JPA.em().createQuery("from User where deleted = 'FALSE' order by id asc").setFirstResult(start).setMaxResults(limit).getResultList();
	}

	/**
	 * Создаем список категорий, которые отправляем клиенту
	 * @param list
	 * @return
	 * @throws PlatformException
	 */
	public static ArrayList<CategoryModel> createCategoryList(List<Category> list) throws PlatformException {
		ArrayList<CategoryModel> models = new ArrayList<CategoryModel>();
		for (Category model: list) {
			CategoryModel category = new CategoryModel();
			category.setId(model.getId());
			category.setName(model.getName());
			if (model.getImageUrl() == null)
				category.setImage("0");
			else
				category.setImage(model.getImageUrl());
			category.setQuestionsCount(AdmService.getCountQuestionsInCategory(model.getId()));
			category.setCreatedDate(model.getCreatedDate().getTime());
			category.setModifiedDate(model.getModifiedDate().getTime());
			category.setColor(model.getColor());
			models.add(category);
		}
		return models;
	}

	/**
	 * Количество категорий
	 * @return
	 * @throws PlatformException
	 */
	public static Long getCountCategoryNotDeleted() throws PlatformException {
		return (Long)JPA.em().createQuery("select count(*) from Category where deleted = 'false'").getSingleResult();
	}

	/**
	 * Создание новой категории
	 * @param models
	 * @throws PlatformException
	 */
	public static void createNewCategory(CategoryModel[] models) throws PlatformException, IOException {
		Integer count = 0;
		for (CategoryModel model: models) {
			if (model == null)
				throw new PlatformException("0", "Category model is null");

			Category category = new Category();

			
			if (StringUtils.isNotEmpty(model.getImage())) {
				String strTmpOne = model.getImage().substring(model.getImage().indexOf("base64,"), model.getImage().length());
				String stringInBase64 =strTmpOne.substring(7, strTmpOne.length());
				
				String imageTmpFormat = model.getImage().substring(11, model.getImage().indexOf(";base64,"));
				//System.out.println (imageTmpFormat);
				
				
				
				//System.out.println (imageTmpFormat);
				String nameImage = "" + AdmService.getCountCategoryNotDeleted() + 1000000000 + (Math.random()*1000000+3);
				
				byte[] decoded = Base64.decodeBase64(stringInBase64);
File f = new File("public" + File.separator +"images" + File.separator + "categories" + File.separator + nameImage + "." + imageTmpFormat);
				//System.out.println(f.getName());
				//System.out.println(f.getAbsolutePath());
				System.out.println(f.getPath());
				
				
				f.createNewFile();

				FileOutputStream fileOut = new FileOutputStream (f.getAbsolutePath());
				fileOut.write(decoded);
				fileOut.close();
				
				
				category.setImageUrl(File.separator + f.getPath());
			}
			
		
			
			if (StringUtils.isNotEmpty(model.getName()))
				category.setName(model.getName());
			
			if (StringUtils.isNotEmpty(model.getColor()))
				category.setColor(model.getColor());
			
					
			category.save();
			



			
			Logger.info("Category created successfully");
		}
				
	}
	

	/**
	 * Редактирование категории
	 * @param models
	 * @throws PlatformException
	 */
	public static void updateCategory(CategoryModel[] models) throws PlatformException, IOException {
		
		for (CategoryModel model: models) {
			if (model == null)
				throw new PlatformException("0", "Category model is null");
			
			Category category = Category.findById(model.getId());
			if (category == null)
				throw new PlatformException ("0", "Category not found");
			
			if (StringUtils.isNotEmpty(model.getImage())) {	
				Category catImage = Category.findById(model.getId());
				
				if (catImage.getImageUrl() != null) {
					File del = new File(catImage.getImageUrl().substring(1, catImage.getImageUrl().length()));
					del.delete();
				}
					
				//System.out.println("ok");
				String strTmpOne = model.getImage().substring(model.getImage().indexOf("base64,"), model.getImage().length());
				String stringInBase64 =strTmpOne.substring(7, strTmpOne.length());
				
				String imageTmpFormat = model.getImage().substring(11, model.getImage().indexOf(";base64,"));
				//System.out.println (imageTmpFormat);
				
				
				
				//System.out.println (imageTmpFormat);
				String nameImage = "" + AdmService.getCountCategoryNotDeleted() + 1000000000 + (Math.random()*1000000+3);
				
				byte[] decoded = Base64.decodeBase64(stringInBase64);
				File f = new File("public" + File.separator +"images" + File.separator + "categories" + File.separator + nameImage + "." + imageTmpFormat);
				//System.out.println(f.getName());
				//System.out.println(f.getAbsolutePath());
				System.out.println(f.getPath());
				
				
				f.createNewFile();

				
				FileOutputStream fileOut = new FileOutputStream (f.getAbsolutePath());
				fileOut.write(decoded);
				fileOut.close();
				
				category.setImageUrl(File.separator + f.getPath());
			}
			
			
			if (StringUtils.isNotEmpty(model.getName()))
				category.setName(model.getName());
			
			if (StringUtils.isNotEmpty(model.getColor()))
				category.setColor(model.getColor());
			

			

		
			category.save();
			
			Logger.info("Category updated successfully");
		}
		
	}
	
	public static String saveImage (String strImage) throws IOException {
		String strTmpOne = strImage.substring(strImage.indexOf("base64,"), strImage.length());
		String stringInBase64 =strTmpOne.substring(7, strTmpOne.length());
		
		String imageTmpFormat = strImage.substring(11, strImage.indexOf(";base64,"));
		System.out.println (imageTmpFormat);
		
		byte[] decoded = Base64.decodeBase64(stringInBase64);
		File f = new File("public" + File.separator + "Test." + imageTmpFormat);
		f.createNewFile();
		System.out.println(f.getName());
		System.out.println(f.getAbsolutePath());
		System.out.println(f.getPath());
		
		FileOutputStream fileOut = new FileOutputStream (f.getAbsolutePath());
		fileOut.write(decoded);
		fileOut.flush();
		fileOut.close();
		
		
		return f.getPath();
	}

	/**
	 * Создание вопроса
	 * @param models
	 * @throws PlatformException
	 */
	public static void createQuestion(QuestionModel[] models) throws PlatformException, IOException{
		
		for (QuestionModel model: models) {
			if (model == null)
				throw new PlatformException("0", "Question model is null");
			
			Question question = new Question();
			
			if (model.getCategoryId() != null || model.getCategoryId() != 0) {
				Category category = Category.findById(model.getCategoryId());
				question.setCategory(category);
			}
			else 
				throw new PlatformException("0", "Category not found");
				
			question.setImageUrl("0");
			
			question.setType(model.getType());
			
			if (model.getType() == QuestionType.IMAGE) {
				String strTmpOne = model.getImage().substring(model.getImage().indexOf("base64,"), model.getImage().length());
				String stringInBase64 =strTmpOne.substring(7, strTmpOne.length());
				
				String imageTmpFormat = model.getImage().substring(11, model.getImage().indexOf(";base64,"));
				//System.out.println (imageTmpFormat);
				
				
				
				//System.out.println (imageTmpFormat);
				String nameImage = "" + AdmService.getCountCategoryNotDeleted() + 1000000000 + (Math.random()*1000000+3);
				
				byte[] decoded = Base64.decodeBase64(stringInBase64);
				File f = new File("public" + File.separator +"images" + File.separator + "questions" + File.separator + nameImage + "." + imageTmpFormat);
				//System.out.println(f.getName());
				//System.out.println(f.getAbsolutePath());
				System.out.println(f.getPath());
				
				
				f.createNewFile();

				
				FileOutputStream fileOut = new FileOutputStream (f.getAbsolutePath());
				fileOut.write(decoded);
				fileOut.close();
				
				question.setImageUrl(File.separator + f.getPath());
				
				
			}
			
			
			question.setDeleted(false);
			
					
			if (StringUtils.isNotEmpty(model.getText()))
				question.setText(model.getText());
			
			if (model.getAnswers() != null) {
				question.setAnswers(new ArrayList<Answer>());
				for (Answer answer: model.getAnswers() ) {
					Answer tmp = new Answer();
					tmp.setCorrect(answer.getCorrect());
					tmp.setName(answer.getName());
					System.out.println(answer.getName());
					tmp.setDeleted(false);
					tmp.setQuestion(question);
					question.getAnswers().add(tmp);
				}
				//question.setAnswers(listModels);
			}
			
			question.save();
			Logger.info("Question created successfully");
			
			
			
		}
	}

	/**
	 * редактирование вопроса
	 * @param models
	 * @throws PlatformException
	 */
	public static void updateQuestion(QuestionModel[] models) throws PlatformException, IOException{
		
		for (QuestionModel model: models) {
			if (model == null)
				throw new PlatformException("0", "Question model is null");
			
			Question question = Question.findById(model.getId());
			if (question == null)
				throw new PlatformException("0", "Question not found");
			System.out.println("Cat: " + model.getCategoryId());
			
			if (model.getCategoryId() != null && model.getCategoryId() != 0) {
				Category category = Category.findById(model.getCategoryId());
				if (category != null)
					question.setCategory(category);
				else 
					throw new PlatformException("0", "Category not found");
			}

			
				if (StringUtils.isNotEmpty(model.getImage())) {
					Question questImage = Question.findById(model.getId());
					
					try {
						
						if (questImage.getImageUrl() != null) {
							File del = new File(questImage.getImageUrl().substring(1, questImage.getImageUrl().length()));
							del.delete();
						}
						
						String strTmpOne = model.getImage().substring(model.getImage().indexOf("base64,"), model.getImage().length());
						String stringInBase64 =strTmpOne.substring(7, strTmpOne.length());
						
						String imageTmpFormat = model.getImage().substring(11, model.getImage().indexOf(";base64,"));
						//System.out.println (imageTmpFormat);
						
						
						
						//System.out.println (imageTmpFormat);
						String nameImage = "" + AdmService.getCountCategoryNotDeleted() + 1000000000 + (Math.random()*1000000+3);
						
						byte[] decoded = Base64.decodeBase64(stringInBase64);
						File f = new File("public" + File.separator +"images" + File.separator + "questions" + File.separator + nameImage + "." + imageTmpFormat);
						//System.out.println(f.getName());
						//System.out.println(f.getAbsolutePath());
						System.out.println(f.getPath());
						
						
						f.createNewFile();
	
						
						FileOutputStream fileOut = new FileOutputStream (f.getAbsolutePath());
						fileOut.write(decoded);
						fileOut.close();
						
						question.setImageUrl(File.separator + f.getPath());
					}
					catch(Exception e) {
						throw new PlatformException("0", "Image not save");
					}
				}
			
			question.setModifiedDate(Calendar.getInstance());
			
			if (StringUtils.isNotEmpty(model.getText()))
				question.setText(model.getText());
			
			
			
			if (model.getAnswers() != null) {
				
				try {
					JPA.em().createQuery("delete Answer where question.id = :quest").setParameter("quest", model.getId()).executeUpdate();
					question.setAnswers(new ArrayList<Answer>());
					for (Answer answer: model.getAnswers() ) {
						Answer tmp = new Answer();
						tmp.setCorrect(answer.getCorrect());
						tmp.setName(answer.getName());
						System.out.println(answer.getName());
						tmp.setDeleted(false);
						tmp.setQuestion(question);
						question.getAnswers().add(tmp);
					}
				}
				
				catch (Exception e) {
					throw new PlatformException ("1", e.getMessage());
				}
				//System.out.println(question.getAnswers().get(0).getName());
				//question.setAnswers(listModels);
			}
			
			question.save();
			
					
			Logger.info("Question updated successfully");
			
			
		}
	}
	
	/**
	 * список вопросов в категории
	 * @param categoryId
	 * @param start
	 * @param limit
	 * @return
	 * @throws PlatformException
	 */
	public static List<Question> getQuestionsList(Long categoryId, int start, int limit) throws PlatformException{
		if (categoryId == null) {
			return JPA.em().createQuery("from Question where deleted = 'FALSE' order by id asc").setFirstResult(start).setMaxResults(limit).getResultList();
		}
		else
			return JPA.em().createQuery("from Question where category.id = :categoryId and deleted = 'FALSE' order by id asc").setFirstResult(start).setMaxResults(limit).setParameter("categoryId", categoryId).getResultList();
	}
	

/**
 * количество вопросов
 * @param categoryId
 * @return
 * @throws PlatformException
 */
	public static Long getCountQuestionsNotDeleted(Long categoryId) throws PlatformException {
		if (categoryId == null)
			return (Long)JPA.em().createQuery("select count(*) from Question where deleted = 'FALSE'").getSingleResult();
		else
			return (Long)JPA.em().createQuery("select count(*) from Question where category.id = :categoryId").setParameter("categoryId", categoryId).getSingleResult();
		
	}
	
/**
 * создаем список вопросов
 * @param list
 * @return
 * @throws PlatformException
 */
	public static ArrayList<QuestionModel> createQuestionsList(List<Question> list) throws PlatformException {
		ArrayList<QuestionModel> models = new ArrayList<QuestionModel>();
		for (Question model: list) {
			QuestionModel question = new QuestionModel();
			question.setText(model.getText());
			question.setType(model.getType());
			question.setAnswers(new ArrayList<Answer>());
				for (Answer answers: model.getAnswers()) {
					Answer ans = new Answer();
					if (answers.getDeleted() == false) {
						ans.setName(answers.getName());
						ans.setCorrect(answers.getCorrect());
						question.getAnswers().add(ans);
					}
				}
			question.setId(model.getId());
			question.setCategoryName(model.getCategory().getName());
			question.setCategoryId(model.getCategory().getId());
			question.setCreatedDate(model.getCreatedDate().getTime());
			question.setModifiedDate(model.getModifiedDate().getTime());
			
			if (model.getImageUrl() == null)
				question.setImage("0");
			else
				question.setImage(model.getImageUrl());
			
			
			models.add(question);
		}
		return models;
	}
	
	/**
	 * Поиск вопроса в базе данных
	 * @param name
	 * @return
	 */
	public static List<Question> searchQuestions(String name) {
			return JPA.em().createQuery("from Question where lower(text) like lower(:name) and deleted = 'FALSE' order by id")
				.setParameter("name", "%" + name + "%").getResultList();

	}

	/**
	 * Создание списка категорий для вопросов
	 * @param listBase
	 * @return
	 * @throws PlatformException
	 */
	public static ArrayList<CategoryModel> createCategoryComboList(List<Category> listBase) throws PlatformException{
		ArrayList<CategoryModel> models = new ArrayList<CategoryModel>();
		CategoryModel firstCategory = new CategoryModel();
		firstCategory.setId(0l);
		firstCategory.setName("Все категории");
		models.add(firstCategory);
		for (Category model: listBase) {
			CategoryModel category = new CategoryModel();
			category.setId(model.getId());
			category.setName(model.getName());
			category.setImage(model.getImageUrl());
			category.setQuestionsCount(AdmService.getCountQuestionsInCategory(model.getId()));
			category.setCreatedDate(model.getCreatedDate().getTime());
			category.setModifiedDate(model.getModifiedDate().getTime());
			category.setColor(model.getColor());
			models.add(category);
		}
		return models;

	}
	
	/**
	 * Выпадающее меню при редактирование пользователя, а именно выбор его отделения
	 * @param list
	 * @return
	 */
	public static ArrayList<DepartmentForAdminModel> createDepartmentComboList (List<Department> list) {
		ArrayList<DepartmentForAdminModel> models = new ArrayList<DepartmentForAdminModel> ();
		for (Department model: list) {
			DepartmentForAdminModel department = new DepartmentForAdminModel();
			department.setId(model.getId());
			department.setName(model.getName());
			models.add(department);
		}
 		return models;
	}

	/**
	 * Формируем список всех игроков
	 * @param list
	 * @return
	 * @throws PlatformException
	 */
	public static ArrayList<UserModel> createUsersList(List<User> list) throws PlatformException {
		ArrayList<UserModel> models = new ArrayList<UserModel>();
		for (User model: list) {
			UserModel user = new UserModel();
			user.setId(model.getId());
			user.setName(model.getName());
			user.setEmail(model.getEmail());
			user.setLogin(model.getLogin());
			user.setScore(model.getScore().toString());
			user.setTotalGames(model.getScore());
			if (model.getDepartment() != null)
				user.setDepartment(model.getDepartment().getName());
			else 
				user.setDepartment("Не указано");
			
			if (model.getImageUrl() == null)
				user.setImageUrl("/public/images/no_image.jpg");
			else
				user.setImageUrl(model.getImageUrl());
			models.add(user);
		}
		return models;
	
	}
/**
 * Количество пользователей  из базы данных
 * @return
 */
	public static Long getCountUserNotDeleted() {
		Query query = JPA.em().createQuery("select count(*) from User where deleted = 'FALSE'");
		return (Long)query.getSingleResult();
	}

	/**
	 * Получаем из базы данных весь список департаментов
	 * @param start
	 * @param limit
	 * @return
	 */
	public static List<Department> getDepartmentList(int start, int limit) {
		return JPA.em().createQuery("from Department where deleted = 'FALSE'").setFirstResult(start).setMaxResults(limit).getResultList();
	}

	/**
	 * Получаем из базы данных количество департаментов
	 * @return
	 */
	public static Long getCountDepartmentNotDeleted() {
		Query query = JPA.em().createQuery("select count(*) from Department where deleted = 'FALSE'");
		return (Long)query.getSingleResult();
	}

	/**
	 * Загрузка фотографии пользователя на сервер и сохранение в базе данных
	 * @param models
	 * @throws PlatformException
	 * @throws IOException
	 */
	public static void uploadImage(UserModel[] models) throws PlatformException,IOException{
		for (UserModel model: models) {
			if (model == null)
				throw new PlatformException("0", "User model is null");
			
			User user = User.findById(model.getId());
			if (user == null)
				throw new PlatformException("0", "User not found");
			
			if (model.getImageUrl() != null) {
				if (user.getImageUrl() != null) {
					File del = new File(user.getImageUrl().substring(1, user.getImageUrl().length()));
					del.delete();
					System.out.println ("Ok DELETED");
					
					String strTmpOne = model.getImageUrl().substring(model.getImageUrl().indexOf("base64,"), model.getImageUrl().length());
					String stringInBase64 =strTmpOne.substring(7, strTmpOne.length());
					
					String imageTmpFormat = model.getImageUrl().substring(11, model.getImageUrl().indexOf(";base64,"));
					//System.out.println (imageTmpFormat);
					
					
					
					//System.out.println (imageTmpFormat);
					String nameImage = "" + AdmService.getCountCategoryNotDeleted() + 1000000000 + (Math.random()*1000000+3);
					
					byte[] decoded = Base64.decodeBase64(stringInBase64);
					File f = new File("public" + File.separator +"images" + File.separator + "avatars" + File.separator + nameImage + "." + imageTmpFormat);
					//System.out.println(f.getName());
					//System.out.println(f.getAbsolutePath());
					System.out.println(f.getPath());
					
					
					f.createNewFile();

					
					FileOutputStream fileOut = new FileOutputStream (f.getAbsolutePath());
					fileOut.write(decoded);
					fileOut.close();
					
					user.setImageUrl(File.separator + f.getPath());
				}
				else {
					String strTmpOne = model.getImageUrl().substring(model.getImageUrl().indexOf("base64,"), model.getImageUrl().length());
					String stringInBase64 =strTmpOne.substring(7, strTmpOne.length());
					
					String imageTmpFormat = model.getImageUrl().substring(11, model.getImageUrl().indexOf(";base64,"));
					//System.out.println (imageTmpFormat);
					
					
					
					//System.out.println (imageTmpFormat);
					String nameImage = "" + AdmService.getCountCategoryNotDeleted() + 1000000000 + (Math.random()*1000000+3);
					
					byte[] decoded = Base64.decodeBase64(stringInBase64);
					File f = new File("public" + File.separator +"images" + File.separator + "avatars" + File.separator + nameImage + "." + imageTmpFormat);
					//System.out.println(f.getName());
					//System.out.println(f.getAbsolutePath());
					System.out.println(f.getPath());
					
					
					f.createNewFile();

					
					FileOutputStream fileOut = new FileOutputStream (f.getAbsolutePath());
					fileOut.write(decoded);
					fileOut.close();
					
					user.setImageUrl(File.separator + f.getPath());
				}
			}
			
			user.save();
			System.out.println("User image upload!");
		}
	}

	/**
	 * Функция поиска пользователя по базе данных
	 * @param name
	 * @return
	 */
	public static List<User> getSearchUsers(String name) {
		return JPA.em().createQuery("from User where (lower(login) like lower(:name) or lower(name) like lower(:name) or lower(email) like lower(:name)) and deleted = 'FALSE' order by id")
				.setParameter("name", "%" + name + "%").getResultList();
	}

	/**
	 * Функция поиска всех отделений по базе данных
	 * @return
	 */
	public static List<Department> getDepartments() {
		return JPA.em().createQuery("from Department where deleted = 'FALSE'").getResultList();

	}
	
	/**
	 * Получаем департаменты, которые являются детьми от департамента с полученным ID из базы данных
	 * @param id
	 * @return
	 */
	public static List<Department> getDepartmentsById(Long id) {
		return JPA.em().createQuery("from Department where deleted = 'FALSE' and parent.id = :thisId").setParameter("thisId", id).getResultList();

	}

	/**
	 * Формируем список департаментов, которые является родителями (то есть не являются поддепартаментами)
	 * @param listBase
	 * @return
	 * @throws PlatformException
	 */
	public static DepartmentTreeRootModel createDepartmentsTree(List<Department> listBase) throws PlatformException {
		DepartmentTreeRootModel root = new DepartmentTreeRootModel();
		root.setChildren(new ArrayList<DepartmentTreeModel>());
		ArrayList<Long> ids = new ArrayList<Long>();
		
		for (Department model: listBase) {
			if (model.getParent() != null)
				ids.add(model.getParent().getId());
		}
		for (Department model: listBase) {
			Boolean tmpLeaf = true;
			String icon = "tree-icons-children";

			if (AdmService.getChildrensDepartment(model.getId()) > 0l) {
				tmpLeaf = false;
				icon = "tree-icons-parent";
			}
			
			if (model.getParent() == null) {
				System.out.println(tmpLeaf);
				if (model.getType() == null) {
					DepartmentTreeModel mod = new DepartmentTreeModel(model.getId(), model.getName(), icon, model.getScore(), model.getUserCount(), "Не указан", 0l,  tmpLeaf, false);
					root.getChildren().add(mod);
				}
				else {
					DepartmentTreeModel mod = new DepartmentTreeModel(model.getId(), model.getName(), icon, model.getScore(), model.getUserCount(), model.getType().getName(), model.getType().getId(),  tmpLeaf, false);
					root.getChildren().add(mod);
				}
				
			}
		}
		return root;
	}

	/**
	 * Составляем список департаментов, которые являются детьми департамента с полученным ID
	 * @param listBase
	 * @param id
	 * @return
	 * @throws PlatformException
	 */
	public static DepartmentTreeRootModel createChildrensTree(List<Department> listBase, Long id) throws PlatformException {
		DepartmentTreeRootModel root = new DepartmentTreeRootModel();
		root.setChildren(new ArrayList<DepartmentTreeModel>());

		for (Department model: listBase) {
				System.out.println(model.getId());
				Boolean tmpLeaf = true;
				String icon = "tree-icons-children";
				
				if (AdmService.getChildrensDepartment(model.getId()) > 0l) {
					tmpLeaf = false;
					icon = "tree-icons-parent";
				}
				
				
				if (model.getType() == null) {

					DepartmentTreeModel mod = new DepartmentTreeModel(model.getId(), model.getName(), icon, model.getScore(), model.getUserCount(), "Не указан", 0l, tmpLeaf, false);
					root.getChildren().add(mod);
				}
				
				else {
					DepartmentTreeModel mod = new DepartmentTreeModel(model.getId(), model.getName(), icon, model.getScore(), model.getUserCount(), model.getType().getName(), model.getType().getId(), tmpLeaf, false);
					root.getChildren().add(mod);
				}

		}
		return root;
	}

	/**
	 * Получаем из базы данных список департаментов, которые являются детьми департамента с полученным ID
	 * @param id
	 * @return
	 * @throws PlatformException
	 */
	public static Long getChildrensDepartment(Long id) throws PlatformException {
			return (Long)JPA.em().createQuery("select count(*) from Department where parent.id = :idParent").setParameter("idParent", id).getSingleResult();
	}

	/**
	 * Получаем список всех типов департаментов из базы данных
	 * @return
	 */
	public static List<DepartmentType> getDepartmentsType() {
		return JPA.em().createQuery("from DepartmentType where deleted = 'FALSE'").getResultList();
	}

	/**
	 * Формируем спиок типов департамента
	 * @param listBase
	 * @return
	 */
	public static ArrayList<DepartmentForAdminModel> createDepartmentsType(List<DepartmentType> listBase) {
		ArrayList<DepartmentForAdminModel> models = new ArrayList<DepartmentForAdminModel>();
		for (DepartmentType model: listBase) {
			DepartmentForAdminModel type = new DepartmentForAdminModel();
			type.setId(model.getId());
			type.setCreatedDate(model.getCreatedDate().getTime());
			type.setName(model.getName());
			type.setModifiedDate(model.getModifiedDate().getTime());
			models.add(type);
		}
		return models;
	}
	
	/**
	 * Составление списка для выпадающего меню при выборе типа департамента
	 * @param listBase
	 * @return
	 */
	public static ArrayList<DepartmentForAdminModel> createComboDepartmentsType(List<DepartmentType> listBase) {
		ArrayList<DepartmentForAdminModel> models = new ArrayList<DepartmentForAdminModel>();
		DepartmentForAdminModel noType = new DepartmentForAdminModel();
		noType.setId(0l);
		noType.setName("Не указан");
		models.add(noType);
		for (DepartmentType model: listBase) {
			DepartmentForAdminModel type = new DepartmentForAdminModel();
			type.setId(model.getId());
			type.setCreatedDate(model.getCreatedDate().getTime());
			type.setName(model.getName());
			type.setModifiedDate(model.getModifiedDate().getTime());
			models.add(type);
		}
		return models;
	}
	

	/**
	 * Количество типов департаментов
	 * @return
	 */
	public static Long getCountTypeDepartments() {
		return (Long) JPA.em().createQuery("select count(*) from DepartmentType where deleted = 'FALSE'").getSingleResult();
	}

	/**
	 * Создание нового типа департамента
	 * @param models
	 * @throws PlatformException
	 */
	public static void createNewDepartmentType(DepartmentForAdminModel[] models) throws PlatformException {
		for (DepartmentForAdminModel model: models) {
			if (model == null)
				throw new PlatformException("0", "Department type model is null");

			DepartmentType type = new DepartmentType();
			
			type.setName(model.getName());
			type.save();
						
			Logger.info("Department type created successfully");
		}
		
	}

	/**
	 * Обновляем департамента, который пришел от клиента
	 * @param models
	 * @throws PlatformException
	 */
	public static void updateNewDepartmentType(DepartmentForAdminModel[] models) throws PlatformException {
		for (DepartmentForAdminModel model: models) {
			if (model == null)
				throw new PlatformException("0", "Department type model is null");

			DepartmentType type = DepartmentType.findById(model.getId());
			
			if (StringUtils.isNotEmpty(model.getName()))
				type.setName(model.getName());
			
			type.setModifiedDate(Calendar.getInstance());
			
			type.save();
						
			Logger.info("Department type updated successfully");
		}
		
	}
	

}
