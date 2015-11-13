package kz.aphion.brainfights.admin.models;

import java.util.Date;

import kz.aphion.brainfights.persistents.user.AdminUserRole;

public class AdminUsersModel {

	private Long id;
	private String name;
	private String login;
	private String password;
	private Boolean isEnabled;
	private Date createdDate;
	private AdminUserRole role;
	
	public void setRole (AdminUserRole role) {
		this.role = role;
	}
	
	public AdminUserRole getRole() {
		return role;
	}
	
	public void setId (Long id) {
		this.id = id;
	}
	
	public Long getId () {
		return id;
	}
	
	public void setName (String name) {
		this.name = name;
	}
	
	public String getName () {
		return name;
	}
	
	public void setLogin (String login) {
		this.login = login;
	}
	
	public String getLogin () {
		return login;
	}
	
	public void setPassword (String password) {
		this.password = password;
	}
	
	public String getPassword () {
		return password;
	}
	
	public void setIsEnabled (Boolean isEnabled) {
		this.isEnabled = isEnabled;
	}
	
	public Boolean getIsEnabled () {
		return isEnabled;
	}
	
	public void setCreadtedDate (Date createdDate) {
		this.createdDate = createdDate;
	}
	
	public Date getCreatedDate () {
		return createdDate;
	}
	
}
