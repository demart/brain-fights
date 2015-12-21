package kz.aphion.groupbridge.brainfights.models;

/**
 * Created by alimjan on 02.11.2015.
 */
public class UserProfile {

    public static UserProfile getTestUser(){
        UserProfile profile = new UserProfile();
        profile.id = Long.valueOf(1);
        profile.type = UserType.ME;
        profile.name = "Sasha Gray";
        profile.position = "HR Manager";
        profile.login = "login";
        profile.email = "sashka@mail.com";
        profile.totalGames = 10;
        profile.wonGames = 6;
        profile.loosingGames = 4;
        profile.drawnGames = 0;
        profile.score = 666;
        profile.gamePosition=23;
//        profile.department = Department.getTestDepartment();
        return profile;
    }

    // COMMON INFO

    public Long id;

    /**
     * Тип пользователя
     */
    public UserType type;

    /**
     * Имя пользователя
     */
    public String name;

    /**
     * Должность пользователя
     */
    public String position;

    /**
     * Аватар пользователя
     */
    public String imageUrl;

    /**
     * Логин пользователя
     */
    public String login;

    /**
     * Почтовый ящик пользователя
     */
    public String email;

    /**
     * Подразделение где работает ползователь (скорее всего отдел)
     */
    //public String organizationUnit;

    /**
     * Полная цепочка организационный структуры от начала до отдела где работает пользователь
     * Астана -> Упралвение око -> Департамент услуг -> Отдел ...
     */
    //public String fullOrganizationPath;

    /**
     * Иерархическая структура к которой относиться данный пользователь
     */
    public Department department;

    // STATISTIC

    /**
     * Всего игр
     */
    public Integer totalGames;

    /**
     * Всего игр
     */
    public Integer lastTotalGames;

    /**
     * Выиграно игр
     */
    public Integer wonGames;

    /**
     * Выиграно игр
     */
    public Integer lastWonGames;

    /**
     * Проиграно игр
     */
    public Integer loosingGames;

    /**
     * Проиграно игр
     */
    public Integer lastLoosingGames;

    /**
     * Игр в ничью
     */
    public Integer drawnGames;

    /**
     * Игр в ничью
     */
    public Integer lastDrawnGames;

    /**
     * Рейтинг пользоваля
     */
    public Integer score;

    /**
     * Рейтинг пользоваля
     */
    public Integer lastScore;

    /**
     * Позиция пользователя относиться всех остальных игроков
     */
    public Integer gamePosition;

    /**
     * Позиция пользователя относиться всех остальных игроков
     */
    public Integer lastGamePosition;

    /**
     * Время последнего пересчета статистики
     */
    public String lastStatisticsUpdate;

    /**
     * Состояние игрового процесса по отношению к пользователю.
     * (Играем или не играем с пользователем)
     */
    public UserGamePlayingStatus playStatus;



    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public UserType getType() {
        return type;
    }

    public void setType(UserType type) {
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getLogin() {
        return login;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
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

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

    public Integer getGamePosition() {
        return gamePosition;
    }

    public void setGamePosition(Integer gamePosition) {
        this.gamePosition = gamePosition;
    }
}
