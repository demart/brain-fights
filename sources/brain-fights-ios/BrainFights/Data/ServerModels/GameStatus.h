//
//  GameStatus.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Ожидаем начала игры
 */
static NSString *GAME_STATUS_WAITING = @"WAITING";

/**
 * Играем
 */
static NSString *GAME_STATUS_STARTED = @"STARTED";

/**
 * Игра закончена (с каким то результатом)
 */
static NSString *GAME_STATUS_FINISHED = @"FINISHED";

@interface GameStatus : NSString

@end
