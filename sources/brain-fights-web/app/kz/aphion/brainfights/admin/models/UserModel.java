package kz.aphion.brainfights.admin.models;

import kz.aphion.brainfights.models.DepartmentModel;

public class UserModel {

	public Long id;
	
	public String login;
	
	public String name;
	
	public String email;
	
	public String department;
	
	public Integer totalGames;
	
	public String score;
	
	public String imageUrl;
	
	public String password;
	
	public String position;
	
	public Long getId() {
		return id;
	}
	
	public void setId (Long id) {
		this.id = id;
	}
	
	public String getLogin () {
		return login;
	}
	
	public void setLogin (String login) {
		this.login = login;
	}
	
	public String getName () {
		return name;
	}
	
	public void setName (String name) {
		this.name = name;
	}
	
	public String getEmail () {
		return email;
	}
	
	public void setEmail (String email) {
		this.email = email;
	}
	
	public Integer getTotalGames () {
		return totalGames;
	}
	
	public void setTotalGames (Integer totalGames) {
		this.totalGames = totalGames;
	}
	
	public String getScore () {
		return score;
	}
	
	public void setScore (String score) {
		this.score = score;
	}
	
	public void setDepartment (String department) {
		this.department = department;
	}
	
	public String getDepartment () {
		return department;
	}
	
	public String getPassword () {
		return password;
	}
	
	public String getPosition() {
		return position;
	}
	
	public void setPosition(String position) {
		this.position = position;
	}

	
}
