package kz.aphion.brainfights.persistents.game;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;
import kz.aphion.brainfights.persistents.game.question.Category;
import kz.aphion.brainfights.persistents.game.question.Question;

/**
 * Раунд игры
 * 
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "game_round")
public class GameRound extends PersistentObject {
	  
	@Id
	@GeneratedValue(generator="game_round_sequence")
	@SequenceGenerator(name="game_round_sequence",sequenceName="game_round_sequence", allocationSize=1)
    public Long id;
    public Long getId() { return id; }
    @Override
    public Object _key() { return getId();}

	
	/**
	 * Игра к которой относиться раунд
	 */
    @ManyToOne
	private Game game;
	
    /**
     * Владелец раунда (тот кто выбирал категорию)
     */
    @ManyToOne
    private Gamer owner;
    
    /**
     * Номер раунда
     */
    @Column(name="number")
    private Integer number;
    
	/**
	 * Выбранная категория для вопросов
	 */
    @ManyToOne
	private Category category;
	
	/**
	 * 3 вопроса в раунде
	 */
	// TODO Сортировать вопросы по ID
    @OneToMany(mappedBy="gameRound")
	private List<GameRoundQuestion> questions;
	
	/**
	 * - 
	 * - WAITING_ANSWER - Ожидает ответов второго участника
	 * - COMPLETED
	 */
	@Enumerated(EnumType.STRING)
	@Column(nullable=false)
	private GameRoundStatus status;
	
	
	public Game getGame() {
		return game;
	}
	public void setGame(Game game) {
		this.game = game;
	}
	public Category getCategory() {
		return category;
	}
	public void setCategory(Category category) {
		this.category = category;
	}
	public List<GameRoundQuestion> getQuestions() {
		return questions;
	}
	public void setQuestions(List<GameRoundQuestion> questions) {
		this.questions = questions;
	}
	public GameRoundStatus getStatus() {
		return status;
	}
	public void setStatus(GameRoundStatus status) {
		this.status = status;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Gamer getOwner() {
		return owner;
	}
	public void setOwner(Gamer owner) {
		this.owner = owner;
	}
	public Integer getNumber() {
		return number;
	}
	public void setNumber(Integer number) {
		this.number = number;
	}

}
