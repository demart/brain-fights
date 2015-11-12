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
	
}