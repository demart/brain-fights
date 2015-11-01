package kz.aphion.brainfights.persistents.user;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;

/**
 * Пользователь системы управления игрой 
 * 
 * @author artem.demidovich
 *
 */
@Entity
@Table(name="admin_user")
public class AdminUser extends PersistentObject {

    @Id
    @GeneratedValue(generator="admin_user_sequence")
	@SequenceGenerator(name="admin_user_sequence",sequenceName="admin_user_sequence", allocationSize=1)
    public Long id;
    public Long getId() {return id;}
    @Override
    public Object _key() {return getId();}

	/**
	 * Наименование
	 */
	@Column(nullable=false)
	private String name;
	
	/**
	 * Логин для входа
	 */
	@Column(nullable=false)
	private String login;
	
	/**
	 * Пароль, должен быть MD5
	 */
	@Column(nullable=false)
	private String password;
	
	/**
	 * Включена ли учетная запись
	 */
	@Column(nullable=false, columnDefinition = "boolean default true")
	private Boolean enabled;
	
	/**
	 * Роль пользователя
	 */
	@Enumerated(EnumType.STRING)
	@Column(nullable=false)
	private AdminUserRole role;
	
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLogin() {
		return login;
	}
	public void setLogin(String login) {
		this.login = login;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public Boolean getEnabled() {
		return enabled;
	}
	public void setEnabled(Boolean enabled) {
		this.enabled = enabled;
	}
	public AdminUserRole getRole() {
		return role;
	}
	public void setRole(AdminUserRole role) {
		this.role = role;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
}
