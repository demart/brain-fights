package kz.aphion.brainfights.persistents.game.question;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;

/**
 * Ответы на вопросы
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "answer")
public class Answer extends PersistentObject {
	  
	@Id
    @GeneratedValue(generator="answer_sequence")
	@SequenceGenerator(name="answer_sequence",sequenceName="answer_sequence", allocationSize=1)
    public Long id;
    public Long getId() {return id;}
    @Override
    public Object _key() {return getId();}
    
	/**
	 * Вопрос к которому относится ответ
	 */
	@ManyToOne
	private Question question;
	
	/**
	 * Текст ответа
	 */
	@Column(length=100, nullable=false)
	private String name;
	
	/**
	 * Правильный ли ответ
	 */
	@Column(nullable=false, columnDefinition = "boolean default false")
	private Boolean correct;

	public Question getQuestion() {
		return question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Boolean getCorrect() {
		return correct;
	}

	public void setCorrect(Boolean correct) {
		this.correct = correct;
	}
	
}