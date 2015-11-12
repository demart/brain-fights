//
//  UserGamesModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserProfileModel.h"

@interface UserGamesModel : NSObject

// Профиль игрока
@property UserProfileModel *user;

// Игры пользователя
@property NSMutableArray *games;

@end
