//
//  UserGamesGroupedModel.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/8/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileModel.h"

@interface UserGamesGroupedModel : NSObject

// Профиль пользователя
@property UserProfileModel *user;

// Список игр сгруппированных по статусу игры
@property NSMutableArray *gameGroups;

@end
