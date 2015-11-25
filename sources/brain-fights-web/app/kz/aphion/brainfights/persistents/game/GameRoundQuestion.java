package kz.aphion.brainfights.persistents.game;

import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

import kz.aphion.brainfights.persistents.PersistentObject;
import kz.aphion.brainfights.persistents.game.question.Question;

/**
 * Связь Раун = вопрос
 * 
 * @author artem.demidovich
 *
 */
@Entity
@Table(name="game_round_question")
public class GameRoundQuestion extends PersistentObject {
	  
	@Id
	@GeneratedValue(generator="game_round_question_sequence")
	@SequenceGenerator(name="game_round_question_sequence",sequenceName="game_round_question_sequence", allocationSize=1)
	public Long id;
	public Long getId() { return id; }
	@Override
	public Object _key() { return getId();}
	
	/**
	 * Ссылка на раунд
	 */
	@ManyToOne
	private GameRound gameRound;
	
	/**
	 * Ссылка на вопрос
	 */
	@ManyToOne
	private Question question;

	/**
	 * Ответы пользователей на вопросы в раунде
	 */
	//@Where(clause="deleted = false")
	@OneToMany(mappedBy="gameRoundQuestion")
	@OrderBy("id ASC")
	private List<GameRoundQuestionAnswer> questionAnswers;
	
	public GameRound getGameRound() {
		return gameRound;
	}

	public void setGameRound(GameRound gameRound) {
		this.gameRound = gameRound;
	}

	public Question getQuestion() {
		return question;
	}

	public void setQuestion(Question question) {
		this.question = question;
	}

	public List<GameRoundQuestionAnswer> getQuestionAnswers() {
		return questionAnswers;
	}

	public void setQuestionAnswers(List<GameRoundQuestionAnswer> questionAnswers) {
		this.questionAnswers = questionAnswers;
	}
	
}
