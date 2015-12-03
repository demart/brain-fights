package kz.aphion.brainfights.persistents.user;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;

/**
 * Класс единицы организации. 
 * Представляет собой иерахический справочник структуры организации.
 * 
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "department")
public class Department extends PersistentObject {
    
	@Id
    @GeneratedValue(generator="department_sequence")
	@SequenceGenerator(name="department_sequence",sequenceName="department_sequence", allocationSize=1)
    public Long id;
    public Long getId() {return id;}
    @Override
    public Object _key() {return getId();}
    
	/**
	 * Наименование организации
	 */
	@Column(length=255, nullable=false)
	private String name;
	
	/**
	 * Ссылка на справочник типов подразделений
	 */
	@ManyToOne
	private DepartmentType type;	
	
	/**
	 * Ссылка на родителя
	 */
	@ManyToOne
	private Department parent;
	
	/**
	 * Список всех дочерних подразделений
	 */
	@OneToMany(mappedBy="parent")
	private List<Department> children;
	
	/**
	 * Рейтинг усредненный по всем подразделениям
	 */
	@Column(nullable=false)
	private Integer score;
	
	/**
	 * Кол-во игроков внутри всех подразделений
	 */
	@Column(nullable=false)
	private Integer userCount;
	
	/**
	 * Список пользователей
	 */
	@OneToMany(mappedBy="department")
	private List<User> users;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Department getParent() {
		return parent;
	}

	public void setParent(Department parent) {
		this.parent = parent;
	}

	public List<Department> getChildren() {
		return children;
	}

	public void setChildren(List<Department> children) {
		this.children = children;
	}

	public Integer getScore() {
		return score;
	}

	public void setScore(Integer scrore) {
		this.score = scrore;
	}

	public Integer getUserCount() {
		return userCount;
	}

	public void setUserCount(Integer userCount) {
		this.userCount = userCount;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}
	public DepartmentType getType() {
		return type;
	}
	public void setType(DepartmentType type) {
		this.type = type;
	}
	
}
