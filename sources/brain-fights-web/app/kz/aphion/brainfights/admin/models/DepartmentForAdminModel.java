package kz.aphion.brainfights.admin.models;

import kz.aphion.brainfights.models.DepartmentModel;

public class DepartmentForAdminModel extends DepartmentModel{
	
	public Long getId () {
		return id;
	}
	
	public void setId (Long id) {
		this.id = id;
	}
	
	public String getName () {
		return name;
	}
	
	public void setName (String name) {
		this.name = name;
	}

}
