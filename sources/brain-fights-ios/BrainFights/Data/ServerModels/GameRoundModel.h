//
//  GameRoundModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameRoundQuestionModel.h"
#import "GameRoundStatus.h"
#import "GameRoundCategoryModel.h"

@interface GameRoundModel : NSObject
/**
 * Идентификатор раунда
 */
@property NSUInteger id;

/**
 * Название категории
 */
@property NSString* categoryName;

/**
 * Статус раунда
 */
@property NSString* status;

/**
 * Вопросы в раунде
 */
@property NSMutableArray* questions;

/**
 * Категория вопросов раунда
 */
@property GameRoundCategoryModel* category;

@end
