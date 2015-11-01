package kz.aphion.brainfights.persistents.game.question;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;

/**
 * Категории вопросов
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "category")
public class Category extends PersistentObject {

	@Id
    @GeneratedValue(generator="category_sequence")
	@SequenceGenerator(name="category_sequence",sequenceName="category_sequence", allocationSize=1)
    public Long id;
    public Long getId() {return id;}
    @Override
    public Object _key() {return getId();}	
    
	/**
	 * Название категории
	 */
	@Column(length=255, nullable=false)
	private String name;
	
	/**
	 * Цвет категории
	 */
	@Column(length=50)
	private String color;
	
	/**
	 * Картинка категории
	 */
	@Column(name="image_url", length=255)
	private String imageUrl;
	
	/**
	 * Вопросы в категории
	 */
	@OneToMany(mappedBy="category")
	private List<Question> questions;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public List<Question> getQuestions() {
		return questions;
	}

	public void setQuestions(List<Question> questions) {
		this.questions = questions;
	}
	public String getImageUrl() {
		return imageUrl;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
}
