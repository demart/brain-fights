package kz.aphion.brainfights.services;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kz.aphion.brainfights.exceptions.AuthorizationException;
import kz.aphion.brainfights.exceptions.ErrorCode;
import kz.aphion.brainfights.exceptions.PlatformException;
import kz.aphion.brainfights.models.DepartmentModel;
import kz.aphion.brainfights.models.DepartmentTypeModel;
import kz.aphion.brainfights.models.search.DepartmentSearchResultModel;
import kz.aphion.brainfights.persistents.user.Department;
import kz.aphion.brainfights.persistents.user.DepartmentType;
import kz.aphion.brainfights.persistents.user.User;
import play.db.jpa.JPA;

/**
 * Сервис для работы со структурой организации
 * 
 * @author artem.demidovich
 *
 */
public class DepartmentService {
	
	private static Map<Long, Integer> mapOfUsersCountInDeps = new HashMap<Long, Integer>();
	private static Map<Long, Integer> mapOfScoreInDeps = new HashMap<Long, Integer>();

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
		
		mapOfUsersCountInDeps.clear();
		mapOfScoreInDeps.clear();
		
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
				totalUserCount += mapOfUsersCountInDeps.get(child.getId());
				
				if (mapOfUsersCountInDeps.get(child.getId()) > 0) {
					totalCount += 1;
					totalScore += mapOfScoreInDeps.get(child.getId());
				}
				/*
				totalScore += child.getScore();
				totalCount += 1;
				if (child.getUsers() != null)
					totalUserCount += child.getUsers().size();
					*/
			}
		
	//	int paramDivision = 1;
	
		// Посчитаем рейтинг пользователей
		if (department.getUsers() != null) {
			for (User user : department.getUsers()) {
				totalScore += user.getScore();
				totalCount +=1;
		//		paramDivision = 10;
			}
			totalUserCount += department.getUsers().size();
		}
		
		
		int avarageScore = 0;
		
		if (totalCount != 0) {
			avarageScore = totalScore/totalCount;
			
			if (avarageScore == 0 && totalScore > 0)
				avarageScore = 1;
			
			department.setScore(avarageScore);
		
		} else {
			department.setScore(0);
		}
		
		department.setUserCount(totalUserCount);
		
		mapOfUsersCountInDeps.put(department.getId(), totalUserCount);
		mapOfScoreInDeps.put(department.getId(), avarageScore);
		
		department.save();
	}
	
	/**
	 * Возращает список доступных моделей типов подразделений
	 * @param authorizedUser
	 * @return
	 * @throws AuthorizationException
	 */
	public static List<DepartmentTypeModel> getDepartmentTypes(User authorizedUser) throws AuthorizationException {
		if (authorizedUser == null)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "authorized user is null");
		
		List<DepartmentType> objects = DepartmentType.find("deleted = false").fetch();
		if (objects == null)
			return null;
		
		List<DepartmentTypeModel> models = new ArrayList<DepartmentTypeModel>();
		for (DepartmentType departmentType : objects) {
			DepartmentTypeModel model = DepartmentTypeModel.buildModel(authorizedUser, departmentType);
			models.add(model);
		}
		
		return models;
	}
	
	
	/**
	 * Возвращает список департаментов по указанному типу подразделения
	 * @param authorizedUser
	 * @param departmentTypeId
	 * @param page
	 * @param limit
	 * @return
	 * @throws PlatformException
	 */
	public static List<DepartmentModel> getDepartmentStatisticsByType(User authorizedUser, Long departmentTypeId, Integer page, Integer limit) throws PlatformException {
		if (authorizedUser == null)
			throw new AuthorizationException(ErrorCode.AUTH_ERROR, "authorized user is null");
		
		List<Department> objects = Department.find("deleted = false and type.id = ? order by score DESC, userCount ASC", departmentTypeId).fetch(page, limit);
		if (objects == null)
			return null;
		
		List<DepartmentModel> models = new ArrayList<DepartmentModel>();
		for (Department department : objects) {
			DepartmentModel model = DepartmentModel.buildModel(authorizedUser, department);
			models.add(model);
		}
		
		return models;
	}
	
	/**
	 * Возвращает позицию департамента оносительно других в указанном типе подразделения
	 * @param user
	 * @return
	 */
	public static Integer getDepartmentPosition(Department department) {
		List<Object> result;
		if (department.getType() != null) {
			result = JPA.em().createNativeQuery("select o.rownum from (select row_number() over (order by score DESC, usercount ASC) as rownum, * from department where deleted = false and score >= :score and type_id = :typeId order by score DESC, usercount ASC) as o where o.id = :departmentId")
					.setParameter("score", department.getScore())
					.setParameter("departmentId", department.getId())
					.setParameter("typeId", department.getType().getId())
					.getResultList();
		} else {
			result = JPA.em().createNativeQuery("select o.rownum from (select row_number() over (order by score DESC, usercount ASC) as rownum, * from department where deleted = false and score >= :score and type_id is null order by score DESC, usercount ASC) as o where o.id = :departmentId")
					.setParameter("score", department.getScore())
					.setParameter("departmentId", department.getId())
					.getResultList();
		}
		BigInteger resultCount = null;
		if (result != null && result.size() > 0)
			resultCount = (BigInteger)result.get(0);
		
		if (resultCount == null)
			return -1;
		
		return resultCount.intValue();
	}
	
}