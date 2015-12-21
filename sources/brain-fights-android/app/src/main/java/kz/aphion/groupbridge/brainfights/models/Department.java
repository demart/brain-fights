package kz.aphion.groupbridge.brainfights.models;

import java.util.List;

/**
 * Created by alimjan on 02.11.2015.
 */
public class Department {

//    public static Department getTestDepartment(){
//        Department department = new Department();
//        department.setId(Long.valueOf(1));
//        department.setName("HR department");
//        department.setHaveChildren(false);
//        return department;
//    }
    /**
     * Идентификатор записи
     */
    public Long id;

    /**
     * Наименование подразделения
     */
    public String name;

    /**
     * Кол-во пользователь в подразделении
     */
    public Integer userCount;

    /**
     * Позиция подразделения среди таких же подразделений (Типа среди Филиалов, Департаменты)
     */
    public Integer position;

    /**
     * Рейтинг подразделения
     */
    public Integer score;

    /**
     * Рейтинг подразделения
     */
    public Integer lastScore;

    /**
     * Позиция подразделения (прошлая статистика)
     */
    public Integer lastPosition;

    /**
     * Глобальная позиции подразделения (прошлая статистика)
     */
    public Integer lastGlobalPosition;

    /**
     * Время последнего пересчета статистики
     */
    public String lastStatisticsUpdate;

    /**
     * Есть ли подразделения на уровне ниже
     */
    public Boolean haveChildren;

    /**
     * Подразделения
     */
    public List<Department> children;

    /**
     * Родительское подразделение
     */
    public Department parent;

    /**
     * Список игроков в подразделении
     */
    public List<UserProfile> users;

    /**
     * Принадлежит ли пользователь к этому подразделению
     */
    public Boolean isUserBelongs;


}
