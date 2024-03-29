package kz.aphion.brainfights.models.game;

import java.util.ArrayList;
import java.util.List;

import kz.aphion.brainfights.persistents.game.question.Category;

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
	 * Цвет кагории, не понятно как передавать пока
	 */
	public String color;
	
	/**
	 *  URL для скачивания картинки вопроса
	 */
	public String imageUrl;
	
	/**
	 * Картинка вопроса Base64
	 */
	public String imageUrlBase64;
	
	/**
	 * Список вопросовов в категории
	 */
	public List<GameRoundQuestionModel> questions;

	public static GameRoundCategoryModel buildModel(Category category) {
		GameRoundCategoryModel model = new GameRoundCategoryModel();
		
		model.id = category.id;
		model.name = category.getName();
		model.color = category.getColor();
		model.imageUrl = category.getImageUrl();
		model.imageUrlBase64 = null; // TODO нужно или нет, когда определимся
		
		return model;
	}
	
}
