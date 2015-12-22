package kz.aphion.groupbridge.brainfights.models;

import java.util.List;

/**
 * Created by alimjan on 11.11.2015.
 */
public class DepartmentModel {
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
     * Рейтинг подразделения
     */
    public Integer score;

    /**
     * Есть ли подразделения на уровне ниже
     */
    public Boolean haveChildren;

    /**
     * Подразделения
     */
    public List<DepartmentModel> children;

    /**
     * Родительское подразделение
     */
    public DepartmentModel parent;

    /**
     * Список игроков в подразделении
     */
    public List<UserProfile> users;

    /**
     * Принадлежит ли пользователь к этому подразделению
     */
    public Boolean isUserBelongs;
}
