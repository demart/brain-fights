//
//  UserGamePlayingStatus.h
//  BrainFights
//
//  Created by Artem Demidovich on 12/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Готов играть
 */
//READY,

/**
 * Играет сейчас со мной
 */
//PLAYING,

/**
 * Отпарвили игроку предложение
 */
//INVITED,

/**
 * Игрок ожидает нашего решения
 */
//WAITING,

/**
 * Готов играть
 */
static NSString *USER_GAME_PLAYING_STATUS_READY = @"READY";

/**
 * Играет сейчас со мной
 */
static NSString *USER_GAME_PLAYING_STATUS_PLAYING = @"PLAYING";

/**
 * Отпарвили игроку предложение
 */
static NSString *USER_GAME_PLAYING_STATUS_INVITED = @"INVITED";

/**
 * Игрок ожидает нашего решения
 */
static NSString *USER_GAME_PLAYING_STATUS_WAITING = @"WAITING";


@interface UserGamePlayingStatus : NSObject

@end
