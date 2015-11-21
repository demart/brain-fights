package kz.aphion.brainfights.services;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.brainfights.exceptions.AuthorizationException;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.DepartmentModel;
import kz.aphion.brainfights.models.search.DepartmentSearchResultModel;
import kz.aphion.brainfights.persistents.user.Department;
import kz.aphion.brainfights.persistents.user.User;
import play.db.jpa.JPA;

/**
 * Сервис для работы со структурой организации
 * 
 * @author artem.demidovich
 *
 */
public class DepartmentService {

	/**
	 * Метод возвращает модель организационной структуры на заданном уровне иерархии
	 * 
	 * @param authorizedUser авторизованный пользователь
	 * @param rootId 
	 * @throws PlatformException 
	 */
	public static DepartmentSearchResultModel getChildren(User authorizedUser, Long parentId) throws PlatformException {
		if (authorizedUser == null)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "authorized user is null");
		
		List<Department> departments = null; 

		if (parentId == null) {
			// Возвращает рут ноды
			departments = JPA.em().createQuery("from Department where parent is null and deleted = false")
					.getResultList();			
		} else {
			// Возвращает детей
			departments = JPA.em().createQuery("from Department where parent.id = :parentId and deleted = false")
					.setParameter("parentId", parentId)
					.getResultList();
		}
		
		DepartmentSearchResultModel model = new DepartmentSearchResultModel();
		if (departments == null || departments.size() == 0)
			return model;
		
		model.count = departments.size();
		model.departments = new ArrayList<>();
		
		for (Department department : departments) {
			if (department == null)
				continue;
			
			DepartmentModel departmentModel = DepartmentModel.buildModel(authorizedUser, department);
			model.departments.add(departmentModel);
		}
		
		return model;
	}
	

	/**
	 * Возвращает всю иерархию в организации
	 * 
	 * @param user
	 * @return
	 * @throws PlatformException 
	 */
	@Deprecated
	public static String getFullOrganzationStructure(Department unit) throws PlatformException{
		if (unit == null)
			//throw new PlatformException(ErrorCode.VALIDATION_ERROR, "unit is null");
			return "";
		
		if (unit.getParent() != null) {
			return getFullOrganzationStructure(unit.getParent()) + "->" + unit.getName();
		} else {
			return unit.getName();
		}
	}
	
	/**
	 * Возвращает всю иерархию в организации
	 * 
	 * @param user
	 * @return
	 * @throws PlatformException 
	 */
	public static DepartmentModel getDepartmentTree(Department department) throws PlatformException{
		if (department == null)
			return null;
		DepartmentModel result = null;
		if (department.getParent() != null) {
			result = getDepartmentTree(department.getParent());
		}
		
		DepartmentModel model = new DepartmentModel();
		model.id = department.id;
		model.name = department.getName();
		
		model.parent = result;
		//model.children = new ArrayList<>();
		//model.children.add(result);		
		
		return model;
	}
	
	/**
	 * Возвращает указанный объект организационной структуры
	 * @param authorizedUser авторизованный пользователь
	 * @param id идентификатор орг структуры
	 * @return модель орг структуры
	 * @throws PlatformException 
	 */
	public static DepartmentModel getDepartment(User authorizedUser, Long id) throws PlatformException {
		if (authorizedUser == null)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "authorized user is null");
		
		Department department = Department.findById(id);
		if (department == null)
			throw new PlatformException(ErrorCode.DATA_NOT_FOUND, "department is null, not found");
		
		DepartmentModel model = DepartmentModel.buildModel(authorizedUser, department);
		return model;
	}


	/**
	 * Метод обновляет рейнтинги всех департаментов и колличество игроков в каждом
	 */
	public static void updateDepartmentStatistics() {
		List<Department> departments = Department.find("from Department where parent=null and deleted = false").fetch();
		
		for (Department department : departments) {
			updateDepartmentStatisticsRecursive(department);
		}

		// Получить последний уровень подразделения
		// посчитать кол-во пользователей
		// Посчитать входящие подразделения
		// Посчитать средний рейтинг (пользователи + подразделения
		// Сохранить изменения
	}
	
	
	/***
	 * Пробегается рекурсивно по департаментам, выставляет колличество пользователей и т.д. 
	 * @param department
	 */
	private static void updateDepartmentStatisticsRecursive(Department department) {
		// Рекурсивно посчитать у детей
		if (department.getChildren() != null)
			for (Department child : department.getChildren()) {
				updateDepartmentStatisticsRecursive(child);
			}
		
		// Делаем подсчеты
		int totalScore = 0;
		int totalCount = 0;
		int totalUserCount = 0;
		
		// Подсчитаем рейтинг внутренних департаментов
		if (department.getChildren() != null)
			for (Department child : department.getChildren()) {
				totalScore += child.getScrore();
				totalCount += 1;
				if (child.getUsers() != null)
					totalUserCount += child.getUsers().size();
			}
		
		// Посчитаем рейтинг пользователей
		if (department.getUsers() != null) {
			for (User user : department.getUsers()) {
				totalScore += user.getScore();
				totalCount +=1;
			}
			totalUserCount += department.getUsers().size();
		}
		
		if (totalCount != 0) {
			int avarageScore = totalScore / totalCount;
			department.setScrore(avarageScore);
		} else {
			department.setScrore(0);
		}
		
		department.setUserCount(totalUserCount);
		
		department.save();
	}
	
}