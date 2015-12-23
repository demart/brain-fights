package kz.aphion.brainfights.admin.models;

import java.util.Date;
import java.util.List;

import kz.aphion.brainfights.persistents.game.question.Answer;
import kz.aphion.brainfights.persistents.game.question.QuestionType;

public class QuestionModel {
	private Long id;
	private String text;
	private String categoryName;
	private Long categoryId;
	private List<AnswersModel> answers;
	private Date createdDate;
	private Date modifiedDate;
	private QuestionType type;
	private String image;

	public String getImage () {
		return image;
	}
	
	public void setImage(String image) {
		this.image = image;
	}
	
	
	public Long getId () {
		return id;
	}
	
	public void setId(Long id) {
		this.id = id;
	}
	
	public String getText () {
		return text;
	}
	
	public void setText (String text) {
		this.text = text;
	}
	
	public String getCategoryName () {
		return categoryName;
	}
	
	public void setCategoryName (String categoryName) {
		this.categoryName = categoryName;
	}
	
	public Long getCategoryId () {
		return categoryId;
	}
	
	public void setCategoryId (Long categoryId) {
		this.categoryId = categoryId;
	}
	
	public List<AnswersModel> getAnswers () {
		return answers;
	}
	
	public void setAnswers (List<AnswersModel> answers) {
		this.answers = answers;
	}
	
	public void setCreatedDate (Date createdDate) {
		this.createdDate = createdDate;
	}
	
	public Date getCreatedDate () {
		return createdDate;
	}
	
	public void setModifiedDate (Date modifiedDate) {
		this.modifiedDate = modifiedDate;
	}
	
	public Date getModifiedDate () {
		return modifiedDate;
	}
	
	public void setType (QuestionType type) {
		this.type = type;
	}
	
	public QuestionType getType () {
		return type;
	}
}
