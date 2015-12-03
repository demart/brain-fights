package kz.aphion.brainfights.models;

import kz.aphion.brainfights.persistents.user.DepartmentType;
import kz.aphion.brainfights.persistents.user.User;

/**
 * Модель справочника типов подразделений
 * @author artem.demidovich
 *
 */
public class DepartmentTypeModel {

	/**
	 * Идентификатор записи
	 */
	public Long id;
	
	/**
	 * Наименование типа подразделения
	 */
	public String name;

	/**
	 * Строит модель типа подразделения
	 * @param authorizedUser
	 * @param departmentType
	 * @return
	 */
	public static DepartmentTypeModel buildModel(User authorizedUser, DepartmentType departmentType) {
		DepartmentTypeModel model = new DepartmentTypeModel();
		model.id = departmentType.id;
		model.name = departmentType.getName();
		return model;
	}
	
}
