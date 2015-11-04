package kz.aphion.brainfights.models.game;

import java.util.List;

/**
 * Модель описывающая категории вопросов каждого раунда
 * 
 * @author artem.demidovich
 *
 */
public class GameRoundCategoryModel {

	/**
	 * Идентификатор категории
	 */
	public Long id;
	
	/**
	 * Название категории
	 */
	public String name;
	
	/**
	 * Список вопросовов в категории
	 */
	public List<GameRoundQuestionModel> questions;
	
}
