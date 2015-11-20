//
//  GameRoundQuestionAnswerModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameRoundQuestionAnswerModel : NSObject

/**
 * Идентификатор ответа
 */
@property NSUInteger id;

/**
 * Текст вопроса
 */
@property NSString* text;

/**
 *  Правильный ли ответ
 */
@property Boolean isCorrect;

/**
 * Отсутсвтует ответ на вопрос
 */
@property Boolean isMissingAnswer;

@end
