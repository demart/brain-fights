package kz.aphion.brainfights.services;

import play.Logger;
import play.db.jpa.JPA;
import java.util.List;
import java.util.ArrayList;
import java.util.Calendar;

import org.apache.commons.lang.StringUtils;
import javax.persistence.Query;

import kz.aphion.brainfights.persistents.game.question.Answer;
import kz.aphion.brainfights.persistents.game.question.Category;
import kz.aphion.brainfights.persistents.game.question.Question;
import kz.aphion.brainfights.persistents.game.question.QuestionType;
import kz.aphion.brainfights.persistents.user.*;
import kz.aphion.brainfights.admin.models.AdminUsersModel;
import kz.aphion.brainfights.admin.models.CategoryModel;
import kz.aphion.brainfights.admin.models.QuestionModel;
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
	public static void createNewCategory(CategoryModel[] models) throws PlatformException {
		for (CategoryModel model: models) {
			if (model == null)
				throw new PlatformException("0", "Category model is null");
			
			Category category = new Category();
			
			
			if (StringUtils.isNotEmpty(model.getName()))
				category.setName(model.getName());
			
			if (StringUtils.isNotEmpty(model.getColor()))
				category.setColor(model.getColor());
			
			if (StringUtils.isNotEmpty(model.getImage()))
				category.setImageUrl(model.getImage());
		
			category.save();
			
			Logger.info("Category created successfully");
		}
				
	}
	
	/**
	 * Редактирование категории
	 * @param models
	 * @throws PlatformException
	 */
	public static void updateCategory(CategoryModel[] models) throws PlatformException {
		
		for (CategoryModel model: models) {
			if (model == null)
				throw new PlatformException("0", "Category model is null");
			
			Category category = Category.findById(model.getId());
			if (category == null)
				throw new PlatformException ("0", "Category not found");
			
			if (StringUtils.isNotEmpty(model.getName()))
				category.setName(model.getName());
			
			if (StringUtils.isNotEmpty(model.getColor()))
				category.setColor(model.getColor());
			
			if (StringUtils.isNotEmpty(model.getImage()))
				category.setImageUrl(model.getImage());
			

		
			category.save();
			
			Logger.info("Category updated successfully");
		}
		
	}

	/**
	 * Создание вопроса
	 * @param models
	 * @throws PlatformException
	 */
	public static void createQuestion(QuestionModel[] models) throws PlatformException{
		
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
			question.setType(QuestionType.TEXT);
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
	public static void updateQuestion(QuestionModel[] models) throws PlatformException{
		
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

				
			question.setImageUrl("0");
			question.setType(QuestionType.TEXT);
			question.setModifiedDate(Calendar.getInstance());
			
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
				System.out.println(question.getAnswers().get(0).getName());
				//question.setAnswers(listModels);
			}
			
			question.save();
			
					
			Logger.info("Question updated successfully");
			
			List<Answer> listAnswer = JPA.em().createQuery("from Answer where question.id = :idQuest order by id asc").setParameter("idQuest", model.getId()).getResultList();
			ArrayList<Long> ids = new ArrayList<Long>(0);
			Integer t = 0;
			for(Answer anrs: listAnswer) {
				if (t < 4) {
					ids.add(anrs.getId());
					t++;
				}
			}
			JPA.em().createQuery("delete Answer where id in (:ids)").setParameter("ids", ids).executeUpdate();
			
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
					ans.setName(answers.getName());
					System.out.println(answers.getName());
					ans.setCorrect(answers.getCorrect());
					question.getAnswers().add(ans);
				}
			question.setId(model.getId());
			question.setCategoryName(model.getCategory().getName());
			question.setCategoryId(model.getCategory().getId());
			question.setCreatedDate(model.getCreatedDate().getTime());
			question.setModifiedDate(model.getModifiedDate().getTime());
			
			
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
}
