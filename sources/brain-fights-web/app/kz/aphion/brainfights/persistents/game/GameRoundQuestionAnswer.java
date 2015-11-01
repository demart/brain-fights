package kz.aphion.brainfights.persistents.game;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;
import kz.aphion.brainfights.persistents.game.question.Answer;
import kz.aphion.brainfights.persistents.game.question.Question;

/**
 * Результаты выбранных ответов на вопросы
 * 
 * @author artem.demidovich
 *
 */
@Entity
@Table(name="game_round_question_answer")
public class GameRoundQuestionAnswer extends PersistentObject {

	@Id
    @GeneratedValue(generator="game_round_question_answer_sequence")
	@SequenceGenerator(name="game_round_question_answer_sequence",sequenceName="game_round_question_answer_sequence", allocationSize=1)
    public Long id;
    public Long getId() { return id; }
    @Override
    public Object _key() { return getId(); }
	
	/**
	 * Свзяь с вопросом раунда
	 */
	@ManyToOne
	private GameRoundQuestion gameRoundQuestion;
	
	/**
	 * Ссыка на игрока в игре, чтобы закрепить чей это результат
	 */
	@ManyToOne
	private Gamer gamer;
	
	/**
	 * Ссылка на оригинальый ответ вопроса
	 */
	@ManyToOne
	private Answer answer;
	
	/**
	 * Является ли ответ правильным
	 */
	@Column(name="is_correct_answer", nullable=false, columnDefinition = "boolean default false")
	private Boolean isCorrectAnswer;
	
	//TODO Пока закоментил, может и не потребуются
	//public Question question;
	//public GameRound gameRound;
	
	public GameRoundQuestion getGameRoundQuestion() {
		return gameRoundQuestion;
	}
	public void setGameRoundQuestion(GameRoundQuestion gameRoundQuestion) {
		this.gameRoundQuestion = gameRoundQuestion;
	}
	public Gamer getGamer() {
		return gamer;
	}
	public void setGamer(Gamer gamer) {
		this.gamer = gamer;
	}
	public Answer getAnswer() {
		return answer;
	}
	public void setAnswer(Answer answer) {
		this.answer = answer;
	}
	public Boolean getIsCorrectAnswer() {
		return isCorrectAnswer;
	}
	public void setIsCorrectAnswer(Boolean isCorrectAnswer) {
		this.isCorrectAnswer = isCorrectAnswer;
	}
	public void setId(Long id) {
		this.id = id;
	}
	
}