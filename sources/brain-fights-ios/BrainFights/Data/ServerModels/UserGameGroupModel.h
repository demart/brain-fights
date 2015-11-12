//
//  UserGameGroupModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameStatus.h"

@interface UserGameGroupModel : NSObject

/**
 * Статус
 */
@property NSString *status;

/**
 * Игры пользователя
 */
@property NSMutableArray *games;

@end
