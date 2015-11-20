//
//  GamerQuestionAnswerResultModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/19/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameStatus.h"
#import "GameRoundStatus.h"
#import "GamerStatus.h"

@interface GamerQuestionAnswerResultModel : NSObject

/**
 * Статус игры после ответа
 */
@property NSString *gameStatus;

/**
 * Статус раунда после ответа
 */
@property NSString *gameRoundStatus;

/**
 * Статус для игрока после ответа
 */
@property NSString *gamerStatus;

/**
 * На сколько изменился рейтинг пользователя после этого ответа (если это последний ответ в игре)
 */
@property NSInteger gamerScore;

@end
