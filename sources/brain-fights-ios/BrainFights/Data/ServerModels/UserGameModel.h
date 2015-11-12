//
//  UserGameModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GameStatus.h"
#import "GamerStatus.h"
#import "GamerModel.h"

@interface UserGameModel : NSObject

/**
 * Идентификатор игры
 */
@property NSUInteger id;

/**
 * Статус игры
 */
@property NSString *gameStatus;

/**
 * Мой статус в игре
 */
@property NSString *gamerStatus;

/**
 * Я в игре
 */
@property GamerModel *me;

/**
 * Опонент
 */
@property GamerModel *oponent;


@end
