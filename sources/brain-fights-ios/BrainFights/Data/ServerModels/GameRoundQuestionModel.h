//
//  GameRoundQuestionModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionType.h"
#import "GameRoundQuestionAnswerModel.h"

@interface GameRoundQuestionModel : NSObject

/**
 * Идентификатор вопроса
 */
@property NSUInteger id;

/**
 * Тип вопроса
 * QuestionType
 */
@property NSString* type;

/**
 * Текст вопроса
 */
@property NSString* text;

/**
 *  URL для скачивания картинки вопроса
 */
@property NSString* imageUrl;

/**
 * Картинка вопроса Base64
 */
@property NSString* imageUrlBase64;

/**
 * Возможные ответы на вопросы
 */
@property NSMutableArray* answers;

/**
 * Ответ выбранный пользователем (Если он отвечал уже
 */
@property GameRoundQuestionAnswerModel* answer;

/**
 * Ответ другого пользователя если он уже прошел свою часть
 */
@property GameRoundQuestionAnswerModel* oponentAnswer;

@end
