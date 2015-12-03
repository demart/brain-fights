package kz.aphion.brainfights.models;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.persistents.user.Department;
import kz.aphion.brainfights.persistents.user.User;
import kz.aphion.brainfights.services.UserService;

/**
 * Модель организационной структуры
 * 
 * @author artem.demidovich
 *
 */
public class DepartmentModel {

	/**
	 * Идентификатор записи
	 */
	public Long id;
	
	/**
	 * Наименование подразделения
	 */
	public String name;
	
	/**
	 * Кол-во пользователь в подразделении
	 */
	public Integer userCount;
	
	/**
	 * Рейтинг подразделения
	 */
	public Integer score;
	
	/**
	 * Есть ли подразделения на уровне ниже
	 */
	public Boolean haveChildren;
	
	/**
	 * Подразделения
	 */
	public List<DepartmentModel> children;
	
	/**
	 * Родительское подразделение
	 */
	public DepartmentModel parent;
	
	/**
	 * Список игроков в подразделении
	 */
	public List<UserProfileModel> users;
	
	/**
	 * Принадлежит ли пользователь к этому подразделению
	 */
	public Boolean isUserBelongs;
	
	/**
	 * Возвращает модель организационной структуры
	 * 
	 * @param authorizedUser авторизованный пользователь
	 * @param unit подразделение организационной структуры
	 * @return
	 * @throws PlatformException 
	 */
	public static DepartmentModel buildModel(User authorizedUser, Department department) throws PlatformException {
		if (authorizedUser == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "authorizedUser is null");
		if (department == null)
			throw new PlatformException(ErrorCode.VALIDATION_ERROR, "unit is null");
		
		DepartmentModel model = new DepartmentModel();
		model.id = department.id;
		model.name = department.getName();
		model.score = department.getScore();
		model.userCount = department.getUserCount();
		
		// TODO хреновая проверка, нужно кэшировать походу так как структура статична
		model.haveChildren = department.getChildren() != null && department.getChildren().size() > 0 ? true : false;
		
		model.isUserBelongs = UserService.isUserBelongsToDepartment(authorizedUser, department);
		
		model.users = new ArrayList<>();
		if (department.getUsers() != null && department.getUsers().size() > 0) {
			for (User user : department.getUsers()) {
				if (user == null)
					continue;
				
				UserProfileModel userProfileModel = UserProfileModel.buildModel(authorizedUser, user);
				model.users.add(userProfileModel);
			}
		}
		
		return model;
	}
	
}
