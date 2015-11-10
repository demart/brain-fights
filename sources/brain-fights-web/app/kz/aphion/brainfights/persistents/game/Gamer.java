package kz.aphion.brainfights.persistents.game;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;
import kz.aphion.brainfights.persistents.user.User;

/**
 * Участник игры - Игрок
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "gamer")
public class Gamer extends PersistentObject {
	  
	@Id
	@GeneratedValue(generator="gamer_sequence")
	@SequenceGenerator(name="gamer_sequence",sequenceName="gamer_sequence", allocationSize=1)
    public Long id;
    public Long getId() {return id;}
    @Override
    public Object _key() {return getId();}
	
    /**
     * Ссылка на реальноо пользователя
     */
    @ManyToOne
	private User user;
	
    /**
     * Игра в которой этот игрок участвует
     */
    @ManyToOne
	private Game game;
	
    /**
     * Противник
     */
    @ManyToOne
    private Gamer oponent;
    
	/**
	 * Статус игрока в текущей игре (Ждет, Ходит и т.д.)
	 */
    @Enumerated(EnumType.STRING)
    @Column(nullable=false)
	private GamerStatus status;

	/**
	 * Дата совершения последнего изменения статуса
	 * Для эскалации и завершения игр 
	 */
    @Column(name="last_update_status_date")
	private Calendar lastUpdateStatusDate;
	
	/**
	 * Кол-во правильных ответов за игру
	 */
    @Column(name="correct_answer_count")
	private Integer correctAnswerCount = 0;

    /**
     * Счет заработанный в этой игре (Может быть плюс и минус)
     */
    @Column(nullable=false)
    private Integer score;

    /**
     * Игрок который предложил играть
     */
    @Column(name="game_initiator", nullable=false, columnDefinition="boolean default false")
    private Boolean gameInitiator;
    
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Game getGame() {
		return game;
	}

	public void setGame(Game game) {
		this.game = game;
	}

	public GamerStatus getStatus() {
		return status;
	}

	public void setStatus(GamerStatus status) {
		this.status = status;
	}

	public Calendar getLastUpdateStatusDate() {
		return lastUpdateStatusDate;
	}
	
	public String getLastUpdateStatusDateISO8601() {
		if (lastUpdateStatusDate != null) {
			TimeZone tz = TimeZone.getTimeZone("UTC");
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
			df.setTimeZone(tz);
			String timeAsISO = df.format(lastUpdateStatusDate.getTime());
			return timeAsISO;
		}
		return null;
	}

	public void setLastUpdateStatusDate(Calendar lastUpdateStatusDate) {
		this.lastUpdateStatusDate = lastUpdateStatusDate;
	}

	public Integer getCorrectAnswerCount() {
		return correctAnswerCount;
	}

	public void setCorrectAnswerCount(Integer correctAnswerCount) {
		this.correctAnswerCount = correctAnswerCount;
	}

	public Integer getScore() {
		return score;
	}

	public void setScore(Integer score) {
		this.score = score;
	}

	public void setId(Long id) {
		this.id = id;
	}
	public Boolean getGameInitiator() {
		return gameInitiator;
	}
	public void setGameInitiator(Boolean gameInitiator) {
		this.gameInitiator = gameInitiator;
	}
	public Gamer getOponent() {
		return oponent;
	}
	public void setOponent(Gamer oponent) {
		this.oponent = oponent;
	}
    
}
