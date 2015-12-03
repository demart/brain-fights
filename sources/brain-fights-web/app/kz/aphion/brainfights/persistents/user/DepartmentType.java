package kz.aphion.brainfights.persistents.user;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;

/**
 * Тип подразделения 
 * Представляет собой плоский справочник типов подразделений.
 * (Наприме: Филиал, Департамент, Управление, Отдел и т.д.)
 * 
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "department_type")
public class DepartmentType extends PersistentObject {

	@Id
    @GeneratedValue(generator="department_type_sequence")
	@SequenceGenerator(name="department_type_sequence",sequenceName="department_type_sequence", allocationSize=1)
    public Long id;
    public Long getId() {return id;}
    @Override
    public Object _key() {return getId();}
    
	/**
	 * Наименование типа подразделения
	 */
	@Column(length=255, nullable=false)
	private String name;
		
	/**
	 * Список всех подразделений c указанным типом
	 */
	@OneToMany(mappedBy="type")
	private List<Department> departments;
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<Department> getDepartments() {
		return departments;
	}
	public void setDepartments(List<Department> departments) {
		this.departments = departments;
	}
	
}
