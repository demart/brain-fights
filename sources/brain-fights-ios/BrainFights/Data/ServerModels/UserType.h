//
//  UserType.h
//  BrainFights
//
//  Created by Artem Demidovich on 11/9/15.
//  Copyright © 2015 Aphion Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 UserType:
 * Сам игрок
 ME,
 
 * Друг
 FRIEND,
 
 * Просто противник
 OPONENT,
 */


/**
 * Профиль игрока (самого себя)
 */
static NSString *USER_TYPE_ME = @"ME";

/**
 * Профиль другая (мой друг)
 */
static NSString *USER_TYPE_FRIEND = @"FRIEND";

/**
 * Профиль опонента (ни другй и не мой профиль)
 */
static NSString *USER_TYPE_OPONENT = @"OPONENT";

@interface UserType : NSString

@end
