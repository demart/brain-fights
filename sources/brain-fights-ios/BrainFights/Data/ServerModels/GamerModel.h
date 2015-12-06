//
//  GamerModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserProfileModel.h"
#import "GamerStatus.h"

@interface GamerModel : NSObject

/**
 * Идентификатор игрока
 */
@property NSUInteger id;

/**
 * Профиль пользователя
 */
@property UserProfileModel *user;

/**
 * Статус игрока
 */
@property NSString *status;

/**
 * Кол-во правильных ответов
 */
@property NSInteger correctAnswerCount;


/**
 * Результатов
 */
@property NSInteger resultScore;

/**
 * Было ли просмотрено уведомление об окончании игры
 */
@property Boolean resultWasViewed;


/**
 * Время последнего обновления
 * Формат ISO 8601
 */
@property NSString *lastUpdateStatusDate;

// Время последнего обновления в формате
-(NSDate*) getLastUpdateStatusDate;

@end
