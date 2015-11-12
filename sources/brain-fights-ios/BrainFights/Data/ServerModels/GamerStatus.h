//
//  GamerStatus.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>


/// СТАТУСЫ ПРИГЛАШЕНИЯ НА ИГРУ

/**
 * Ожидает подтверждения другого участника (для того чтобы начтаь играть)
 */
static NSString *GAMER_STATUS_WAITING_OPONENT_DECISION = @"WAITING_OPONENT_DECISION";

/**
 * Необходимо принять решение играть или не играть.
 */
static NSString *GAMER_STATUS_WAITING_OWN_DECISION = @"WAITING_OWN_DECISION";


/// СТАТУСЫ ИГРЫ

/**
 * Необходимо принять решение играть или не играть.
 */
static NSString *GAMER_STATUS_WAITING_OPONENT = @"WAITING_OPONENT";

/**
 * Ожидает создания нового раунда
 */
static NSString *GAMER_STATUS_WAITING_ROUND = @"WAITING_ROUND";

/**
 * Статус сообщает о том что нужно ответить на вопросы
 */
static NSString *GAMER_STATUS_WAITING_ANSWERS = @"WAITING_ANSWERS";


/// СТАТУСЫ ЗАВЕРШЕНИЯ ИГРЫ

/**
 * Победилель в этой игре
 */
static NSString *GAMER_STATUS_WINNER = @"WINNER";

/**
 * Проигравший в этой игре
 */
static NSString *GAMER_STATUS_LOOSER = @"LOOSER";

/**
 * Ничья
 */
static NSString *GAMER_STATUS_DRAW = @"DRAW";

/**
 * Игрок сдался в этой игре
 */
static NSString *GAMER_STATUS_SURRENDED = @"SURRENDED";

/**
 * Опонент сдался в этой игре (Победа из-за того что сдался игрок)
 */
static NSString *GAMER_STATUS_OPONENT_SURRENDED = @"OPONENT_SURRENDED";

@interface GamerStatus : NSString

@end
