package kz.aphion.brainfights.admin.models;

import java.util.Date;

import kz.aphion.brainfights.models.DepartmentModel;

public class DepartmentForAdminModel extends DepartmentModel{
	
	private Date modifiedDate;
	private Date createdDate;
	
	public void setCreatedDate (Date createdDate) {
		this.createdDate = createdDate;
	}
	
	public void setModifiedDate (Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}
	
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
