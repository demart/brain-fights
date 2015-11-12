package kz.aphion.brainfights.persistents.game.question;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.engine.CascadeStyle;

import kz.aphion.brainfights.persistents.PersistentObject;

/**
 * Вопрос
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "question")
public class Question extends PersistentObject {

	@Id
    @GeneratedValue(generator="question_sequence")
	@SequenceGenerator(name="question_sequence",sequenceName="question_sequence", allocationSize=1)
    public Long id;
    public Long getId() {return id;}
    @Override
    public Object _key() {return getId();}	
    
	/**
	 * Категории к которой относиться данный вопрос
	 */
	@ManyToOne
	private Category category;
	
	@Enumerated(EnumType.STRING)
	@Column(nullable=false)
	private QuestionType type;
	
	@Column(length=255, nullable=false)
	private String text;
	
	@Column(name="image_url", length=255)
	private String imageUrl;
	
	@OneToMany(mappedBy="question", cascade={CascadeType.PERSIST})
	@OrderBy("id ASC")
	private List<Answer> answers;

	public Category getCategory() {
		return category;
	}

	public void setCategory(Category category) {
		this.category = category;
	}

	public QuestionType getType() {
		return type;
	}

	public void setType(QuestionType type) {
		this.type = type;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public List<Answer> getAnswers() {
		return answers;
	}

	public void setAnswers(List<Answer> answers) {
		this.answers = answers;
	}

}
