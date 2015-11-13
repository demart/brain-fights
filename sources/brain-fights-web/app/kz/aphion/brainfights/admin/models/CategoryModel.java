package kz.aphion.brainfights.admin.models;

import java.util.Date;

public class CategoryModel {
	private Long id;
	private String name;
	private String color;
	private String imageUrl;
	private Long questionsCount;
	private Date createdDate;
	private Date modifiedDate;
	
	public void setQuestionsCount (Long questionsCount) {
		this.questionsCount = questionsCount;
	}
	
	public void setCreatedDate (Date createdDate){
		this.createdDate = createdDate;
	}
	
	public Date getCreatedDate () {
		return createdDate;
	}
	
	public void setModifiedDate (Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}
	
	public Date getModifidDate () {
		return modifiedDate;
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
	
	public String getColor () {
		return color;
	}
	
	public void setColor (String color) {
		this.color = color;
	}
	
	public void setImage (String imageUrl) {
		this.imageUrl = imageUrl;
	}
	
	public String getImage () {
		return imageUrl;
	}
	
	
}
