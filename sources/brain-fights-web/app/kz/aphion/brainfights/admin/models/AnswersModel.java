package kz.aphion.brainfights.admin.models;

public class AnswersModel {
	private Long id;
	private String name;
	private Boolean correct;
	
	public void setName (String name) {
		this.name = name;
	}
	
	public String getName () {
		return name;
	}
	
	public void setId (Long id) {
		this.id=id;
	}
	
	public Long getId (){
		return id;
	}
	
	public void setCorrect (Boolean correct) {
		this.correct = correct;
	}
	
	public Boolean getCorrect  () {
		return correct;
	}

}
