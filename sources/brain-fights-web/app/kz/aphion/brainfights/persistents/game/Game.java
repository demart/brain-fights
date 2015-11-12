package kz.aphion.brainfights.persistents.game;

import java.util.Calendar;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OrderBy;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import kz.aphion.brainfights.persistents.PersistentObject;

/**
 * Игра между двумя пользователями
 * 
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "game")
public class Game extends PersistentObject {
	  
	@Id
	@GeneratedValue(generator="game_sequence")
	@SequenceGenerator(name="game_sequence",sequenceName="game_sequence", allocationSize=1)
    public Long id;
    public Long getId() { return id;}
    @Override
    public Object _key() { return getId(); }	
	
	/**
	 * Игроки
	 */
    @OneToMany(mappedBy="game")
	private List<Gamer> gamers;
	
	/**
	 * Статус игры
	 */
    @Enumerated(EnumType.STRING)
    @Column(nullable=false)
	private GameStatus status;
	
	/**
	 * Раунды игры
	 */
	//TODO НАКИКУТЬ СОРТИРОВКУ ПО ID
    @OneToMany(mappedBy="game")
    @OrderBy("id ASC")
	private List<GameRound> rounds;

    /**
     * Дата отправки приглашения
     */
    @Column(name="invitation_sent_date")
    private Calendar invitationSentDate;
    
    /**
     * Дата принятия приглашения (даже по просрочке и завершении)
     */
    @Column(name="invitation_accepted_date")
    private Calendar invitationAcceptedDate;
    
    /**
     * Дата начала игры
     */
    @Column(name="game_started_date")
    private Calendar gameStartedDate;
    
    /**
     * Дата завершения игры (по любой причине)
     */
    @Column(name="game_finished_date")
    private Calendar gameFinishedDate;

    
	public List<Gamer> getGamers() {
		return gamers;
	}

	public void setGamers(List<Gamer> gamers) {
		this.gamers = gamers;
	}

	public GameStatus getStatus() {
		return status;
	}

	public void setStatus(GameStatus status) {
		this.status = status;
	}

	public List<GameRound> getRounds() {
		return rounds;
	}

	public void setRounds(List<GameRound> rounds) {
		this.rounds = rounds;
	}

	public Calendar getInvitationSentDate() {
		return invitationSentDate;
	}

	public void setInvitationSentDate(Calendar invitationSentDate) {
		this.invitationSentDate = invitationSentDate;
	}

	public Calendar getInvitationAcceptedDate() {
		return invitationAcceptedDate;
	}

	public void setInvitationAcceptedDate(Calendar invitationAcceptedDate) {
		this.invitationAcceptedDate = invitationAcceptedDate;
	}

	public Calendar getGameStartedDate() {
		return gameStartedDate;
	}

	public void setGameStartedDate(Calendar gameStartedDate) {
		this.gameStartedDate = gameStartedDate;
	}

	public Calendar getGameFinishedDate() {
		return gameFinishedDate;
	}

	public void setGameFinishedDate(Calendar gameFinishedDate) {
		this.gameFinishedDate = gameFinishedDate;
	}

	public void setId(Long id) {
		this.id = id;
	}
    
}
