//
//  GameRoundStatus.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/18/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Ожидает ответов от обоих участников
 */
static NSString* GAME_ROUND_STATUS_WAITING = @"WAITING_ANSWER";

/**
 * Раунд закончен (Все участники ответили)
 */
static NSString* GAME_ROUND_STATUS_COMPLETED = @"COMPLETED";


@interface GameRoundStatus : NSObject

@end
