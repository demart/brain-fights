package kz.aphion.brainfights.persistents.user;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Where;

import kz.aphion.brainfights.persistents.DeviceType;
import kz.aphion.brainfights.persistents.PersistentObject;
import kz.aphion.brainfights.persistents.game.Gamer;


/**
 * Игрок
 * 
 * @author artem.demidovich
 *
 */
@Entity
@Table(name = "users")
public class User extends PersistentObject {

	public User() {
		this.lastPosition = 0;
		this.lastScore = 0;
		this.lastDrawnGames = 0;
		this.lastLoosingGames = 0;
		this.lastTotalGames = 0;
		this.lastWonGames = 0;
	}
	
    @Id
    @GeneratedValue(generator="user_sequence")
	@SequenceGenerator(name="user_sequence",sequenceName="user_sequence", allocationSize=1)
    public Long id;
    public Long getId() {return id;}
    @Override
    public Object _key() {return getId();}
	
	@Column(length=255, nullable=false)
	private String name;
	
	@Column(length=50)
	private String login;
	
	@Column(length=50)
	private String password;
	
	
	@Column(length=50)
	private String email;
	
	@Column(length=255)
	private String imageUrl;
	
	/**
	 * Токен авторизации, перезатирается каждый раз при повторной авторизации
	 */
	@Column(name="auth_token", length=50)
	private String authToken;
	
	/**
	 * Должность сотрудника
	 */
	@Column
	private String position;
	
	/**
	 * Принадлежность к орг структуре
	 */
	@ManyToOne
	private Department department;
	
	/**
	 * Игрок в играх в которых участвовал пользователь
	 */
	//@Where(clause="deleted = false")
	@OneToMany(mappedBy="user")
	private List<Gamer> gamers;

	/**
	 * Счет или рейтинг
	 */
	@Column(nullable=false)
	private Integer score;
	/**
	 * Последняя зафиксированные очки пользователя
	 * Служба раз в какой-то период времени запоминает позицию, чтобы потом показывать смещение
	 * Намример раз в неделю
	 */
	@Column(name="last_score", nullable=false, columnDefinition="integer default 0")
	private Integer lastScore;
	
	/**
	 * Последняя зафиксированная позиция в рейтинге
	 * Служба раз в какой-то период времени запоминает позицию, чтобы потом показывать смещение
	 * Намример раз в неделю
	 */
	@Column(name="last_position", nullable=false, columnDefinition="integer default 0")
	private Integer lastPosition;

	
	/**
	 * Время посденей активности
	 */
	@Column(name="last_activity_time" ,nullable=false)
	private Calendar lastActivityTime;
	
	/**
	 * Друзья пользователя
	 */
	@ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(name = "users_friends", joinColumns={@JoinColumn(name="user_id")}, inverseJoinColumns={@JoinColumn(name="friend_id")})
	private List<User> friends;
	
	/**
	 * Кому я являюсь другом
	 */
	@ManyToMany(cascade = CascadeType.ALL, mappedBy="friends")
	private List<User> invisibleFriends;
	
	// =====================
	// ==== MOBILE DEVICE ==
	// =====================
	
	/**
	 * Тип девайса
	 */
	@Enumerated(EnumType.STRING)
	@Column(name="device_type", length=50)
	private DeviceType deviceType;
	
	/**
	 * Версия операционной системы
	 */
	@Column(name="device_os_version", length=50)
	private String deviceOsVersion;
	
	/**
	 * Ключ PUSH для отправки уведомлений
	 */
	@Column(name="device_push_token", length=255)
	private String devicePushToken;

	/**
	 * Версия приложения
	 */
	@Column(name="app_version", length=50)
	private String appVersion;

	
	// =====================
	// ==== STATISTICS =====
	// =====================
	
	/**
	 * Всего игр
	 */
	@Column
	private Integer totalGames;
	
	/**
	 * Всего игр
	 */
	@Column(name="last_total_games", nullable=false, columnDefinition="integer default 0")
	private Integer lastTotalGames;
	
	
	/**
	 * Выиграно игр
	 */
	@Column
	private Integer wonGames;
	
	/**
	 * Выиграно игр
	 */
	@Column(name="last_won_games", nullable=false, columnDefinition="integer default 0")
	private Integer lastWonGames;	
	
	/**
	 * Проиграно игр
	 */
	@Column
	private Integer loosingGames;

	/**
	 * Проиграно игр
	 */
	@Column(name="last_loosing_games", nullable=false, columnDefinition="integer default 0")
	private Integer lastLoosingGames;
	
	/**
	 * Игр в ничью
	 */
	@Column
	private Integer drawnGames;
	
	/**
	 * Игр в ничью
	 */
	@Column(name="last_drawn_games", nullable=false, columnDefinition="integer default 0")
	private Integer lastDrawnGames;	
	
	/**
	 * Дата последнего обновления статистики
	 */
	@Column(name="last_statistics_update")
	private Calendar lastStatisticsUpdate;
	
	
	public String getLastStatisticsUpdateDateISO8601() {
		if (lastStatisticsUpdate != null) {
			TimeZone tz = TimeZone.getTimeZone("UTC");
			DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
			df.setTimeZone(tz);
			String timeAsISO = df.format(lastStatisticsUpdate.getTime());
			return timeAsISO;
		}
		return null;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getLogin() {
		return login;
	}
	public void setLogin(String login) {
		this.login = login;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getPosition() {
		return position;
	}
	public void setPosition(String position) {
		this.position = position;
	}
	public Department getDepartment() {
		return department;
	}
	public void setDepartment(Department department) {
		this.department = department;
	}
	public List<Gamer> getGamers() {
		return gamers;
	}
	public void setGamers(List<Gamer> gamers) {
		this.gamers = gamers;
	}
	public Integer getScore() {
		return score;
	}
	public void setScore(Integer score) {
		this.score = score;
	}
	public DeviceType getDeviceType() {
		return deviceType;
	}
	public void setDeviceType(DeviceType deviceType) {
		this.deviceType = deviceType;
	}
	public String getDeviceOsVersion() {
		return deviceOsVersion;
	}
	public void setDeviceOsVersion(String deviceOsVersion) {
		this.deviceOsVersion = deviceOsVersion;
	}
	public String getDevicePushToken() {
		return devicePushToken;
	}
	public void setDevicePushToken(String devicePushToken) {
		this.devicePushToken = devicePushToken;
	}
	public String getAppVersion() {
		return appVersion;
	}
	public void setAppVersion(String appVersion) {
		this.appVersion = appVersion;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getAuthToken() {
		return authToken;
	}
	public void setAuthToken(String authToken) {
		this.authToken = authToken;
	}
	public Calendar getLastActivityTime() {
		return lastActivityTime;
	}
	public void setLastActivityTime(Calendar lastActivityTime) {
		this.lastActivityTime = lastActivityTime;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public Integer getTotalGames() {
		return totalGames;
	}
	public void setTotalGames(Integer totalGames) {
		this.totalGames = totalGames;
	}
	public Integer getWonGames() {
		return wonGames;
	}
	public void setWonGames(Integer wonGames) {
		this.wonGames = wonGames;
	}
	public Integer getLoosingGames() {
		return loosingGames;
	}
	public void setLoosingGames(Integer loosingGames) {
		this.loosingGames = loosingGames;
	}
	public Integer getDrawnGames() {
		return drawnGames;
	}
	public void setDrawnGames(Integer drawnGames) {
		this.drawnGames = drawnGames;
	}
	public List<User> getFriends() {
		return friends;
	}
	public void setFriends(List<User> friends) {
		this.friends = friends;
	}
	public List<User> getInvisibleFriends() {
		return invisibleFriends;
	}
	public void setInvisibleFriends(List<User> invisibleFriends) {
		this.invisibleFriends = invisibleFriends;
	}
	
	public String getImageUrl () {
		return imageUrl;
	}
	
	public void setImageUrl (String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public Integer getLastScore() {
		return lastScore;
	}
	public void setLastScore(Integer lastScore) {
		this.lastScore = lastScore;
	}
	public Integer getLastPosition() {
		return lastPosition;
	}
	public void setLastPosition(Integer lastPosition) {
		this.lastPosition = lastPosition;
	}
	public Integer getLastTotalGames() {
		return lastTotalGames;
	}
	public void setLastTotalGames(Integer lastTotalGames) {
		this.lastTotalGames = lastTotalGames;
	}
	public Integer getLastWonGames() {
		return lastWonGames;
	}
	public void setLastWonGames(Integer lastWonGames) {
		this.lastWonGames = lastWonGames;
	}
	public Integer getLastLoosingGames() {
		return lastLoosingGames;
	}
	public void setLastLoosingGames(Integer lastLoosingGames) {
		this.lastLoosingGames = lastLoosingGames;
	}
	public Integer getLastDrawnGames() {
		return lastDrawnGames;
	}
	public void setLastDrawnGames(Integer lastDrawnGames) {
		this.lastDrawnGames = lastDrawnGames;
	}
	public Calendar getLastStatisticsUpdate() {
		return lastStatisticsUpdate;
	}
	public void setLastStatisticsUpdate(Calendar lastStatisticsUpdate) {
		this.lastStatisticsUpdate = lastStatisticsUpdate;
	}

}
