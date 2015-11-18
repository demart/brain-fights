//
//  GameModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/17/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GamerModel.h"
#import "GameRoundModel.h"
#import "GameRoundCategoryModel.h"

@interface GameModel : NSObject

/**
 * Идентифкатор игры
 */
@property NSUInteger id;

/**
 * Статус игры
 */
@property NSString* status;

/**
 * Профиль игрока
 */
@property GamerModel* me;

/**
 * Профиль опонента
 */
@property GamerModel* oponent;

/**
 * Список игровых раундов
 */
@property NSMutableArray* gameRounds;

/**
 * Последний раунд
 */
@property GameRoundModel* lastRound;

/**
 * Если статус WAITING_ROUND. пользователь получит список категорий для выбора
 */
@property NSMutableArray* categories;

@end
