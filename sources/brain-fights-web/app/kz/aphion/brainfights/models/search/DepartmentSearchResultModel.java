package kz.aphion.brainfights.models.search;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.brainfights.models.DepartmentModel;

/**
 * Модель результатов поиска подразделений
 * 
 * @author artem.demidovich
 *
 */
public class DepartmentSearchResultModel {

	/**
	 * Подразделения
	 */
	public List<DepartmentModel> departments;
	
	/**
	 * Кол-во найденных подразделений
	 */
	public Integer count;
	
	
	public DepartmentSearchResultModel() {
		this.count = 0;
		this.departments = new ArrayList<>();
	}
	
}
